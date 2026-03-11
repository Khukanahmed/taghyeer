// lib/controllers/auth_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
            Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': usernameController.text.trim(),
              'password': passwordController.text.trim(),
              'expiresInMins': 30,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  String? validateUsername(String? val) {
    if (val == null || val.trim().isEmpty) return 'Username is required';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.trim().isEmpty) return 'Password is required';
    if (val.length < 4) return 'Password must be at least 4 characters';
    return null;
  }
}
