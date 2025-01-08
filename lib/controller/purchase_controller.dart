import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneakerstore_client/controller/login_controller.dart';

import '../../pages/home_page.dart';
import '../model/comment/comment.dart';
import '../model/orders/order.dart';
import '../model/product/product.dart';
import '../pages/payment_page.dart';
 // Import model Orders

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;
  TextEditingController addressController = TextEditingController();
  late CollectionReference commentCollection;
  var comments = <Comment>[].obs; // List comments
  String? productId;
  // Product details
  Product? selectedProduct;
  String size = '';
  int quantity = 1;
  double totalPrice = 0;
  String image = '';
  // Order information
  String orderAddress = '';

  @override
  String? selectedproductid;
  Future<void> onInit() async {
    orderCollection = firestore.collection('orders');
    commentCollection = firestore.collection('comments');
    super.onInit();

  }

  void initProduct(Product product) {
    selectedProduct = product;
    productId = product.id;
    fetchComments();
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
        status: 'Đã đặt hàng', // Có thể đổi thành 'Pending' thay vì 'Successful'
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
  Future<void> cancelOrder(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': 'Đã hủy'
      });
      Get.snackbar(
        'Thành công',
        'Đã hủy đơn hàng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể hủy đơn hàng: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
  Future<void> confirmOrderReceived(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': 'Đã nhận hàng'
      });
      Get.snackbar(
        'Thành công',
        'Đã xác nhận nhận được hàng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xác nhận đơn hàng: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
  Future<void> submitComment(String orderId, String message, Map<String, dynamic> orderData) async {
    try {
      Comment comment = Comment(
        customerId: orderData['customerId'],
        customerName: orderData['customerName'],
        productId: orderData['productId'],
        productName: orderData['productName'],
        orderId: orderId,
        totalPrice: orderData['totalPrice'],
        message: message,
        createdAt: DateTime.now(),
      );

      await firestore.collection('comments').add(comment.toJson());

      // Cập nhật trạng thái đã comment của order
      await firestore.collection('orders').doc(orderId).update({
        'hasComment': true
      });

      Get.back(); // Đóng dialog
      Get.snackbar(
        'Thành công',
        'Đã gửi đánh giá sản phẩm',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể gửi đánh giá: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
  void fetchComments() async {
    if (productId == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('productId', isEqualTo: productId)
          .orderBy('createdAt', descending: true)
          .get();

      comments.value = querySnapshot.docs
          .map((doc) => Comment.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }
}
