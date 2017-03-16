import 'dart:math';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'package:call_off_order/src/call_off_rate.dart';
import 'package:call_off_order/call_off_rate_component.dart';

@Component(
  selector: 'call-off-order',
  templateUrl: 'call_off_order_component.html',
  directives: const [DateRangePickerDirective, CallOffRateComponent])
class CallOffOrderComponent {
  static const String route_name = 'CallOffOrder';
  static const String route_path = 'call-off-order';
  static const Route route = const Route(
    path: CallOffOrderComponent.route_path,
    component: CallOffOrderComponent,
    name: CallOffOrderComponent.route_name,
    useAsDefault: true);

  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();
  List<CallOffRate> rates = new List<CallOffRate>();

  CallOffOrderComponent() {
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

    rates.add(new CallOffRate(1, isChild: false, isRate: false, canToggle: true, showPlusMinus: true));
  }

  /**
   * Добавление ставки или группы ставок
   */
  void addRate(CallOffRateComponent rate) {
    // Если исходная ставка не задана или если задана,
    // но она корневая и не является группой
    if (rate == null || (!rate.isChild && rate.isRate)) {

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
    var rnd = new Random();

    rates.add(new CallOffRate(
      /*rate.id,*/
      rnd.nextInt(100),
      isChild: false,
      isRate: false,
      canToggle: true,
      showPlusMinus: true));
  }

  /**
   * Добавление ставки
   */
  void _addRateChild(CallOffRateComponent sourceRateComponent) {
    var rnd = new Random();

    // Получение индекса родительской ставки для того чтобы
    // вставить дочернюю ставку сразу после нее
    CallOffRate sourceRate = rates.singleWhere(
        (item) => item.id == sourceRateComponent.id);
    int sourceRateIndex = rates.indexOf(sourceRate);

    rates.insert(sourceRateIndex + 1, new CallOffRate(
      /*rate.id,*/
      rnd.nextInt(100),
      isChild: true,
      isRate: true,
      canToggle: false,
      showPlusMinus: true));

    // Скрывание +/- у родительской ставки чтобы ее нельзя было удалить
    // пока у нее есть дочерние ставки
    if (!sourceRate.isChild)
      sourceRate.showPlusMinus = false;
  }

  /**
   * Удаление ставки или группы
   */
  void removeRate(CallOffRateComponent sourceRateComponent) {
    // Получение индекса предыдущей по очереди ставки
    CallOffRate sourceRate = rates.singleWhere(
        (item) => item.id == sourceRateComponent.id);

    int rateIndex = rates.indexOf(sourceRate);
    int previousRateIndex = rateIndex - 1;
    int nextRateIndex = rateIndex + 1;

    if (previousRateIndex >= 0) {
      CallOffRate previousRate = rates.elementAt(previousRateIndex);

      //previousRate.showPlusMinus = true;

      // Если это группа ставок, а не ставка
      if (!previousRate.isChild) {

        // Если следующая по очереди ставка существует
        if (rates.length >= nextRateIndex + 1) {
          CallOffRate nextRate = rates.elementAt(nextRateIndex);

          // ...и это ставка, а не группа ставок
          if (!nextRate.isChild)
          {
            // Отображается +/-
            previousRate.showPlusMinus = true;
          }
        // Если после этой родительской ставки вообще нет никаких ставок
        } else {

          // Отображается +/-
          previousRate.showPlusMinus = true;
        }
      }
    }

    rates.removeWhere((item) => item.id == sourceRateComponent.id);
  }
}