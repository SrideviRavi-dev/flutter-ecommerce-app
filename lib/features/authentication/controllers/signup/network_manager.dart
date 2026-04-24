// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';

class NetworkManager extends GetxController{
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

   @override
void onInit() {
  super.onInit();
  _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
    _connectionStatus.value = results.first; // Get the first element (current status)
    if (_connectionStatus.value == ConnectivityResult.none) {
      JLoaders.warningSnackBar(title: 'No Internet Connection');
    }
  });
}
  
  Future<bool> isConnected() async{
  try{
    final result = await _connectivity.checkConnectivity();
    if(result == ConnectivityResult.none){
      return false;
    }else{
      return true;
    }
  }on PlatformException catch(_) {
    return false;
  }
 }

 @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
}

}