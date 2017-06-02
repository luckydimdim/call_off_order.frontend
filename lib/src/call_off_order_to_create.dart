import 'call_off_rate.dart';
import 'templates/call_off_order_template_model_base.dart';
import 'templates/call_off_order_template_south_tambey_model.dart';
import 'templates/call_off_order_template_default_model.dart';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Данные по наряд заказу при создании
 */
@reflectable
class CallOffOrderToCreate extends Object with JsonConverter, MapConverter {

  String contractId = '';

  String currencySysName = '';

  DateTime minDate;

  DateTime maxDate;

  List<String> currencies;
}
