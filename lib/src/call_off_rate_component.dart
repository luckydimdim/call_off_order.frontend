import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:call_off_order/src/call_off_rate.dart';

@Component(
    selector: 'call-off-rate', templateUrl: 'call_off_rate_component.html')
class CallOffRateComponent {
  @Input()
  CallOffRate model = new CallOffRate();

  @Output()
  /**
   * Событие добавления ставки во внешний компонент
   */
  dynamic addRate = new EventEmitter<CallOffRateComponent>();

  @Output()
  /**
   * Событие удаления ставки во внешний компонент
   */
  dynamic removeRate = new EventEmitter<CallOffRateComponent>();

  /**
   * Публикует событие добавления ставки во внешний компонент
   */
  void emitAddRate() {
    addRate.emit(this);
  }

  /**
   * Публикует событие удаления ставки во внешний компонент
   */
  void emitRemoveRate() {
    removeRate.emit(this);
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
    'ng-dirty': control.dirty ?? false,
    'ng-pristine': control.pristine ?? false,
    'ng-touched': control.touched ?? false,
    'ng-untouched': control.untouched ?? false,
    'ng-valid': control.valid ?? false,
    'ng-invalid': control.valid == false
  };
}
