import 'dart:convert';

import 'call_off_rate.dart';
import 'templates/call_off_order_template_default_model.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_south_tambey_model.dart';


/**
 * Наряд-заказ
 */
class CallOffOrder {
  String id = '';
  String contractId = '';

  /**
   * Шаблон с дополнительными полями ввода
   */
  CallOffOrderTemplateModelBase template;

  /**
   * Список ставок наряд-заказа
   */
  List<CallOffRate> rates = new List<CallOffRate>();

  CallOffOrder();

  factory CallOffOrder.fromJson(dynamic json) {
    List<CallOffRate> rateList = new List<CallOffRate>();

    var ratesJson = (json['rates'] as List<dynamic>);

    for (var rateJson in ratesJson) {
      rateList.add(new CallOffRate.fromJson(rateJson));
    }

    // Задание необходимых для правильного отображения свойств ставок:
    // кнопки минуса, переключателя группа/ставка
    List<CallOffRate> parentRates = rateList.where((item) =>
      item.parentId == null).toList();

    for (CallOffRate parentRate in parentRates) {
      CallOffRate firstChildRate = rateList.firstWhere((item) =>
      item.parentId == parentRate.id, orElse: () => null);

      bool hasChildren = firstChildRate != null;

      parentRate.showMinus = !hasChildren;
      parentRate.canToggle = !hasChildren;
    }

    List<CallOffRate> childrenRates = rateList.where((item) =>
      item.parentId != null).toList();
    childrenRates.forEach((item) => item.canToggle = false);

    return new CallOffOrder()
      ..rates = rateList
      ..id = json['id']
      ..contractId = json['contractId'];
  }

  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }

  Map toMap() {
    var map = new Map();

    map['id'] = id;
    map['contractId'] = contractId;

    map.addAll(template.toMap());

    var list = new List<Map>();

    for (CallOffRate rate in rates) {
      list.add(rate.toMap());
    }

    map['rates'] = list;

    return map;
  }
}