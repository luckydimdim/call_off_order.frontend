import 'dart:convert';

/**
 * Базовый шаблон наряд-закахов.
 * Нужен для обощения работы с web-сервисом.
 */
abstract class CallOffOrderTemplateModelBase {
  /**
   * Системное имя шаблона
   */
  String SysName = '';

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

  CallOffOrderTemplateModelBase fromJsonString(dynamic json) {
    assignee = json['assignee'];
    name = json['name'];
    number = json['number'];
    startDate = json['startDate'];
    finishDate = json['finishDate'];
    position = json['position'];
    location = json['location'];

    return this;
  }

  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }

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