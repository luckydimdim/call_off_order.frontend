import 'package:converters/json_converter.dart';
import 'package:converters/reflector.dart';
import 'call_off_order_template_model_base.dart';

/**
 * Шаблон верхней части наряд заказа
 */
@reflectable
class CallOffOrderTemplateSouthTambeyModel
    extends CallOffOrderTemplateModelBase {
  @override
  @Json(exclude: true)
  /**
   * Системное имя шаблона
   */
  String sysName = 'SouthTambey';

  /**
   * Табельный номер
   */
  String employeeNumber = '';

  /**
   * Номер позиции
   */
  String positionNumber = '';

  /**
   * Происхождение персонала
   */
  String personnelSource = '';

  /**
   * Номер PAAF
   */
  String paaf = '';

  /**
   * Ссылка плана мобилизации
   */
  String mobPlanReference = '';

  /**
   * Дата мобилизации
   */
  DateTime mobDate;
  String get mobDateStr => mobDate == null ? '' : formatter.format(mobDate);
}
