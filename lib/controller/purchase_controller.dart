import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;
  TextEditingController addressController = TextEditingController();

  double orderPrice = 0; // Giá đơn hàng
  String itemName = ''; // Tên sản phẩm
  String orderAddress = ''; // Địa chỉ giao hàng
  String size = ''; // Kích cỡ giày
  int quantity = 1; // Số lượng sản phẩm
  double totalPrice = 0; // Tổng giá

  void onInit()
  {
    orderCollection = firestore.collection('orders');
    super.I
  }
  // Cập nhật khi chọn kích cỡ
  void updateSize(String newSize) {
    size = newSize;
    updateTotalPrice();
    update();
  }

  // Cập nhật khi tăng số lượng
  void increaseQuantity(double pricePerItem) {
    quantity++;
    updateTotalPrice(pricePerItem);
    update();
  }

  // Cập nhật khi giảm số lượng
  void decreaseQuantity(double pricePerItem) {
    if (quantity > 1) {
      quantity--;
      updateTotalPrice(pricePerItem);
      update();
    }
  }

  // Cập nhật tổng giá
  void updateTotalPrice([double pricePerItem = 0]) {
    if (pricePerItem != 0) {
      totalPrice = pricePerItem * quantity;
    }
    update();
  }

  // Cập nhật địa chỉ khi người dùng nhập
  void updateAddress(String newAddress) {
    orderAddress = newAddress;
    update();
  }

  // Gửi đơn hàng
  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;
  }
}
