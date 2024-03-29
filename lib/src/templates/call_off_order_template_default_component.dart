import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'call_off_order_template_default_model.dart';

@Component(
    selector: 'call-off-order-template-default',
    templateUrl: 'call_off_order_template_default_component.html',
    directives: const [DateRangePickerDirective])
class CallOffOrderTemplateDefaultComponent implements OnInit {
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  @Input()
  bool readOnly = true;

  @Output()
  /**
   * Событие обновления ставки во внешний компонент
   */
  dynamic updateTemplate = new EventEmitter<dynamic>();

  @Input()
  CallOffOrderTemplateDefaultModel model = null;

  CallOffOrderTemplateDefaultComponent() {
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
   * Обновление сроков
   */
  Future datesSelected(Map<String, DateTime> value) async {
    model.startDate = value['start'];
    model.finishDate = value['end'];

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
