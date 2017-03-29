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

/**
 * Работа с web-сервисом. Раздел "Наряд-заказы"
 */
@Injectable()
class CallOffService {
  final Client _http;
  final ConfigService _config;
  LoggerService _logger;
  String _backendUrl = null;
  bool _initialized = false;

  CallOffService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  _init() async {
    String backendScheme = await _config.Get<String>('backend_scheme');
    String backendBaseUrl = await _config.Get<String>('backend_base_url');
    String backendPort = await _config.Get<String>('backend_port');
    String backendCallOffOrders =
    await _config.Get<String>('backend_call_off_orders');

    _backendUrl =
    '$backendScheme://$backendBaseUrl:$backendPort/$backendCallOffOrders';

    _initialized = true;
  }

  /**
   * Получение списка наряд-заказов
   */
  Future<List<CallOffOrder>> getCallOffOrders(
      [String contractId = null]) async {
    if (!_initialized) await _init();

    _logger.trace('Requesting call off orders. Url: ${_backendUrl}');

    Response response = null;

    var backendUrl = _backendUrl;
    if (contractId != null) {
      backendUrl += "?contractId=$contractId";
    }

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
      CallOffOrderTemplateModelBase template = instantiateModel(
          json['templateSysName']);

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
    if (!_initialized) await _init();

    Response response = null;

    _logger.trace('Requesting call off order. Url: $_backendUrl/$id');

    try {
      response = await _http.get('$_backendUrl/$id',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order: $e');

      throw new Exception('Failed to get contract general. Cause: $e');
    }

    _logger.trace('Call off order requested: $response.');

    dynamic json = JSON.decode(response.body);

    CallOffOrderTemplateModelBase template = instantiateModel(
        json['templateSysName']);

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
  Future<String> createCallOffOrder(String contractId, String templateSysName) async {
    if (!_initialized) await _init();

    CallOffOrderTemplateModelBase template = instantiateModel(templateSysName);
    var model = new CallOffOrder()
      ..contractId = contractId
      ..template = template;

    Response response = null;

    String jsonString = JSON.encode(model.toJson());

    _logger.trace('Creating call off order');

    try {
      response = await _http
          .post(_backendUrl, headers: {'Content-Type': 'application/json'},
          body: jsonString);

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
    if (!_initialized) await _init();

    String jsonString = JSON.encode(model.toJson());

    _logger.trace('Updating call off order $jsonString');

    try {
      await _http.put(_backendUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonString);
      _logger.trace('Call off successfuly updated');
    } catch (e) {
      _logger.error('Failed to update call off order: $e');

      throw new Exception('Failed to update call off order. Cause: $e');
    }
  }

  /**
   * Удаление наряд-заказа
   */
  deleteCallOfOrder(String id) async {
    if (!_initialized) await _init();

    _logger.trace('Removing call off order. Url: $_backendUrl/$id');

    try {
      await _http.delete('$_backendUrl/$id',
          headers: {'Content-Type': 'application/json'});
      _logger.trace('Call off order $id removed');
    } catch (e) {
      _logger.error('Failed to remove call off order: $e');

      throw new Exception('Failed to remove call off order. Cause: $e');
    }
  }
}