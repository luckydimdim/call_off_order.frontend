import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';

import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import 'call_off_order.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_default_model.dart';
import 'templates/call_off_order_template_south_tambey_model.dart';

@Injectable()
/**
 * Работа с web-сервисом. Раздел "Наряд-заказы"
 */
class CallOffService {
  final Client _http;
  final ConfigService _config;
  LoggerService _logger;

  CallOffService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  /**
   * Получение списка наряд-заказов
   */
  Future<List<CallOffOrder>> getCallOffOrders(
      [String contractId = null]) async {
    String backendUrl = _config.helper.callOffOrdersUrl;
    if (contractId != null) {
      backendUrl += "?contractId=$contractId";
    }

    _logger.trace('Requesting call off orders. Url: $backendUrl');

    Response response = null;

    try {
      response = await _http
          .get(backendUrl, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order list: $e');

      throw new Exception('Failed to get call off order list. Cause: $e');
    }

    _logger.trace('Call off orders requested: $response.');

    var result = new List<CallOffOrder>();
    var jsonList = (JSON.decode(response.body) as List<dynamic>);

    for (var json in jsonList) {
      CallOffOrderTemplateModelBase template =
          instantiateModel(json['templateSysName']);

      var callOffOrder = new CallOffOrder.fromJson(json);
      callOffOrder.template = template.fromJson(json);

      result.add(callOffOrder);
    }

    return result;
  }

  /**
   * Получение одного наряд-заказа по его id
   */
  Future<CallOffOrder> getCallOffOrder(String id) async {
    Response response = null;

    _logger.trace(
        'Requesting call off order. Url: ${ _config.helper.callOffOrdersUrl }/$id');

    try {
      response = await _http.get('${_config.helper.callOffOrdersUrl}/$id',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order: $e');

      throw new Exception('Failed to get contract general. Cause: $e');
    }

    _logger.trace('Call off order requested: $response.');

    dynamic json = JSON.decode(response.body);

    CallOffOrderTemplateModelBase template =
        instantiateModel(json['templateSysName']);

    var model = new CallOffOrder.fromJson(json);
    model.template = template.fromJson(json);

    return model;
  }

  /**
   * Фабричный метод
   */
  CallOffOrderTemplateModelBase instantiateModel(String templateSysName) {
    CallOffOrderTemplateModelBase result;

    switch (templateSysName) {
      case 'SouthTambey':
        result = new CallOffOrderTemplateSouthTambeyModel();
        break;

      default:
        result = new CallOffOrderTemplateDefaultModel();
        break;
    }

    return result;
  }

  /**
   * Создание нового наряд-заказа
   */
  Future<String> createCallOffOrder(
      String contractId, String templateSysName) async {
    CallOffOrderTemplateModelBase template = instantiateModel(templateSysName);
    var model = new CallOffOrder()
      ..contractId = contractId
      ..template = template;

    Response response = null;

    String jsonString = JSON.encode(model.toJson());

    _logger.trace('Creating call off order');

    try {
      response = await _http.post(_config.helper.callOffOrdersUrl,
          headers: {'Content-Type': 'application/json'}, body: jsonString);

      _logger.trace('Call off order created');
    } catch (e) {
      throw new Exception('Failed to create call off order. Cause: $e');
    }

    return response.body;
  }

  /**
   * Изменение данных наряд-заказа
   */
  updateCallOffOrder(CallOffOrder model) async {
    String jsonString = JSON.encode(model.toJson());

    _logger.trace('Updating call off order $jsonString');

    Response response = null;

    try {
      response = await _http.put(_config.helper.callOffOrdersUrl,
          headers: {'Content-Type': 'application/json'}, body: jsonString);
      _logger.trace('Call off successfuly updated');
    } catch (e) {
      _logger.error('Failed to update call off order: $e');

      throw new Exception('Failed to update call off order. Cause: $e');
    }

    dynamic json = JSON.decode(response.body);

    CallOffOrderTemplateModelBase template =
      instantiateModel(json['templateSysName']);

    model = new CallOffOrder.fromJson(json);
    model.template = template.fromJson(json);

    return model;
  }

  /**
   * Удаление наряд-заказа
   */
  deleteCallOfOrder(String id) async {
    _logger.trace(
        'Removing call off order. Url: ${_config.helper.callOffOrdersUrl}/$id');

    try {
      await _http.delete('${_config.helper.callOffOrdersUrl}/$id',
          headers: {'Content-Type': 'application/json'});
      _logger.trace('Call off order $id removed');
    } catch (e) {
      _logger.error('Failed to remove call off order: $e');

      throw new Exception('Failed to remove call off order. Cause: $e');
    }
  }
}
