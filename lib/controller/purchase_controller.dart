import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneakerstore_client/controller/login_controller.dart';

import '../../pages/home_page.dart';
import '../model/orders/order.dart';
import '../model/product/product.dart';
import '../pages/payment_page.dart';
 // Import model Orders

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;
  TextEditingController addressController = TextEditingController();

  // Product details
  Product? selectedProduct;
  String size = '';
  int quantity = 1;
  double totalPrice = 0;
  String image = '';
  // Order information
  String orderAddress = '';

  @override

  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();
  }

  void initProduct(Product product) {
    selectedProduct = product;
    updateTotalPrice();
    update();
  }

  void updateSize(String newSize) {
    size = newSize;
    update();
  }

  void increaseQuantity() {
    quantity++;
    updateTotalPrice();
    update();
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      updateTotalPrice();
    }
    update();
  }

  void updateTotalPrice() {
    totalPrice = (selectedProduct?.price ?? 0) * quantity;
    update();
  }

  void updateAddress(String newAddress) {
    orderAddress = newAddress;
    update();
  }

  void navigateToPayment() {
    if (size.isEmpty) {
      Get.snackbar('Lưu ý', 'Vui lòng chọn size', colorText: Colors.orange);
      return;
    }

    // Sử dụng Get.to thay vì Get.toNamed
    Get.to(
          () => const PaymentPage(),
      arguments: {
        'product': selectedProduct,
        'size': size,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'image': image,
      },
    );
  }

  Future<void> submitOrder() async {
    final loginController = Get.find<LoginController>();

    // Kiểm tra đăng nhập
    if (!loginController.isLoggedIn) {
      Get.snackbar('Lưu ý', 'Vui lòng đăng nhập để đặt hàng', colorText: Colors.orange);
      return;
    }

    if (orderAddress.isEmpty) {
      Get.snackbar('Lưu ý', 'Vui lòng nhập địa chỉ giao hàng', colorText: Colors.orange);
      return;
    }

    try {
      final user = loginController.LoginUser!; // Sử dụng ! vì đã kiểm tra null

      Orders order = Orders(
        customerId: user.id,
        customerName: user.name,
        phoneNumber: user.phonenumber.toString(),
        productId: selectedProduct?.id,
        productName: selectedProduct?.name ?? '',
        image: selectedProduct?.image ?? '',
        size: size,
        quantity: quantity,
        price: selectedProduct?.price ?? 0,
        totalPrice: totalPrice,
        address: orderAddress,
        orderDate: DateTime.now(),
        status: 'Pending', // Có thể đổi thành 'Pending' thay vì 'Successful'
      );

      await orderCollection.add({
        ...order.toJson(),
        'orderDate': Timestamp.fromDate(order.orderDate!),
      });

      Get.snackbar('Thành công', 'Đặt hàng thành công', colorText: Colors.green);
      Get.offAll(() => const HomePage()); // Sử dụng offAll để xóa stack điều hướng

    } catch (e) {
      print(e);
      Get.snackbar('Lỗi', 'Đặt hàng thất bại', colorText: Colors.red);
    }
  }
}
