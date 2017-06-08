import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:uuid/uuid.dart';
import 'templates/rate_unit.dart';
import 'rate_utils.dart';

/**
 * Ставка наряд-заказа
 */
@reflectable
class CallOffRate extends Object with JsonConverter, MapConverter {
  // Уникальный id ставки, берется из базы
  String id = null;

  
  @Json(exclude: true)
  // GUID generator
  Uuid guid = new Uuid();

  // Название ставки
  String name = '';

  // Является ли элемент ставкой или группой ставок
  // (влияет на отображение контролов ввода суммы и ед. изменрения)
  bool isRate = true;

  // Величина ставки
  double amount = 0.0;

  // Начальное значение единицы измерения ставки
  @Json(exclude: true)
  RateUnit unit = RateUnit.day;

  // Id группы
  String parentId = null;

  // Доступна ли возможность переключения типа элемента:
  // ставка или группа ставок
  @Json(exclude: true)
  bool canToggle = true;

  @Json(exclude: true)
  // Отображать или нет контрол удаления
  bool showMinus = true;

  @Json(exclude: true)
  // Отображать или нет контрол добавления ставки
  bool showPlus = true;

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    unit = RateUtils.convertFromInt(json['unit']);

    return this;
  }

  @override
  Map toJson() {
    var map = super.toJson();

    map['unit'] = RateUtils.convertToInt(unit);

    return map;
  }
}
