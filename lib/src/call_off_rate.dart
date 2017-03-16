/**
 * Ставка наряд-заказа
 */
class CallOffRate {
  int id = 0;
  bool isChild = false;
  bool isRate = true;
  bool canToggle = true;
  bool showPlusMinus = true;
  String unitName = 'день';

  CallOffRate(this.id, { this.isChild, this.isRate, this.canToggle, this.showPlusMinus, this.unitName });
}