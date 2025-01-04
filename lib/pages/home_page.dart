import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sneakerstore_client/controller/home_controller.dart';
import 'package:sneakerstore_client/pages/product_description_page.dart';
import 'package:sneakerstore_client/widget/drop_down_buton.dart';
import 'package:sneakerstore_client/widget/multi_select_drop_down.dart';

import '../widget/product_widget.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: ()async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Sneaker Store',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final box = GetStorage();
                  box.erase();
                  Get.offAll(LoginPage());
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                height: 60,
                margin: const EdgeInsets.only(top: 16),
                child: ListView.builder(

                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productcategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: ()
                      {
                        ctrl.filterByCategory(ctrl.productcategories[index].name ?? '');
                        },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Chip(
                          label:  Text(
                            ctrl.productcategories[index].name ?? 'Error',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16,
                              vertical: 8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropDownBtn(
                          items: const ['Giá cao đến thấp','Giá Thấp đến cao' ],
                          selectedItemText: 'Lọc theo giá',
                          onSelected: (selected) {
                            ctrl.sortByPrice(ascending:  selected == 'Giá Thấp đến cao' ? true : false);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: MultiSelectDropDown(
                          items: ['Adidas', 'New Balance','Timberland' ,'Vans', 'Nike','Converse'],
                          onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: ctrl.productShowinUI.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      name: ctrl.productShowinUI[index].name ?? 'Khong ten',
                      imageUrl: ctrl.productShowinUI[index].image ?? 'Khong ten',
                      price: ctrl.productShowinUI[index].price ?? 00,
                      offer: '30% off',
                      onTap: () {
                      Get.to(ProductDescriptionPage(),arguments:{'data': ctrl.productShowinUI[index]} );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}