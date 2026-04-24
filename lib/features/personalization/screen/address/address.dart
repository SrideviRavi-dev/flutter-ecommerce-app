import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/features/personalization/controllers/address_controller/address_controller.dart';
import 'package:myapp/features/personalization/screen/address/widgets/single_address.dart';
import 'package:myapp/utils/constant/sizes.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.put(AddressController());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 249, 253),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: JColors.buttonPrimary,
      //   onPressed: () => Get.to(() => const AddNewAddressScreen()),
      //   child: const Icon(Iconsax.add, color: JColors.white),
      // ),
      appBar: JAppBar(
        showBackArrow: true,
        title: Text(
          'Addresses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (addressController.addresses.isEmpty) {
          return const Center(
            child: Text(
              'No Address Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(JSizes.defaultSpace),
          itemCount: addressController.addresses.length,
          itemBuilder: (context, index) {
            final address = addressController.addresses[index];
            return JSingleAddress(selectedAddress: address.selectedAddress, address: address);
          },
        );
      }),
    );
  }
}
