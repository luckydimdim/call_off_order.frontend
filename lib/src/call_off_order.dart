import 'dart:convert';

import 'package:call_off_order/src/call_off_rate.dart';

/**
 * Наряд-заказ
 */
class CallOffOrder {
  /**
   * Внутренний id
   */
  String id = '';

  /**
   * Id контракта, к которому отногсится данный наряд-заказ
   */
  String contractId = '';

  /**
   * Наименование услуги
   */
  String name = '';

  /**
   * Номер наряд-заказа
   */
  String number = '';

  /**
   * Дата начала действия наряд-заказа
   */
  String startDate = '';

  /**
   * Дата окончания действия наряд-заказа
   */
  String finishDate = '';

  /**
   * Список ставок наряд-заказа
   */
  List<CallOffRate> rates = new List<CallOffRate>();

  CallOffOrder();

  factory CallOffOrder.fromJson(dynamic json) {
    List<CallOffRate> rateList = new List<CallOffRate>();

    var ratesJson = (json['rates'] as List<dynamic>);
    ratesJson.forEach((rateJson) =>
      rateList.add(new CallOffRate.fromJson(rateJson))
    );

    return new CallOffOrder()
      ..id = json['id']
      ..contractId = json['contractId']
      ..name = json['name']
      ..number = json['number']
      ..startDate = json['startDate']
      ..finishDate = json['finishDate']
      ..rates = rateList;
  }

  String toJsonString() {
    var map = new Map();

    map['id'] = id;
    map['contractId'] = contractId;
    map['name'] = name;
    map['number'] = number;
    map['startDate'] = startDate;
    map['finishDate'] = finishDate;

    rates.forEach((rate) => map['rates'] += rate.toJsonString());

    return JSON.encode(map);
  }
}