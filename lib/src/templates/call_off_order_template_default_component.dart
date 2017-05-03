import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:intl/intl.dart';
import 'package:logger/logger_service.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'package:call_off_order/call_off_service.dart';
import 'call_off_order_template_default_model.dart';

@Component(
  selector: 'call-off-order-template-default',
  templateUrl: 'call_off_order_template_default_component.html',
  providers: const [CallOffService],
  directives: const [DateRangePickerDirective])
class CallOffOrderTemplateDefaultComponent {
  final LoggerService _logger;
  final CallOffService _service;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  @Input()
  bool readOnly = true;

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic updateTemplate = new EventEmitter<dynamic>();

  @Input()
  CallOffOrderTemplateDefaultModel model = new CallOffOrderTemplateDefaultModel();
  //String dates = '';

  CallOffOrderTemplateDefaultComponent(this._logger, this._service) {
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
  emitUpdateTemplate() {
    updateTemplate.emit(model);
  }

  /**
   * Обновление сроков
   */
  Future datesSelected(Map<String, DateTime> value) async {
    var formatter = new DateFormat('dd.MM.yyyy');

    model.startDate = formatter.format(value['start']);
    model.finishDate = formatter.format(value['end']);

    emitUpdateTemplate();

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