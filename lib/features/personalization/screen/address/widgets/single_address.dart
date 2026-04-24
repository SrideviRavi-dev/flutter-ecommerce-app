import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/features/shop/models/address_model.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class JSingleAddress extends StatelessWidget {
  final AddressModel address;
  final bool selectedAddress;

  const JSingleAddress(
      {super.key, required this.selectedAddress, required this.address});

  @override
  Widget build(BuildContext context) {
    final dark = JHelperFunction.isDarkMode(context);
    return JRoundedContainer(
      width: double.infinity,
      showBorder: true,
      padding: const EdgeInsets.all(JSizes.md),
      backgroundColor: selectedAddress ? JColors.primary : Color(0xFFFFFFF0),
      borderColor: selectedAddress
          ? Colors.transparent
          : (dark ? JColors.darkerGrey : JColors.black),
      margin: const EdgeInsets.only(bottom: JSizes.spaceBtwItems),
      child: Stack(
        children: [
          if (selectedAddress)
            Positioned(
              right: 5,
              top: 0,
              child: Icon(Iconsax.tick_circle5,
                  color: dark ? JColors.light : JColors.dark.withOpacity(0.8)),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
              ),
              const SizedBox(height: JSizes.sm),
              Text(address.phone, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: JSizes.sm),
              Text('${address.address},', softWrap: true),
              Text('${address.city}, ', softWrap: true),
              Text('${address.postalCode}, ${address.country}', softWrap: true),
            ],
          ),
        ],
      ),
    );
  }
}
