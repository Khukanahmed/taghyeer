import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taghyeer/feature/post_screen/model/post_model.dart';

enum PostErrorType { none, noInternet, timeout, apiFailure, empty }

class PostController extends GetxController {
  static const String _baseUrl = 'https://dummyjson.com/posts';
  static const int _pageSize = 10;

  final scrollController = ScrollController();

  final posts = <PostModel>[].obs;
  final isLoading = true.obs;
  final isPaginating = false.obs;
  final errorMessage = ''.obs;
  final errorType = PostErrorType.none.obs;

  int _skip = 0;
  int _total = 0;
  bool get _hasMore => posts.length < _total;

  @override
  void onInit() {
    super.onInit();
    _fetchPosts();
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
      _fetchPosts(isPagination: true);
    }
  }

  Future<void> _fetchPosts({bool isPagination = false}) async {
    if (isPagination) {
      isPaginating.value = true;
    } else {
      isLoading.value = true;
      errorMessage.value = '';
      errorType.value = PostErrorType.none;
    }

    try {
      final uri = Uri.parse('$_baseUrl?limit=$_pageSize&skip=$_skip');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        errorType.value = PostErrorType.apiFailure;
        errorMessage.value =
            'Server error (${response.statusCode}). Please try again.';
        return;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final fetched = (json['posts'] as List)
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList();

      _total = json['total'] as int;
      _skip += fetched.length;
      posts.addAll(fetched);

      if (posts.isEmpty) {
        errorType.value = PostErrorType.empty;
      }
    } on SocketException {
      errorType.value = PostErrorType.noInternet;
      errorMessage.value = 'No internet connection. Check your network.';
    } on TimeoutException {
      errorType.value = PostErrorType.timeout;
      errorMessage.value = 'Request timed out. Please try again.';
    } catch (_) {
      errorType.value = PostErrorType.apiFailure;
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    _skip = 0;
    _total = 0;
    posts.clear();
    await _fetchPosts();
  }
}
