import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/shop/controllers/order_controller/order_controller.dart';
import 'package:myapp/features/shop/screen/order/widgets/order_list.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/enum.dart';
import 'package:myapp/utils/constant/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize controller safely
    final OrderController orderController =
        Get.put(OrderController(), permanent: true);

    // ✅ Fetch orders after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: JColors.buttonPrimary,
      ),
      body: Obx(() {
        if (orderController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(JSizes.defaultSpace),
          itemCount: orderController.orders.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: JSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orderController.orders[index];

            /// ✅ 36 HOURS CANCEL LOGIC
            final bool canCancel = order.status == OrderStatus.pending &&
                DateTime.now().difference(order.orderDate).inHours <= 36;

            return Container(
              decoration: BoxDecoration(
                color: JColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: order.items.isNotEmpty &&
                            order.items[0].imageUrls != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              order.items[0].imageUrls!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Iconsax.image,
                            color: JColors.buttonPrimary,
                          ),
                    title: Text(
                      order.items.isNotEmpty ? order.items[0].title : 'Order',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Total: ₹${order.totalAmount}"),
                    trailing: const Icon(Iconsax.arrow_right_34),

                    /// ✅ OPEN ORDER DETAIL SCREEN
                    onTap: () {
                      Get.to(() => OrderDetailScreen(order: order));
                    },
                  ),

                  /// ✅ CANCEL BUTTON (ONLY 36 HOURS)
                  if (canCancel)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          _showCancelDialog(context, order.id);
                        },
                        child: const Text(
                          "Cancel Order",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  /// ✅ CANCEL CONFIRM DIALOG
  void _showCancelDialog(BuildContext context, String orderId) {
    Get.defaultDialog(
      title: "Cancel Order",
      middleText: "Are you sure you want to cancel this order?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Close dialog first
        await OrderController.instance.cancelOrder(orderId);
      },
    );
  }
}
