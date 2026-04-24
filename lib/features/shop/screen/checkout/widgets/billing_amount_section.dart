import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JBillingAmountSecetion extends StatelessWidget {
  final double subtotal;
  final double shippingAmount;
  final double taxAmount;
  final double totalAmount;

  const JBillingAmountSecetion({
    super.key,
    required this.subtotal,
    required this.shippingAmount,
    required this.taxAmount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("SubTotal", style: Theme.of(context).textTheme.bodyMedium),
            Text("₹${subtotal.toStringAsFixed(2)}", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: JSizes.spaceBtwItems / 2),

        // Shipping Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Shipping Amount", style: Theme.of(context).textTheme.bodyMedium),
            Text("₹${shippingAmount.toStringAsFixed(2)}", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: JSizes.spaceBtwItems / 2),

        // Tax Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tax Amount", style: Theme.of(context).textTheme.bodyMedium),
            Text("₹${taxAmount.toStringAsFixed(2)}", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: JSizes.spaceBtwItems / 2),

        // Total Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Order Total", style: Theme.of(context).textTheme.bodyMedium),
            Text("₹${totalAmount.toStringAsFixed(2)}", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
