import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneakerstore_client/controller/login_controller.dart';
import '../model/product/product.dart';
import '../model/user/user.dart';
import '../pages/home_page.dart';
import '../pages/payment_page.dart';

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
    User? loginUser = Get.find<LoginController>().LoginUser;

    if (orderAddress.isEmpty) {
      Get.snackbar('Lưu ý', 'Vui lòng nhập địa chỉ giao hàng', colorText: Colors.orange);
      return;
    }

    try {
      await orderCollection.add({

        'customerId': loginUser?.id,
        'customerName': loginUser?.name ?? '',
        'phoneNumber': loginUser?.phonenumber ?? '',
        'productId': selectedProduct?.id,
        'productName': selectedProduct?.name ?? '',
        'image': selectedProduct?.image ?? '',
        'size': size,
        'quantity': quantity,
        'price': selectedProduct?.price ?? 0,
        'totalPrice': totalPrice,
        'address': orderAddress,
        'orderDate': DateTime.now(),
        'status': 'Sucessful'
      });

      Get.snackbar('Thành công', 'Đặt hàng thành công', colorText: Colors.green);
      Get.to(HomePage()); // Về trang chủ sau khi đặt hàng

    } catch (e) {
      print(e);
      Get.snackbar('Lỗi', 'Đặt hàng thất bại', colorText: Colors.red);
    }
  }
}