import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/purchase_controller.dart';
import '../model/product/product.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, color: Colors.black),
                  ),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-',
                  child: Container(
                    color: Colors.grey[100],
                    child: Image.network(
                      product.image ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm và giá
                      Text(
                        product.name ?? 'Product Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \$${product.price ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Chọn kích cỡ giày
                      const Text(
                        'Select Size',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          String size = '${40 + index}'; // Tạo kích cỡ từ 40 đến 47
                          return GestureDetector(
                            onTap: () {
                              ctrl.updateSize(size);  // Cập nhật kích cỡ khi người dùng chọn
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ctrl.size == size ? Colors.black : Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.size == size ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Số lượng và giá tổng
                      const Text(
                        'Select Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              ctrl.decreaseQuantity(product.price ?? 0);
                            },
                          ),
                          Text(
                            '${ctrl.quantity}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              ctrl.increaseQuantity(product.price ?? 0);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Trường nhập địa chỉ
                      const Text(
                        'Enter Delivery Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: ctrl.addressController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your address',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          ctrl.updateAddress(value); // Cập nhật địa chỉ khi người dùng nhập
                        },
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Total Price: \$${ctrl.totalPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ctrl.submitOrder(
                      price: product.price ?? 0,
                      item: product.name ?? '',
                      description: product.description ?? '',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
