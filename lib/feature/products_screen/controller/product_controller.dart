import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taghyeer/feature/products_screen/model/product_model.dart';

class ProductController extends GetxController {
  static const String _baseUrl = 'https://dummyjson.com/products';
  static const int _pageSize = 10;

  final scrollController = ScrollController();

  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final isPaginating = false.obs;
  final errorMessage = ''.obs;

  int _skip = 0;
  int _total = 0;
  bool get _hasMore => products.length < _total;

  @override
  void onInit() {
    super.onInit();
    _fetchProducts();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        !isPaginating.value &&
        !isLoading.value &&
        _hasMore) {
      _fetchProducts(isPagination: true);
    }
  }

  Future<void> _fetchProducts({bool isPagination = false}) async {
    if (isPagination) {
      isPaginating.value = true;
    } else {
      isLoading.value = true;
      errorMessage.value = '';
    }

    try {
      final uri = Uri.parse('$_baseUrl?limit=$_pageSize&skip=$_skip');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load products (${response.statusCode})');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final fetched = (json['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      _total = json['total'] as int;
      _skip += fetched.length;
      products.addAll(fetched);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  Future<void> refresh() async {
    _skip = 0;
    _total = 0;
    products.clear();
    await _fetchProducts();
  }
}
