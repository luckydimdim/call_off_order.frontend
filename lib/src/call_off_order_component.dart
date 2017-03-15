import 'dart:html';
import 'dart:math' as math;

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

@Component(
  selector: 'call-off-order',
  templateUrl: 'call_off_order_component.html',
  directives: const [DateRangePickerDirective])
class CallOffOrderComponent {
  static const String route_name = 'CallOffOrder';
  static const String route_path = 'call-off-order';
  static const Route route = const Route(
    path: CallOffOrderComponent.route_path,
    component: CallOffOrderComponent,
    name: CallOffOrderComponent.route_name,
    useAsDefault: true);

  final Router _router;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  CallOffOrderComponent(this._router) {
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
      ..monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];

    dateRangePickerOptions = new DateRangePickerOptions()
      ..locale = locale;
  }
}