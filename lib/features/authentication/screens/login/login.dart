import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/auth_controller/auth_controller.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(AuthController());
  late Timer _timer;   
  int _start = 30; // 30 seconds countdown
  bool _isResendEnabled = false;

  void startTimer() {
    setState(() {
      _isResendEnabled = false;
      _start = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendOtp() {
    if (_isResendEnabled) {
      controller.sendOtp();
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(JSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logos/new_logo.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: JSizes.sm),
            Text(
              JTexts.loginTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: JSizes.sm),
            Text(
              JTexts.loginsubTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: JSizes.lg),
            TextField(
              controller: controller.phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: JTexts.phoneNo,
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: JSizes.spaceBtwInputFields),

            // Send OTP Button with Loader
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () {
                      controller.sendOtp();
                      startTimer();
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(JTexts.sentotp),
                  ),
                )),
                
            const SizedBox(height: JSizes.sm),

            Center(
              child: Text(
                _isResendEnabled
                    ? "Didn't receive the OTP?"
                    : "Resend OTP in $_start seconds",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _isResendEnabled ? resendOtp : null,
                child: const Text("Resend OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
