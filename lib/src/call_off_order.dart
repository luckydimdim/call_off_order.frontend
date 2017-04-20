import 'call_off_rate.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Наряд-заказ
 */
@reflectable
class CallOffOrder extends Object with JsonConverter, MapConverter {
  String id = '';
  String contractId = '';

  @Json(exclude: true)
  @MapSettings(exclude: true)
  // Шаблон с дополнительными полями ввода
  CallOffOrderTemplateModelBase template;

  @Json(exclude: true)
  @MapSettings(exclude: true)
  // Список ставок наряд-заказа
  List<CallOffRate> rates = new List<CallOffRate>();

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    List<CallOffRate> rateList = new List<CallOffRate>();

    var ratesJson = (json['rates'] as List<dynamic>);

    for (dynamic rateJson in ratesJson) {
      rateList.add(new CallOffRate().fromJson(rateJson));
    }

    // Задание необходимых для правильного отображения свойств ставок:
    // кнопки минуса, переключателя группа/ставка
    List<CallOffRate> parentRates =
      rateList.where((item) => item.parentId == null).toList();

    for (CallOffRate parentRate in parentRates) {
      CallOffRate firstChildRate = rateList.firstWhere(
          (item) => item.parentId == parentRate.id,
          orElse: () => null);

      bool hasChildren = firstChildRate != null;

      parentRate.showPlus  = !hasChildren;
      parentRate.showMinus = !hasChildren;
      parentRate.canToggle = !hasChildren;
    }

    List<CallOffRate> childrenRates =
        rateList.where((item) => item.parentId != null).toList();
    childrenRates.forEach((item) => item.canToggle = false);

    rates = rateList;

    return this;
  }

  @override
  Map toJson() {
    Map result = super.toJson();

    result.addAll(template.toJson());

    var list = new List<Map>();

    for (CallOffRate rate in rates) {
      list.add(rate.toJson());
    }

    result['rates'] = list;

    return result;
  }

  @override
  Map toMap() {
    Map map = super.toMap();

    map.addAll(template.toMap());

    var list = new List<Map>();

    for (CallOffRate rate in rates) {
      list.add(rate.toMap());
    }

    map['rates'] = list;

    return map;
  }
}