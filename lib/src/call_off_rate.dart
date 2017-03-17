/**
 * Ставка наряд-заказа
 */
class CallOffRate {
  /**
   * Уникальный id ставки, берется из базы
   */
  int id = 0;

  /**
   * Название ставки
   */
  String name = '';

  /**
   * Является ли элемент ставкой или группой ставок
   * (влияет на отображение контролов ввода суммы и ед. изменрения)
   */
  bool isRate = true;

  /**
   * Величина ставки
   */
  double amount = 0.0;

  /**
   * Валюта ставки
   */
  String currency = 'USD';

  /**
   * Начальное значение единицы измерения ставки
   */
  String unitName = 'день';

  /**
   * Является ли ставка вложенной в родительский элемент
   * (влияет на отступ слева)
   */
  bool isChild = false;

  /**
   * Доступна ли возможность переключения типа элемента:
   * ставка или группа ставок
   */
  bool canToggle = true;

  /**
   * Отображать или нет контролы удаления и добавления ставки
   */
  bool showPlusMinus = true;

  CallOffRate({ this.id, this.isChild, this.isRate, this.canToggle, this.showPlusMinus, this.unitName });

  factory CallOffRate.fromJson(dynamic json) {
    return new CallOffRate(
      id: json['id'],
      isChild: json['name'],
      isRate: json['isRate'],
      canToggle: json['amount'],
      showPlusMinus: json['currency'],
      unitName: json['unitName']);
  }

  String toJsonString() {
    var map = new Map();

    map['id'] = id;
    map['name'] = name;
    map['isRate'] = isRate;
    map['amount'] = amount;
    map['currency'] = currency;
    map['unitName'] = unitName;

    return map;
  }
}