import 'dart:math';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:logger/logger_service.dart';
import 'package:config/config_service.dart';

import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';

import 'package:call_off_order/src/call_off_rate.dart';
import 'package:call_off_order/src/call_off_order.dart';
import 'package:call_off_order/call_off_rate_component.dart';
import 'package:call_off_order/call_off_service.dart';

@Component(
  selector: 'call-off-order',
  templateUrl: 'call_off_order_component.html',
  providers: const [CallOffService],
  directives: const [DateRangePickerDirective, CallOffRateComponent])
class CallOffOrderComponent {
  static const String route_name = 'CallOffOrder';
  static const String route_path = 'call-off-order';
  static const Route route = const Route(
    path: CallOffOrderComponent.route_path,
    component: CallOffOrderComponent,
    name: CallOffOrderComponent.route_name,
    useAsDefault: true);

  final LoggerService _logger;
  final ConfigService _config;
  final CallOffService _service;
  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();
  CallOffOrder model = new CallOffOrder();

  CallOffOrderComponent(this._logger, this._config, this._service) {
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

    // FIXME: initial data, remove it
    model.rates.add(new CallOffRate(id: 1, isChild: false, isRate: false, canToggle: true, showPlusMinus: true, unitName: 'день'));
  }

  /**
   * Обновление наряд-заказа
   */
  updateCallOffOrder() async {
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
    var rnd = new Random();

    model.rates.add(new CallOffRate(
      /*rate.id,*/
      id: rnd.nextInt(100),
      isChild: false,
      isRate: false,
      canToggle: true,
      showPlusMinus: true,
      unitName: 'день'));
  }

  /**
   * Добавление ставки
   */
  void _addRateChild(CallOffRateComponent sourceRateComponent) {
    var rnd = new Random();

    // Получение индекса родительской ставки для того чтобы
    // вставить дочернюю ставку сразу после нее
    CallOffRate sourceRate = model.rates.singleWhere(
        (item) => item.id == sourceRateComponent.model.id);
    int sourceRateIndex = model.rates.indexOf(sourceRate);

    model.rates.insert(sourceRateIndex + 1, new CallOffRate(
      /*rate.id,*/
      id: rnd.nextInt(100),
      isChild: true,
      isRate: true,
      canToggle: false,
      showPlusMinus: true,
      unitName: 'день'));

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
    CallOffRate sourceRate = model.rates.singleWhere(
        (item) => item.id == sourceRateComponent.model.id);

    int rateIndex = model.rates.indexOf(sourceRate);
    int previousRateIndex = rateIndex - 1;
    int nextRateIndex = rateIndex + 1;

    if (previousRateIndex >= 0) {
      CallOffRate previousRate = model.rates.elementAt(previousRateIndex);

      //previousRate.showPlusMinus = true;

      // Если это группа ставок, а не ставка
      if (!previousRate.isChild) {

        // Если следующая по очереди ставка существует
        if (model.rates.length >= nextRateIndex + 1) {
          CallOffRate nextRate = model.rates.elementAt(nextRateIndex);

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

    model.rates.removeWhere((item) => item.id == sourceRateComponent.model.id);
  }
}