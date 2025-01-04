import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử đặt hàng'),
          backgroundColor: Colors.black, // Màu chủ đạo
        ),
        body: ctrl.orders.isNotEmpty
            ? ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: ctrl.orders.length,
          itemBuilder: (context, index) {
            final order = ctrl.orders[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    order.image ?? '',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 70),
                  ),
                ),
                title: Text(
                  order.productName ?? 'Không rõ tên',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          order.orderDate.toString() ?? 'Không rõ ngày',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '${order.totalPrice?.toStringAsFixed(2)} VNĐ',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Xử lý xóa sản phẩm
                    //ctrl.deleteOrder(order.id);
                  },
                ),
              ),
            );
          },
        )
            : const Center(
          child: Text(
            'Bạn chưa có đơn hàng nào!',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    });
  }
}
