import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';

import 'package:config/config_service.dart';
import 'package:http_wrapper/http_wrapper.dart';
import 'package:logger/logger_service.dart';

import 'call_off_order.dart';
import 'call_off_rate.dart';
import 'call_off_order_to_create.dart';

import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_default_model.dart';
import 'templates/call_off_order_template_south_tambey_model.dart';

@Injectable()
/**
 * Работа с web-сервисом. Раздел "Наряд-заказы"
 */
class CallOffService {
  final HttpWrapper _http;
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

      rethrow;
    }

    _logger.trace('Call off orders requested: $response.');

    var result = new List<CallOffOrder>();
    var jsonList = (JSON.decode(response.body) as List<dynamic>);

    for (var json in jsonList) {
      CallOffOrder callOffOrder =
          new CallOffOrder.initTemplate(json['templateSysName']).fromJson(json);
      callOffOrder.template = callOffOrder.template.fromJson(json);

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

      rethrow;
    }

    _logger.trace('Call off order requested: $response.');

    dynamic json = JSON.decode(response.body);
    CallOffOrder model =
        new CallOffOrder.initTemplate(json['templateSysName']).fromJson(json);
    model.template = model.template.fromJson(json);

    return model;
  }

  /**
   * Создание нового наряд-заказа
   */
  Future<String> createCallOffOrder(CallOffOrder model) async {
    String jsonString = model.toJsonString();

    Response response = null;

    _logger.trace('Creating call off order $jsonString');

    try {
      response = await _http.post(_config.helper.callOffOrdersUrl,
          headers: {'Content-Type': 'application/json'}, body: jsonString);

      _logger.trace('Call off order created');
    } catch (e) {
      rethrow;
    }

    return response.body;
  }

  /**
   * Получение данных для создания наряд заказа
   */
  Future<CallOffOrderToCreate> callOffOrderToCreate(String contractId) async {
    Response response = null;

    _logger.trace(
        'Requesting call off order to create. Url: ${ _config.helper.callOffOrdersUrl }/to-create/$contractId');

    try {
      response = await _http.get(
          '${_config.helper.callOffOrdersUrl}/to-create/$contractId',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order to create: $e');

      rethrow;
    }

    _logger.trace('Call off order  to create requested: $response.');

    dynamic json = JSON.decode(response.body);

    CallOffOrderToCreate model = new CallOffOrderToCreate().fromJson(json);

    return model;
  }

  /**
   * Изменение данных наряд-заказа
   */
  Future updateCallOffOrder(CallOffOrder model) async {
    String jsonString = model.toJsonString();

    _logger.trace('Updating call off order $jsonString');

    try {
      await _http.put('${_config.helper.callOffOrdersUrl}/${model.id}',
          headers: {'Content-Type': 'application/json'}, body: jsonString);
      _logger.trace('Call off successfuly updated');
    } catch (e) {
      _logger.error('Failed to update call off order: $e');

      rethrow;
    }
  }

  /**
   * Удаление наряд-заказа
   */
  Future deleteCallOfOrder(String id) async {
    _logger.trace(
        'Removing call off order. Url: ${_config.helper.callOffOrdersUrl}/$id');

    try {
      await _http.delete('${_config.helper.callOffOrdersUrl}/$id',
          headers: {'Content-Type': 'application/json'});
      _logger.trace('Call off order $id removed');
    } catch (e) {
      _logger.error('Failed to remove call off order: $e');

      rethrow;
    }
  }
}
