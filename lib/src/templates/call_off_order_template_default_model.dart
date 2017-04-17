import 'package:converters/json_converter.dart';
import 'package:converters/reflector.dart';
import 'call_off_order_template_model_base.dart';

/**
 * Шаблон верхней части наряд заказа
 */
@reflectable
class CallOffOrderTemplateDefaultModel extends CallOffOrderTemplateModelBase {
  @override
  @Json(exclude: true)
  /**
   * Системное имя шаблона
   */
  String sysName = 'default';
}