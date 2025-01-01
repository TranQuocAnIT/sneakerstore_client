import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class HomeController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  List<Product> products = [];
  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    await fetchProducts();
    super.onInit();
  }
  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrivedProducts = productSnapshot.docs.map((doc) => Product.fromJson(doc.data() as Map<String,dynamic>)).toList();
      products.clear();
      products.assignAll(retrivedProducts);
      Get.snackbar('Thành công', 'Đổ sản phẩm thành công' , colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Lổi', e.toString(),colorText: Colors.red);
      print(e);
    }finally{
      update();
    }
  }
}