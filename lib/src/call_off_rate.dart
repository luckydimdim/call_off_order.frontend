import 'dart:convert';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Ставка наряд-заказа
 */
@reflectable
class CallOffRate extends Object with JsonConverter, MapConverter {
  /**
   * Уникальный id ставки, берется из базы
   */
  int id = 0;

  /**
   * Название ставки
   */
  String name = '';

  /**
   * Является ли элемент ставкой или группой ставок
   * (влияет на отображение контролов ввода суммы и ед. изменрения)
   */
  bool isRate = true;

  /**
   * Величина ставки
   */
  double amount = 0.0;

  /**
   * Валюта ставки
   */
  String currency = 'USD';

  /**
   * Начальное значение единицы измерения ставки
   */
  String unitName = 'день';

  /**
   *
   */
  int parentId = null;

  /**
   * Доступна ли возможность переключения типа элемента:
   * ставка или группа ставок
   */
  @Json(exclude: true)
  bool canToggle = true;

  /**
   * Отображать или нет контролы удаления и добавления ставки
   */
  @Json(exclude: true)
  bool showMinus = true;

  CallOffRate();

  factory CallOffRate.fromJson(dynamic json) {
    return new CallOffRate().fromJson(json);
  }
}
