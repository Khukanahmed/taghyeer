import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taghyeer/core/colors/app_colors.dart';
import 'package:taghyeer/feature/products_screen/controller/product_controller.dart';
import 'package:taghyeer/feature/products_screen/model/product_model.dart';
import 'package:taghyeer/feature/products_screen/view/product_details_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(isDark: isDark),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const _LoadingGrid();
                }

                if (controller.products.isEmpty) {
                  return _EmptyState(isDark: isDark);
                }

                return RefreshIndicator(
                  color: AppColors.accent,
                  onRefresh: controller.refresh,
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _ProductCard(
                              product: controller.products[index],
                              isDark: isDark,
                            ),
                            childCount: controller.products.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.72,
                              ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (controller.isPaginating.value) {
                            return const _PaginationLoader();
                          }
                          return const SizedBox(height: 24);
                        }),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;

  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore our curated collection',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isDark;

  const _ProductCard({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetailScreen(product: product),
        transition: Transition.cupertino,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(60)
                  : Colors.black.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${product.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: isDark
                                ? AppColors.darkTextSub
                                : AppColors.lightTextSub,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFBBC04),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark
                                ? AppColors.darkTextSub
                                : AppColors.lightTextSub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.builder(
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, __) => _ProductShimmerCard(isDark: isDark),
      ),
    );
  }
}

class _ProductShimmerCard extends StatelessWidget {
  final bool isDark;

  const _ProductShimmerCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark
        ? const Color(0xFF2A2A35)
        : const Color(0xFFE0E0E0);
    final highlightColor = isDark
        ? const Color(0xFF3A3A45)
        : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 80, color: Colors.white),
                    const Spacer(),
                    Container(height: 14, width: 60, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 40, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationLoader extends StatelessWidget {
  const _PaginationLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No products found",
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
