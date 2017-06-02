import 'call_off_rate.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_south_tambey_model.dart';
import 'templates/call_off_order_template_default_model.dart';
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

  // есть табели
  bool hasTimeSheets = false;

  CallOffOrder(){

  }

  CallOffOrder.initTemplate(String templateSysName){
    switch (templateSysName) {
      case 'SouthTambey':
        template = new CallOffOrderTemplateSouthTambeyModel();
        break;

      default:
        template = new CallOffOrderTemplateDefaultModel();
        break;
    }
  }

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    List<CallOffRate> rateList = new List<CallOffRate>();

    var ratesJson = (json['rates'] as List<dynamic>);

    if (ratesJson != null) {
      for (dynamic rateJson in ratesJson) {
        rateList.add(new CallOffRate().fromJson(rateJson));
      }
    }

    // Задание необходимых для правильного отображения свойств ставок:
    // кнопки минуса, переключателя группа/ставка, кнопка плюса
    List<CallOffRate> parentRates = rateList
        .where((item) => item.parentId == null && !item.isRate)
        .toList();

    for (CallOffRate parentRate in parentRates) {
      CallOffRate firstChildRate = rateList.firstWhere(
          (item) => item.parentId == parentRate.id,
          orElse: () => null);

      bool hasChildren = firstChildRate != null;

      parentRate.showPlus = !hasChildren;
      parentRate.showMinus = !hasChildren;
      parentRate.canToggle = !hasChildren;

      List<CallOffRate> childrenRates =
          rateList.where((item) => item.parentId == parentRate.id).toList();

      // Убирание плюса и переключателя ставка/группа
      for (int i = 0; i < childrenRates.length; ++i) {
        childrenRates[i].canToggle = false;
        childrenRates[i].showPlus = false;
      }

      if (childrenRates.length > 0) childrenRates.last.showPlus = true;
    }

    // Убирание плюса у верхнеуровневых ставок
    List<CallOffRate> topLevelRates =
        rateList.where((item) => item.parentId == null && item.isRate).toList();
    topLevelRates.forEach((item) => item.showPlus = false);

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
