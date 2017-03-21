/**
 * Базовый шаблон наряд-закахов.
 * Нужен для обощения работы с web-сервисом.
 */
abstract class CallOffOrderTemplateModelBase {
  String SysName = '';

  String toJsonString();

  dynamic fromJsonString(dynamic json);

  Map toMap();
}