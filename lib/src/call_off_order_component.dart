import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:logger/logger_service.dart';

import 'package:daterangepicker/daterangepicker.dart';

import 'call_off_rate.dart';
import 'call_off_order.dart';
import 'call_off_rate_component.dart';
import 'call_off_service.dart';
import 'templates/call_off_order_template_default_component.dart';

@Component(
    selector: 'call-off-order',
    templateUrl: 'call_off_order_component.html',
    providers: const [CallOffService],
    directives: const [CallOffRateComponent, CallOffOrderTemplateDefaultComponent])
class CallOffOrderComponent implements OnInit {
  static const String route_name = 'CallOffOrder';
  static const String route_path = 'call-off-order';
  static const Route route = const Route(
      path: CallOffOrderComponent.route_path,
      component: CallOffOrderComponent,
      name: CallOffOrderComponent.route_name,
      useAsDefault: true);

  final LoggerService _logger;
  final CallOffService _service;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  @Input()
  String id = '';

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic callOfChanged = new EventEmitter<Map>();

  CallOffOrder model = new CallOffOrder();
  String dates = '';

  CallOffOrderComponent(this._logger, this._service) {
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
   * Обновление наряд-заказа
   */
  Future updateCallOffOrder() async {
    callOfChanged.emit(model.template.toMap());

    await _service.updateCallOffOrder(model);
  }

  /**
   * Добавление ставки или группы ставок
   */
  void addRate(CallOffRateComponent rate) {
    // Если исходная ставка не задана или если задана,
    // но она корневая и не является группой
    if (rate == null || (!rate.model.isChild && rate.model.isRate)) {
      // Создание группы ставок
      _addRateParent();
    } else {
      // Создание ставки
      _addRateChild(rate);
    }
  }

  /**
   * Добавление группы ставок
   */
  void _addRateParent() {
    var id = model.rates.length + 1;

    model.rates.add(new CallOffRate()
      ..id = id
      ..isChild = false
      ..isRate = false
      ..canToggle = true
      ..showMinus = true
      ..unitName = 'день');
  }

  /**
   * Добавление ставки
   */
  void _addRateChild(CallOffRateComponent sourceRateComponent) {
    var id = model.rates.length + 1;

    // Получение индекса родительской ставки для того чтобы
    // вставить дочернюю ставку сразу после нее
    CallOffRate sourceRate = model.rates
        .singleWhere((item) => item.id == sourceRateComponent.model.id);
    int sourceRateIndex = model.rates.indexOf(sourceRate);

    model.rates.insert(
        sourceRateIndex + 1,
        new CallOffRate()
          ..id = id
          ..isChild = true
          ..isRate = true
          ..canToggle = false
          ..showMinus = true
          ..unitName = 'день');

    // Скрывание +/- у родительской ставки чтобы ее нельзя было удалить
    // пока у нее есть дочерние ставки
    if (!sourceRate.isChild) sourceRate.showMinus = false;
  }

  /**
   * Удаление ставки или группы
   */
  void removeRate(CallOffRateComponent sourceRateComponent) {
    // Получение индекса предыдущей по очереди ставки
    CallOffRate sourceRate = model.rates
        .singleWhere((item) => item.id == sourceRateComponent.model.id);

    int rateIndex = model.rates.indexOf(sourceRate);
    int previousRateIndex = rateIndex - 1;
    int nextRateIndex = rateIndex + 1;

    if (previousRateIndex >= 0) {
      CallOffRate previousRate = model.rates.elementAt(previousRateIndex);

      // Если это группа ставок, а не ставка
      if (!previousRate.isChild) {
        // Если следующая по очереди ставка существует
        if (model.rates.length >= nextRateIndex + 1) {
          CallOffRate nextRate = model.rates.elementAt(nextRateIndex);

          // ...и это ставка, а не группа ставок
          if (!nextRate.isChild) {
            // Отображается +/-
            previousRate.showMinus = true;
          }
          // Если после этой родительской ставки вообще нет никаких ставок
        } else {
          // Отображается +/-
          previousRate.showMinus = true;
        }
      }
    }

    model.rates.removeWhere((item) => item.id == sourceRateComponent.model.id);
  }

  @override
  Future ngOnInit() async {
    model = await _service.getCallOffOrder(id);
  }
}