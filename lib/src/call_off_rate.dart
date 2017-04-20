import 'dart:convert';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Ставка наряд-заказа
 */
@reflectable
class CallOffRate extends Object with JsonConverter, MapConverter {
  // Уникальный id ставки, берется из базы
  String id = null;

  @Json(exclude: true)
  // Id ставки, использующийся для построения UI
  String tempId = null;

  // Название ставки
  String name = '';

  // Является ли элемент ставкой или группой ставок
  // (влияет на отображение контролов ввода суммы и ед. изменрения)
  bool isRate = true;

  // Величина ставки
  @Json(exclude: true)
  String amount = '';

  // Валюта ставки
  String currency = 'USD';

  // Начальное значение единицы измерения ставки
  String unitName = 'день';

  // Id группы
  String parentId = null;

  
  // Доступна ли возможность переключения типа элемента:
  // ставка или группа ставок
  @Json(exclude: true)
  bool canToggle = true;

  @Json(exclude: true)
  // Отображать или нет контролы удаления и добавления ставки
  bool showMinus = true;

  CallOffRate();

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);
    amount = json['amount'].toString();

    return this;
  }

  @override
  Map toJson() {
    Map map = super.toJson();
    map['amount'] = double.parse(amount);

    return map;
  }
}
