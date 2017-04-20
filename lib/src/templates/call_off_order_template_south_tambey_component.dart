import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:intl/intl.dart';
import 'package:logger/logger_service.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'package:call_off_order/call_off_service.dart';
import 'call_off_order_template_south_tambey_model.dart';

@Component(
  selector: 'call-off-order-template-south-tambey',
  templateUrl: 'call_off_order_template_south_tambey_component.html',
  providers: const [CallOffService],
  directives: const [DateRangePickerDirective])
class CallOffOrderTemplateSouthTambeyComponent {
  final LoggerService _logger;
  final CallOffService _service;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();
  DateRangePickerOptions mobDateRangePickerOptions = new DateRangePickerOptions();

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic templateChanged = new EventEmitter<dynamic>();

  @Input()
  CallOffOrderTemplateSouthTambeyModel model = new CallOffOrderTemplateSouthTambeyModel();

  CallOffOrderTemplateSouthTambeyComponent(this._logger, this._service) {
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

    dateRangePickerOptions = new DateRangePickerOptions()
      ..locale = locale;

    mobDateRangePickerOptions = new DateRangePickerOptions()
      ..locale = locale
      ..singleDatePicker = true;
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
  updateCallOffOrderTemplate() {
    templateChanged.emit(model);
  }

  /**
   * Обновление сроков наряд-аказа
   */
  Future datesSelected(Map<String, DateTime> value) async {
    var formatter = new DateFormat('dd.MM.yyyy');

    model.startDate = formatter.format(value['start']);
    model.finishDate = formatter.format(value['end']);

    updateCallOffOrderTemplate();

    return null;
  }

  /**
   * Обновление даты мобилизации
   */
  Future mobDateSelected(Map<String, DateTime> value) async {
    var formatter = new DateFormat('dd.MM.yyyy');

    model.mobDate = formatter.format(value['start']);

    updateCallOffOrderTemplate();

    return null;
  }

  String getDates() {
    String result = '';

    if (model.startDate != '' && model.finishDate != '')
      result = '${model.startDate} - ${model.finishDate}';

    if (model.startDate == '' && model.finishDate == '')
      result = '';

    if (model.startDate == '')
      result = model.finishDate;

    if (model.finishDate == '')
      result = model.startDate;

    return result;
  }
}