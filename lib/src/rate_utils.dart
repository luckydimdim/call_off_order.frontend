import 'templates/rate_unit.dart';

class RateUtils {
  /**
   * Конвертация ед. изм. ставки из строки
   */
  static RateUnit convertFromInt(int unit) {
    switch (unit) {
      case 1:
        return RateUnit.hour;
      case 2:
        return RateUnit.day;
      case 3:
        return RateUnit.month;
      default:
        return RateUnit.unknown;
    }
  }

  /**
   * Конвертация ед. изм. ставки из строки
   */
  static int convertToInt(RateUnit rateUnit) {
    switch (rateUnit) {
      case RateUnit.hour:
        return 1;
      case RateUnit.day:
        return 2;
      case RateUnit.month:
        return 3;
      default:
        return 0;
    }
  }

  /**
   * Получение наименования ед. измерения
   */
  static String getUnitName(RateUnit rateUnit) {
    switch (rateUnit) {
      case RateUnit.hour:
        return 'Час';
      case RateUnit.day:
        return 'День';
      case RateUnit.month:
        return 'Месяц';
      default:
        return '???';
    }
  }
}
