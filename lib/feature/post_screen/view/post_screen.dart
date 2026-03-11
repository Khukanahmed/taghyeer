import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taghyeer/core/colors/app_colors.dart';
import 'package:taghyeer/feature/post_screen/controller/post_controller.dart';
import 'package:taghyeer/feature/post_screen/model/post_model.dart';
import 'package:taghyeer/feature/post_screen/view/post_details.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(isDark: isDark),
            Expanded(
              child: Obx(() {
                // ── Initial loading ──────────────────────────────────────
                if (controller.isLoading.value) {
                  return _ShimmerList(isDark: isDark);
                }

                // ── Error / Empty (no data) ──────────────────────────────
                if (controller.posts.isEmpty) {
                  switch (controller.errorType.value) {
                    case PostErrorType.noInternet:
                      return _ErrorState(
                        icon: Icons.wifi_off_rounded,
                        title: 'No Internet',
                        message: controller.errorMessage.value,
                        onRetry: controller.refresh,
                        isDark: isDark,
                      );
                    case PostErrorType.timeout:
                      return _ErrorState(
                        icon: Icons.timer_off_outlined,
                        title: 'Request Timed Out',
                        message: controller.errorMessage.value,
                        onRetry: controller.refresh,
                        isDark: isDark,
                      );
                    case PostErrorType.apiFailure:
                      return _ErrorState(
                        icon: Icons.cloud_off_rounded,
                        title: 'Something Went Wrong',
                        message: controller.errorMessage.value,
                        onRetry: controller.refresh,
                        isDark: isDark,
                      );
                    case PostErrorType.empty:
                    case PostErrorType.none:
                      return _EmptyState(isDark: isDark);
                  }
                }

                // ── Post list ────────────────────────────────────────────
                return RefreshIndicator(
                  color: AppColors.accent,
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: controller.posts.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == controller.posts.length) {
                        return Obx(() {
                          if (controller.isPaginating.value) {
                            return const _PaginationLoader();
                          }
                          if (controller.errorMessage.value.isNotEmpty &&
                              controller.posts.isNotEmpty) {
                            return _PaginationErrorBanner(
                              message: controller.errorMessage.value,
                              errorType: controller.errorType.value,
                              onRetry: controller.refresh,
                              isDark: isDark,
                            );
                          }
                          return const SizedBox(height: 8);
                        });
                      }
                      return _PostCard(
                        post: controller.posts[index],
                        isDark: isDark,
                      );
                    },
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

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Stories from the community',
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

// ── Post Card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final PostModel post;
  final bool isDark;
  const _PostCard({required this.post, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final preview = post.body.length > 100
        ? '${post.body.substring(0, 100)}...'
        : post.body;

    return GestureDetector(
      onTap: () => Get.to(
        () => PostDetailScreen(post: post),
        transition: Transition.cupertino,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(50)
                  : Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.tags
                  .map((tag) => _Tag(tag: tag, isDark: isDark))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              preview,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(
                  icon: Icons.thumb_up_outlined,
                  value: post.likes,
                  isDark: isDark,
                ),
                const SizedBox(width: 14),
                _Stat(
                  icon: Icons.thumb_down_outlined,
                  value: post.dislikes,
                  isDark: isDark,
                ),
                const SizedBox(width: 14),
                _Stat(
                  icon: Icons.remove_red_eye_outlined,
                  value: post.views,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String tag;
  final bool isDark;
  const _Tag({required this.tag, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.accent.withAlpha(18),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      '#$tag',
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final int value;
  final bool isDark;
  const _Stat({required this.icon, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        icon,
        size: 14,
        color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
      ),
      const SizedBox(width: 4),
      Text(
        value.toString(),
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
        ),
      ),
    ],
  );
}

// ── Shimmer Loading List ──────────────────────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  final bool isDark;
  const _ShimmerList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark
        ? const Color(0xFF1E1E2A)
        : const Color(0xFFE8E8EE);
    final highlightColor = isDark
        ? const Color(0xFF2A2A3A)
        : const Color(0xFFF5F5FA);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags placeholder
          Row(
            children: [
              _ShimmerBox(width: 50, height: 20),
              const SizedBox(width: 6),
              _ShimmerBox(width: 60, height: 20),
              const SizedBox(width: 6),
              _ShimmerBox(width: 45, height: 20),
            ],
          ),
          const SizedBox(height: 10),

          // Title placeholder
          _ShimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: 6),
          _ShimmerBox(width: 200, height: 16),
          const SizedBox(height: 10),

          // Body preview placeholder
          _ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 5),
          _ShimmerBox(width: double.infinity, height: 13),
          const SizedBox(height: 5),
          _ShimmerBox(width: 180, height: 13),
          const SizedBox(height: 14),

          // Stats placeholder
          Row(
            children: [
              _ShimmerBox(width: 40, height: 14),
              const SizedBox(width: 14),
              _ShimmerBox(width: 40, height: 14),
              const SizedBox(width: 14),
              _ShimmerBox(width: 40, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

// ── Pagination Loader ─────────────────────────────────────────────────────────

class _PaginationLoader extends StatelessWidget {
  const _PaginationLoader();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.accent,
        ),
      ),
    ),
  );
}

// ── Pagination Error Banner ───────────────────────────────────────────────────

class _PaginationErrorBanner extends StatelessWidget {
  final String message;
  final PostErrorType errorType;
  final VoidCallback onRetry;
  final bool isDark;

  const _PaginationErrorBanner({
    required this.message,
    required this.errorType,
    required this.onRetry,
    required this.isDark,
  });

  IconData get _icon => switch (errorType) {
    PostErrorType.noInternet => Icons.wifi_off_rounded,
    PostErrorType.timeout => Icons.timer_off_outlined,
    _ => Icons.cloud_off_rounded,
  };

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.error.withAlpha(20),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.error.withAlpha(50)),
    ),
    child: Row(
      children: [
        Icon(_icon, color: AppColors.error, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.error, fontSize: 13),
          ),
        ),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Full Error State ──────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool isDark;

  const _ErrorState({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.error, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x506C63FF),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.article_outlined,
          size: 64,
          color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
        ),
        const SizedBox(height: 16),
        Text(
          'No posts found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Check back later for new stories',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
          ),
        ),
      ],
    ),
  );
}
