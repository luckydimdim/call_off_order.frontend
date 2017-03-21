import 'dart:convert';

import 'call_off_rate.dart';
import 'templates/call_off_order_template_default_model.dart';
import 'templates/call_off_order_template_model_base.dart';


/**
 * Наряд-заказ
 */
class CallOffOrder {
  String id = '';

  /**
   * Шаблон с дополнительными полями ввода
   */
  CallOffOrderTemplateModelBase template = new CallOffOrderTemplateDefaultModel();

  /**
   * Список ставок наряд-заказа
   */
  List<CallOffRate> rates = new List<CallOffRate>();

  CallOffOrder();

  factory CallOffOrder.fromJson(dynamic json) {
    List<CallOffRate> rateList = new List<CallOffRate>();

    var ratesJson = (json['rates'] as List<dynamic>);
    ratesJson.forEach(
        (rateJson) => rateList.add(new CallOffRate.fromJson(rateJson)));

    return new CallOffOrder()..rates = rateList;
  }

  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }

  Map toMap() {
    var map = new Map();

    map['id'] = id;
    map.addAll(template.toMap());

    var list = new List<Map>();

    for (CallOffRate rate in rates) {
      list.add(rate.toMap());
    }

    map['rates'] = list;

    return map;
  }
}