import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final formData = <String, dynamic>{}.obs;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
