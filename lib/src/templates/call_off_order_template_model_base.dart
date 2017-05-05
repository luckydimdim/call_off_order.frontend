import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:intl/intl.dart';

/**
 * Базовый шаблон наряд-заказов.
 * Нужен для обобщения работы с web-сервисом.
 */
@reflectable
abstract class CallOffOrderTemplateModelBase extends Object
    with JsonConverter, MapConverter {
  @Json(name: 'templateSysName')
  @Json(exclude: true)
  /**
   * Системное имя шаблона
   */
  String sysName = '';

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
  DateTime startDate;
  String get startDateStr =>
      startDate == null ? '' : formatter.format(startDate);

  /**
   * Дата окончания действия наряд-заказа
   */
  DateTime finishDate;
  String get finishDateStr =>
      finishDate == null ? '' : formatter.format(finishDate);

  /**
   * Должность
   */
  String position = '';

  /**
   * Место работы
   */
  String location = '';

  @Json(exclude: true)
  DateFormat formatter = new DateFormat('dd.MM.yyyy');
}
