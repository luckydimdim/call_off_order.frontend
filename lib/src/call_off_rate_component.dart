import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular_utils/cm_positive_number.dart';

import 'package:call_off_order/src/call_off_rate.dart';
import 'templates/rate_unit.dart';
import 'rate_utils.dart';

@Component(
    selector: 'call-off-rate',
    templateUrl: 'call_off_rate_component.html',
    directives: const [CmPositiveNumberDirective])
class CallOffRateComponent {
  @Input()
  bool readOnly = true;

  @Input()
  CallOffRate model = null;

  @Output()
  // Событие добавления ставки во внешний компонент
  dynamic addRate = new EventEmitter<CallOffRate>();

  @Output()
  // Событие удаления ставки во внешний компонент
  dynamic removeRate = new EventEmitter<CallOffRate>();

  @Output()
  // Событие обновления ставки во внешний компонент
  dynamic updateRate = new EventEmitter<CallOffRate>();

  // Публикует событие добавления ставки во внешний компонент
  void emitAddRate() {
    addRate.emit(model);
  }

  // Публикует событие удаления ставки во внешний компонент
  void emitRemoveRate() {
    removeRate.emit(model);
  }

  // Публикует событие изменения ставки во внешний компонент
  void emitUpdateRate() {
    updateRate.emit(model);
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };

  String getUnitName(RateUnit rateUnit) {
    return RateUtils.getUnitName(rateUnit).toLowerCase();
  }

  /**
   * Кликнули по ед. измерения
   */
  void onRateUnitClicked() {
    switch (model.unit) {
      case RateUnit.hour:
        model.unit = RateUnit.day;
        break;
      case RateUnit.day:
        model.unit = RateUnit.month;
        break;
      case RateUnit.month:
        model.unit = RateUnit.hour;
        break;
      default:
        model.unit = RateUnit.day;
    }

    emitUpdateRate();
  }
}
