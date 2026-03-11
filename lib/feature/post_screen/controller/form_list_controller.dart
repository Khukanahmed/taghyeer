import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taghyeer/feature/products_screen/model/model.dart';

class FormListController extends GetxController {
  var forms = <FormModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadForms();
  }

  Future<void> loadForms() async {
    final form1 = await rootBundle.loadString('assets/forms/form1.json');
    final form2 = await rootBundle.loadString('assets/forms/form2.json');
    final form3 = await rootBundle.loadString('assets/forms/form3.json');

    forms.add(FormModel.fromJson(jsonDecode(form1)));
    forms.add(FormModel.fromJson(jsonDecode(form2)));
    forms.add(FormModel.fromJson(jsonDecode(form3)));
  }
}
