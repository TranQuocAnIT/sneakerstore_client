import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/cart/cart.dart';
import '../model/cart/cartitem.dart';
import '../model/product/product.dart';
import 'login_controller.dart';

class CartController extends GetxController {
  final loginController = Get.find<LoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    if (loginController.LoginUser == null) return;

    try {
      isLoading.value = true;

      // Get user's cart
      final cartQuery = await _firestore.collection('carts')
          .where('userId', isEqualTo: loginController.LoginUser!.id)
          .limit(1)
          .get();

      if (cartQuery.docs.isEmpty) {
        isLoading.value = false;
        return;
      }

      final cartId = cartQuery.docs.first.id;

      // Get cart items
      final itemsQuery = await _firestore.collection('cartItems')
          .where('cartId', isEqualTo: cartId)
          .get();

      List<CartItem> items = [];
      double total = 0;

      for (var doc in itemsQuery.docs) {
        final itemData = doc.data();
        final productDoc = await _firestore.collection('products')
            .doc(itemData['productId'])
            .get();

        if (productDoc.exists) {
          final product = Product.fromJson(productDoc.data() as Map<String, dynamic>);
          final cartItem = CartItem(
            productId: itemData['productId'],
            cartId: cartId,
            quantity: itemData['quantity'],
            size: itemData['size'],
            totalPrice: itemData['totalPrice'],
          );

          items.add(cartItem);
          total += (cartItem.totalPrice ?? 0);
        }
      }

      cartItems.value = items;
      totalCartPrice.value = total;

    } catch (e) {
      print('Error fetching cart items: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải giỏ hàng',
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItemQuantity(CartItem item, int newQuantity) async {
    try {
      if (newQuantity < 1) return;

      final productDoc = await _firestore.collection('products')
          .doc(item.productId)
          .get();

      if (!productDoc.exists) return;

      final product = Product.fromJson(productDoc.data() as Map<String, dynamic>);

      final itemQuery = await _firestore.collection('cartItems')
          .where('cartId', isEqualTo: item.cartId)
          .where('productId', isEqualTo: item.productId)
          .where('size', isEqualTo: item.size)
          .get();

      if (itemQuery.docs.isNotEmpty) {
        await itemQuery.docs.first.reference.update({
          'quantity': newQuantity,
          'totalPrice': (product.price ?? 0) * newQuantity,
        });

        await updateCartTotal(item.cartId!);
        await fetchCartItems();
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> removeItem(CartItem item) async {
    try {
      final itemQuery = await _firestore.collection('cartItems')
          .where('cartId', isEqualTo: item.cartId)
          .where('productId', isEqualTo: item.productId)
          .where('size', isEqualTo: item.size)
          .get();

      if (itemQuery.docs.isNotEmpty) {
        await itemQuery.docs.first.reference.delete();
        await updateCartTotal(item.cartId!);
        await fetchCartItems();
      }
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  Future<void> updateCartTotal(String cartId) async {
    try {
      final items = await _firestore.collection('cartItems')
          .where('cartId', isEqualTo: cartId)
          .get();

      double total = 0;
      for (var doc in items.docs) {
        final data = doc.data();
        total += (data['totalPrice'] as num?)?.toDouble() ?? 0;
      }

      await _firestore.collection('carts')
          .doc(cartId)
          .update({
        'totalPrice': total,
        'updated_at': DateTime.now(),
      });
    } catch (e) {
      print('Error updating cart total: $e');
    }
  }
}