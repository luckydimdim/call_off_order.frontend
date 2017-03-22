import 'dart:convert';

import 'call_off_order_template_model_base.dart';

/**
 * Шаблон верхней части наряд заказа
 */
class CallOffOrderTemplateSouthTambeyModel extends CallOffOrderTemplateModelBase {
  @override
  /**
   * Системное имя шаблона
   */
  String sysName = 'SouthTambey';

  /**
   * Табельный номер
   */
  String employeeNumber = '';

  /**
   * Номер позиции
   */
  String positionNumber = '';

  /**
   * Происхождение персонала
   */
  String personnelSource = '';

  /**
   * Номер PAAF
   */
  String paaf = '';

  /**
   * Ссылка плана мобилизации
   */
  String mobPlanReference = '';

  /**
   * Дата мобилизации
   */
  String mobDate = '';

  @override
  CallOffOrderTemplateSouthTambeyModel fromJsonString(dynamic json) {
    super.fromJsonString(json);

    employeeNumber = json['employeeNumber'];
    positionNumber = json['positionNumber'];
    personnelSource = json['personnelSource'];
    paaf = json['paaf'];
    mobPlanReference = json['mobPlanReference'];
    mobDate = json['mobDate'];

    return this;
  }

  /*@override
  String toJsonString() {
    var map = toMap();

    return JSON.encode(map);
  }*/

  @override
  Map toMap() {
    var baseMap = super.toMap();

    var map = new Map();

    map['employeeNumber'] = employeeNumber;
    map['positionNumber'] = positionNumber;
    map['personnelSource'] = personnelSource;
    map['paaf'] = paaf;
    map['mobPlanReference'] = mobPlanReference;
    map['mobDate'] = mobDate;

    baseMap.addAll(map);

    return baseMap;
  }
}