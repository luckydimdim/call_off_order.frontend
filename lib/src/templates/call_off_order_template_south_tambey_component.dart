import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'call_off_order_template_south_tambey_model.dart';

@Component(
    selector: 'call-off-order-template-south-tambey',
    templateUrl: 'call_off_order_template_south_tambey_component.html',
    directives: const [DateRangePickerDirective])
class CallOffOrderTemplateSouthTambeyComponent implements OnInit  {
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();
  DateRangePickerOptions mobDateRangePickerOptions =
      new DateRangePickerOptions();

  @Input()
  bool readOnly = true;

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic updateTemplate = new EventEmitter<dynamic>();

  @Input()
  CallOffOrderTemplateSouthTambeyModel model = null;

  CallOffOrderTemplateSouthTambeyComponent() {
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

    mobDateRangePickerOptions = new DateRangePickerOptions()
      ..locale = locale
      ..singleDatePicker = true;
  }

  @override
  ngOnInit() {
    dateRangePickerOptions.minDate = model.minDateStr;
    dateRangePickerOptions.maxDate = model.maxDateStr;
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
  emitUpdateTemplate() {
    updateTemplate.emit(model);
  }

  /**
   * Обновление сроков наряд-аказа
   */
  Future datesSelected(Map<String, DateTime> value) async {
    model.startDate = value['start'];
    model.finishDate = value['end'];

    emitUpdateTemplate();

    return null;
  }

  /**
   * Обновление даты мобилизации
   */
  Future mobDateSelected(Map<String, DateTime> value) async {
    model.mobDate = value['start'];

    emitUpdateTemplate();

    return null;
  }

  String getDates() {
    String result = '';

    if (model.startDate != null && model.finishDate != null)
      result = '${model.startDateStr} - ${model.finishDateStr}';

    if (model.startDate == null && model.finishDate == null) result = '';

    if (model.startDate == null) result = model.finishDateStr;

    if (model.finishDate == null) result = model.startDateStr;

    return result;
  }
}