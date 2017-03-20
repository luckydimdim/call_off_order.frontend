import 'dart:convert';

import 'call_off_rate.dart';

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
   * ФИО работника
   */
  String assignee = '';

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
   * Должность
   */
  String position = '';

  /**
   * Место работы
   */
  String location = '';

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

    return new CallOffOrder()
      ..id = json['id']
      ..contractId = json['contractId']
      ..assignee = json['assignee']
      ..name = json['name']
      ..number = json['number']
      ..startDate = json['startDate']
      ..finishDate = json['finishDate']
      ..position = json['position']
      ..location = json['location']
      ..rates = rateList;
  }

  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }

  Map toMap() {
    var map = new Map();

    map['id'] = id;
    map['contractId'] = contractId;
    map['assignee'] = assignee;
    map['name'] = name;
    map['number'] = number;
    map['startDate'] = startDate;
    map['finishDate'] = finishDate;
    map['position'] = position;
    map['location'] = location;

    var list = new List<Map>();

    for (CallOffRate rate in rates) {
      list.add(rate.toMap());
    }

    map['rates'] = list;

    return map;
  }
}
