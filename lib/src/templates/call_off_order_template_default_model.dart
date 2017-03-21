import 'dart:convert';

import 'call_off_order_template_model_base.dart';

/**
 * Шаблон верхней части наряд заказа
 */
class CallOffOrderTemplateDefaultModel implements CallOffOrderTemplateModelBase {
  @override
  String SysName = 'Annotech';

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

  CallOffOrderTemplateDefaultModel();

  @override
  CallOffOrderTemplateDefaultModel fromJsonString(dynamic json) {
    return new CallOffOrderTemplateDefaultModel()
      ..assignee = json['assignee']
      ..name = json['name']
      ..number = json['number']
      ..startDate = json['startDate']
      ..finishDate = json['finishDate']
      ..position = json['position']
      ..location = json['location'];
  }

  @override
  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }

  @override
  Map toMap() {
    var map = new Map();

    map['assignee'] = assignee;
    map['name'] = name;
    map['number'] = number;
    map['startDate'] = startDate;
    map['finishDate'] = finishDate;
    map['position'] = position;
    map['location'] = location;

    return map;
  }
}