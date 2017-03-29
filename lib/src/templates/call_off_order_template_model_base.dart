import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Базовый шаблон наряд-закахов.
 * Нужен для обощения работы с web-сервисом.
 */
@reflectable
abstract class CallOffOrderTemplateModelBase extends Object with JsonConverter, MapConverter {
  /**
   * Системное имя шаблона
   */
  @Json(name: 'templateSysName')
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
}