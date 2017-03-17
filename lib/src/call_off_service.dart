import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';
import 'package:json_object/json_object.dart';

import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import 'package:call_off_order/src/call_off_order.dart';

/**
 * Работа с БД для раздела "Наряд-заказы"
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
    String backendCallOffOrders = await _config.Get<String>('backend_call_off_orders');

    _backendUrl = '$backendScheme://$backendBaseUrl:$backendPort/$backendCallOffOrders';

    _initialized = true;
  }

  /**
   * Получение списка наряд-заказов
   */
  Future<List<CallOffOrder>> getCallOfOrders() async {
    if (!_initialized)
      await _init();

    _logger.trace('Requesting call off orders. Url: ${_backendUrl}');

    Response response = null;

    try {
      response = await _http.get(
        /*'http://localhost:5000/contracts',*/
        _backendUrl,
        /*_config.helper.contractsUrl,*/
        headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order list: $e');

      throw new Exception('Failed to get call off order list. Cause: $e');
    }

    _logger.trace('Call off orders requested: $response.');

    var result = new List<CallOffOrder>();
    var json = (JSON.decode(response.body) as List<dynamic>);

    json.forEach((callOffOrder) =>
      result.add(new CallOffOrder.fromJson(callOffOrder)));

    return result;
  }

  /**
   * Получение наряд-заказа по его id
   */
  Future<CallOffOrder> getCallOffOrder(String orderId) async {
    if (!_initialized)
      await _init();

    Response response = null;

    _logger.trace('Requesting call off order. Url: $_backendUrl/$orderId');

    try {
      response = await _http.get(
        '$_backendUrl/$orderId',
        headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get call off order: $e');

      throw new Exception('Failed to get contract general. Cause: $e');
    }

    _logger.trace('Call off order requested: $response.');

    dynamic json = JSON.decode(response.body);

    return new CallOffOrder.fromJson(json);
  }

  /**
   * Создание нового наряд-заказа
   */
  Future<String> createCallOffOrder() async {
    if (!_initialized)
      await _init();

    Response response = null;

    _logger.trace('Creating call off order');

    try {
      response = await _http.post(
        _backendUrl,
        headers: {'Content-Type': 'application/json'});

      _logger.trace('Call off order created');

    } catch (e) {
      print('Failed to create call off order: $e');

      throw new Exception('Failed to create call off order. Cause: $e');
    }

    return response.body;
  }

  /**
   * Изменение данных наряд-заказа
   */
  updateCallOffOrder(CallOffOrder model) async {
    if (!_initialized)
      await _init();

    _logger.trace('Editing call off order ${model.toJsonString()}');

    try {
      await _http.put(
        _backendUrl,
        headers: {'Content-Type': 'application/json'},
        body: model.toJsonString());
      _logger.trace('Contract ${model.name} edited');
    } catch (e) {
      _logger.error('Failed to edit contract: $e');

      throw new Exception('Failed to edit contract. Cause: $e');
    }
  }

  /**
   * Удаление договора
   */
  deleteContract(String contractId) async {
    if (!_initialized)
      await _init();

    _logger.trace('Removing contract. Url: $_backendUrl/$contractId');

    try {
      await _http.delete(
        '$_backendUrl/$contractId',
        headers: {'Content-Type': 'application/json'});
      _logger.trace('Contract $contractId removed');
    } catch (e) {
      _logger.error('Failed to remove contract: $e');

      throw new Exception('Failed to remove contract. Cause: $e');
    }
  }
}