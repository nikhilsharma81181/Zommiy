import 'dart:async';
import 'package:flutter/material.dart';

class RestaurantModel extends ChangeNotifier {
  String? restaurantId = 'XXsmycKIWWz0vdIacutO';
  String? tableNo;
  bool showMenu = false;
  int menuIndex = 0;
  int selectedPrice = 0;
  int selectedQuantityUnit = 0;
  int selectedType = 0;
  int selectedSpicy = 0;
  int quantity = 1;
  String? name;
  String? dishType;
  String? location;
  bool takeAway = false;
  String? timeSlot;
  String searchCtrl = '';

  getSearchData(data) {
    searchCtrl = data;
    notifyListeners();
  }

  getTimeSlot(String time) {
    timeSlot = time;
    notifyListeners();
  }

  dineInTakeAway(BuildContext context, bool value) {
    takeAway = value;
    Navigator.pop(context);
    notifyListeners();
  }

  resetSelectedData() {
    selectedPrice = 0;
    selectedQuantityUnit = 0;
    selectedType = 0;
    selectedSpicy = 0;
    quantity = 1;
    notifyListeners();
  }

  updatePrice(int index) {
    selectedQuantityUnit = index;
    selectedPrice = index;
    notifyListeners();
  }

  updateType(int index) {
    selectedType = index;
    notifyListeners();
  }

  updateSpicy(int index) {
    selectedSpicy = index;
    notifyListeners();
  }

  removeQuantity() {
    if (quantity > 1) {
      quantity = quantity - 1;
    }
    notifyListeners();
  }

  addQuantity() {
    quantity = quantity + 1;
    notifyListeners();
  }

  getRestaurantId(String id, table) {
    restaurantId = id;
    tableNo = table;
    notifyListeners();
  }

  getRestaurantDetails(restName, dishtype, restLocation) {
    name = restName;
    dishType = dishtype;
    location = restLocation;
  }

  getMenuState(bool show) {
    showMenu = show;
    notifyListeners();
  }

  getIndex(int index) {
    menuIndex = index;
    notifyListeners();
  }

  final itemKey = GlobalKey();

  scrollToItem() {
    final context = itemKey.currentContext;
    Scrollable.ensureVisible(
      context!,
      alignment: 0,
      duration: const Duration(milliseconds: 400),
    );
  }
}

class CartItems extends ChangeNotifier {
  Map items = {};
  List itemList = [];
  int quantity = 0;
  int totalPrice = 0;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  String? orderId;

  perItemTotal(String name) {
    items[name]['totalPrice'] = items[name]['quantity'] * items[name]['price'];
    notifyListeners();
  }

  getExtra() {
    int num = 0;
    int price = 0;
    for (var item in itemList) {
      num = items[item]['quantity'] + num;
      price = items[item]['price'] * items[item]['quantity'] + price;
    }
    totalPrice = price;
    quantity = num;
    notifyListeners();
  }

  addItem(String name, int price, int quantity, bool veg, String unit,
      String unitquantity, String type, String spicy) {
    if (!itemList.contains(name)) {
      itemList.add(name);
    }
    if (!items.containsValue(name)) {
      items.update(
        name,
        (value) => {},
        ifAbsent: () => {},
      );
    }

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      items.update(
        name,
        (value) => {
          'name': name,
          'price': price,
          'quantity': quantity,
          'veg': veg,
          'totalPrice': price,
          'unit': unit,
          'unitQuantity': unitquantity,
          'type': type,
          'spicy': spicy,
        },
        ifAbsent: () => {},
      );
      getExtra();
      timer.cancel();
    });
    notifyListeners();
  }

  removeItem(String name) {
    if (itemList.contains(name)) {
      itemList.remove(name);
    }
    items.remove(name);
    getExtra();
    notifyListeners();
  }

  increaseQuantity(String name) {
    int num = items[name]['quantity'] ?? 0;
    items[name]['quantity'] = num + 1;
    perItemTotal(name);
    getExtra();
    notifyListeners();
  }

  decreaseQuantity(String name) {
    int num = items[name]['quantity'] ?? 0;
    items[name]['quantity'] = num - 1;
    perItemTotal(name);
    getExtra();
    notifyListeners();
  }

  getOrderId(String id) {
    orderId = id;
    notifyListeners();
  }
}
