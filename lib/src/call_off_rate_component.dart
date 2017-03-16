import 'package:angular2/core.dart';

@Component(
  selector: 'call-off-rate',
  templateUrl: 'call_off_rate_component.html')
class CallOffRateComponent {
  @Input()
  /**
   * Уникальный id ставки, берется из базы
   */
  int id = 0;

  @Input()
  /**
   * Является ли ставка вложенной в родительский элемент
   * (влияет на отступ слева)
   */
  dynamic isChild = false;

  @Input()
  /**
   * Является ли элемент ставкой или группой ставок
   * (влияет на отображение контролов ввода суммы и ед. изменрения)
   */
  dynamic isRate = true;

  @Input()
  /**
   * Доступна ли возможность переключения типа элемента:
   * ставка или группа ставок
   */
  dynamic canToggle = true;

  @Input()
  /**
   * Отображать или нет контролы удаления и добавления ставки
   */
  dynamic showPlusMinus = true;

  /**
   * Начальное значение единицы измерения ставки
   */
  String unitName = 'день';

  /**
   * Включена ставка или нет
   * (нужно для удаления ставок)
   */
  bool enabled = true;

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
}