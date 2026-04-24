import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/utils/constant/sizes.dart';


class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const JAppBar(
        showBackArrow: true,
        title: Text('Add new Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(JSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration:const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: 'name',
                  ),
                ),
                const SizedBox(
                  height: JSizes.spaceBtwInputFields,
                ),
                TextFormField(
                  decoration:const InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Phone Number',
                  ),
                ),
                const SizedBox(
                  height: JSizes.spaceBtwInputFields,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:const InputDecoration(
                          prefixIcon: Icon(Iconsax.building_31),
                          labelText: 'Street',
                        ),
                      ),
                    ),
                     const SizedBox(
                  width: JSizes.spaceBtwInputFields,
                ),
                    Expanded(
                      child: TextFormField(
                        decoration:const InputDecoration(
                          prefixIcon: Icon(Iconsax.code),
                          labelText: 'Postal code',
                        ),
                      ),
                    ),
                  ],
                ),
                 const SizedBox(
                  height: JSizes.spaceBtwInputFields,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:const InputDecoration(
                          prefixIcon: Icon(Iconsax.building),
                          labelText: 'City',
                        ),
                      ),
                    ),
                     const SizedBox(
                  width: JSizes.spaceBtwInputFields,
                ),
                    Expanded(
                      child: TextFormField(
                        decoration:const InputDecoration(
                          prefixIcon: Icon(Iconsax.activity),
                          labelText: 'State',
                        ),
                      ),
                    ),
                  ],
                ),
                 const SizedBox(
                  height: JSizes.spaceBtwInputFields,
                ),
                 TextFormField(
                        decoration:const InputDecoration(
                          prefixIcon: Icon(Iconsax.global),
                          labelText: 'Country',
                        ),
                      ),
                      const SizedBox(
                  height: JSizes.defaultSpace,
                  
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){}, 
                  child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
