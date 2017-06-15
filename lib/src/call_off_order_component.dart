import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:uuid/uuid.dart';

import 'package:auth/auth_service.dart';
import 'package:daterangepicker/daterangepicker.dart';
import 'package:angular_utils/directives.dart';
import 'call_off_rate.dart';
import 'call_off_order.dart';
import 'call_off_rate_component.dart';
import 'call_off_service.dart';
import 'call_off_order_to_create.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_default_component.dart';
import 'templates/call_off_order_template_south_tambey_component.dart';
import 'templates/rate_unit.dart';

@Component(
    selector: 'call-off-order',
    templateUrl: 'call_off_order_component.html',
    providers: const [
      CallOffService
    ],
    directives: const [
      CallOffRateComponent,
      CallOffOrderTemplateDefaultComponent,
      CallOffOrderTemplateSouthTambeyComponent,
      CmLoadingBtnDirective,
      CmLoadingSpinComponent
    ])
class CallOffOrderComponent implements OnInit {
  static const String route_name = 'CallOffOrder';
  static const String route_path = 'call-off-order';
  static const Route route = const Route(
      path: CallOffOrderComponent.route_path,
      component: CallOffOrderComponent,
      name: CallOffOrderComponent.route_name,
      useAsDefault: true);

  final CallOffService _service;
  final AuthorizationService _authorizationService;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  bool readOnly = true;

  @Input()
  String id = '';

  @Input()
  bool creatingMode = false;

  @Input()
  String contractId = '';

  @Input()
  String templateSysName = '';

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic callOfChanged = new EventEmitter<Map>();

  @Output()
  /**
   * Событие жмакания на кнопку "Завершить"
   */
  dynamic onFinish = new EventEmitter<dynamic>();

  @Output()
  /**
   * Событие жмакания на кнопку "Отмена"
   */
  dynamic onCancel = new EventEmitter<dynamic>();

  CallOffOrder model = null;
  String dates = '';

  // GUID generator
  Uuid guid = new Uuid();

  CallOffOrderComponent(this._service, this._authorizationService) {
    var locale = new DateRangePickerLocale()
      ..format = 'DD.MM.YYYY'
      ..separator = ' - '
      ..applyLabel = 'Применить'
      ..cancelLabel = 'Отменить'
      ..fromLabel = 'С'
      ..toLabel = 'По'
      ..customRangeLabel = 'Custom'
      ..weekLabel = 'W'
      ..firstDay = 1
      ..daysOfWeek = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
      ..monthNames = [
        'Январь',
        'Февраль',
        'Март',
        'Апрель',
        'Май',
        'Июнь',
        'Июль',
        'Август',
        'Сентябрь',
        'Октябрь',
        'Ноябрь',
        'Декабрь'
      ];

    dateRangePickerOptions = new DateRangePickerOptions()..locale = locale;
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };

  /**
   * Обновление модели наряд-заказа
   */
  updateTemplate(CallOffOrderTemplateModelBase template) {
    model.template = template;
    callOfChanged.emit(model.toMap());
  }

  /**
   * Добавление ставки или группы ставок
   */
  Future addRate(CallOffRate rateModel) async {
    CallOffRate newRate = null;

    // Если исходная ставка не задана или если задана,
    // но она корневая и не является группой
    if (rateModel == null || (rateModel.parentId == null && rateModel.isRate)) {
      // Создание группы ставок
      newRate = _addRateParent();
    } else {
      // Создание ставки
      newRate = _addRateChild(rateModel);
    }
  }

  /**
   * Добавление группы ставок
   */
  CallOffRate _addRateParent() {
    var rate = new CallOffRate()
      ..id = guid.v1()
      ..parentId = null
      ..isRate = false
      ..canToggle = true
      ..showMinus = true
      ..unit = RateUnit.day;

    model.rates.add(rate);

    return rate;
  }

  /**
   * Добавление ставки
   */
  CallOffRate _addRateChild(CallOffRate rateModel) {
    // Получение индекса родительской ставки для того чтобы
    // вставить дочернюю ставку сразу после нее
    CallOffRate sourceRate =
        model.rates.singleWhere((item) => item.id == rateModel.id);
    int sourceRateIndex = model.rates.indexOf(sourceRate);

    var rate = new CallOffRate()
      ..id = guid.v1()
      ..parentId = sourceRate.isRate ? sourceRate.parentId : sourceRate.id
      ..isRate = true
      ..canToggle = false
      ..showMinus = true
      ..showPlus = true
      ..unit = RateUnit.day;

    model.rates.insert(sourceRateIndex + 1, rate);

    sourceRate.showPlus = false;

    // Скрывание +/- у родительской ставки чтобы ее нельзя было удалить
    // пока у нее есть дочерние ставки
    if (sourceRate.parentId == null) {
      sourceRate.showMinus = false;
      sourceRate.canToggle = false;
    }

    return rate;
  }

  /**
   * Удаление ставки или группы
   */
  Future removeRate(CallOffRate rateModel) async {
    // Получение индекса предыдущей по очереди ставки
    CallOffRate sourceRate =
        model.rates.singleWhere((item) => item.id == rateModel.id);

    int rateIndex = model.rates.indexOf(sourceRate);
    int previousRateIndex = rateIndex - 1;
    int nextRateIndex = rateIndex + 1;

    if (previousRateIndex >= 0) {
      CallOffRate previousRate = model.rates.elementAt(previousRateIndex);

      // Если это группа ставок, а не ставка
      if (previousRate.parentId == null) {
        // Если следующая по очереди ставка существует
        if (model.rates.length >= nextRateIndex + 1) {
          CallOffRate nextRate = model.rates.elementAt(nextRateIndex);

          // ...и это ставка, а не группа ставок
          if (nextRate.parentId != null) {
            // Отображается +/-
            previousRate.showMinus = true;
            previousRate.showPlus = true;
          }
          // Если после этой родительской ставки вообще нет никаких ставок
        } else {
          // Отображается +/-
          previousRate.showMinus = true;
          previousRate.showPlus = true;
          previousRate.canToggle = true;
        }
      } else {
        previousRate.showPlus = true;
      }
    }

    model.rates.removeWhere((item) => item.id == rateModel.id);
  }

  /**
   * Обновление ставки или группы ставок
   */
  Future updateRate(int index, CallOffRate rateModel) async {
    model.rates[index] = rateModel;
  }

  @override
  Future ngOnInit() async {
    if (_authorizationService.isInRole(Role.Customer)) readOnly = false;

    if (creatingMode) {
      model = await createCallOff();
    } else {
      model = await _service.getCallOffOrder(id);
      if (!readOnly) {
        readOnly =
            model.hasTimeSheets; // если есть табели, то нельзя редактировать
      }
    }
  }

  // создать заготовку для наряд заказа при его создании
  Future<CallOffOrder> createCallOff() async {
    CallOffOrder callOffOrder = new CallOffOrder.initTemplate(templateSysName);

    CallOffOrderToCreate callOffOrderToCreate =
        await _service.callOffOrderToCreate(contractId);

    callOffOrder.template.minDate = callOffOrderToCreate.minDate;
    callOffOrder.template.maxDate = callOffOrderToCreate.maxDate;

    callOffOrder.template.currencies = callOffOrderToCreate.currencies;
    callOffOrder.template.currencySysName =
        callOffOrderToCreate.currencySysName;
    callOffOrder.contractId = contractId;

    return callOffOrder;
  }

  /**
   * Нажатие на кнопку "Завершить"
   */
  Future finish() async {
    if (creatingMode) {
      model.id = await _service.createCallOffOrder(model);
      creatingMode = false;
      callOfChanged.emit(model.toMap());
    } else {
      await _service.updateCallOffOrder(model);
    }

    onFinish.emit(null);
  }

  /**
   * Нажатие на кнопку "Омена"
   */
  Future cancel() async {
    onCancel.emit(null);
  }
}
