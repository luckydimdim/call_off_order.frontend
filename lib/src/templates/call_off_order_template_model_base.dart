import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Базовый шаблон наряд-заказов.
 * Нужен для обобщения работы с web-сервисом.
 */
@reflectable
abstract class CallOffOrderTemplateModelBase extends Object with JsonConverter, MapConverter {
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