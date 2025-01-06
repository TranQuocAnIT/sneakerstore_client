  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';
import '../model/product_category/product_category.dart';
import 'login_controller.dart';

  class HomeController extends GetxController {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    late CollectionReference productCollection;
    late CollectionReference categoryCollection;


    String searchQuery = '';

    List<Product> products = [];
    List<Product> productShowinUI = [];
    List<ProductCategory> productcategories = [];


    @override
    Future<void> onInit() async {
      productCollection = firestore.collection('products');
      categoryCollection = firestore.collection('category');

      await fetchCategory();
      await fetchProducts();

      super.onInit();
    }


    fetchProducts() async {
      try {
        QuerySnapshot productSnapshot = await productCollection.get();
        final List<Product> retrivedProducts = productSnapshot.docs.map((doc) =>
            Product.fromJson(doc.data() as Map<String, dynamic>)).toList();
        products.clear();
        products.assignAll(retrivedProducts);
        productShowinUI.assignAll(products);
        String? currentUserId = LoginController().LoginUser?.id;

        // Thêm debug
        print("LoginUser: ${LoginController().LoginUser}");
        print("currentUserId: $currentUserId");

      } catch (e) {
        Get.snackbar('Lổi', e.toString(), colorText: Colors.red);
        print(e);
      } finally {
        update();
      }
    }

    fetchCategory() async {
      try {
        QuerySnapshot categorySnapshot = await categoryCollection.get();
        final List<ProductCategory> retrivedCategories = categorySnapshot.docs
            .map((doc) =>
            ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        productcategories.clear();
        productcategories.assignAll(retrivedCategories);

      } catch (e) {
        Get.snackbar('Lổi', e.toString(), colorText: Colors.red);
        print(e);
      } finally {
        update();
      }
    }


    filterByCategory(String category) {
      productShowinUI.clear();
      productShowinUI =
          products.where((product) => product.category == category).toList();
      update();
    }

    filterByBrand(List<String> brands) {
      if (brands.isEmpty) {
        productShowinUI = products;
      } else {
        List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase())
            .toList();
        productShowinUI = products.where((product) {
          return lowerCaseBrands.contains(product.brand?.toLowerCase());
        }).toList();
      }
      update();
    }

    sortByPrice({required bool ascending}) {

      List<Product> sortedProducts = List<Product>.from(productShowinUI);


      sortedProducts.sort((a,b)=> ascending? a. price!.compareTo(b.price!): b.price!.compareTo(a.price!));

      // Gán danh sách đã sắp xếp vào biến sử dụng trong UI
      productShowinUI = sortedProducts;

      // Cập nhật UI
      update();
    }

    void searchProducts(String query) {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        productShowinUI = products; // Nếu không có từ khóa, hiển thị tất cả
      } else {
        productShowinUI = products.where((product) {
          final name = product.name?.toLowerCase() ?? '';
          final brand = product.brand?.toLowerCase() ?? '';
          final category = product.category?.toLowerCase() ?? '';

          return name.contains(searchQuery) ||
              brand.contains(searchQuery) ||
              category.contains(searchQuery);
        }).toList();
      }
      update();
    }

    // Reset tìm kiếm
    void resetSearch() {
      searchQuery = '';
      productShowinUI = products;
      update();
    }
  }

