import 'package:flutter/material.dart';
import 'package:taghyeer/core/colors/app_colors.dart';
import 'package:taghyeer/feature/post_screen/model/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            foregroundColor: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0x22FFFFFF)
                        : const Color(0x12000000),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: post.tags.map((tag) => _Tag(tag: tag)).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatChip(
                          icon: Icons.thumb_up_outlined,
                          label: 'Likes',
                          value: post.likes.toString(),
                          color: const Color(0xFF4CAF50),
                          isDark: isDark,
                        ),
                        _Divider(isDark: isDark),
                        _StatChip(
                          icon: Icons.thumb_down_outlined,
                          label: 'Dislikes',
                          value: post.dislikes.toString(),
                          color: AppColors.error,
                          isDark: isDark,
                        ),
                        _Divider(isDark: isDark),
                        _StatChip(
                          icon: Icons.remove_red_eye_outlined,
                          label: 'Views',
                          value: post.views.toString(),
                          color: AppColors.accent,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 20),

                  // Body
                  Text(
                    post.body,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // User ID chip
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent.withAlpha(25),
                        child: Text(
                          'U${post.userId}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'User #${post.userId}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
    );
  }
}

class _Tag extends StatelessWidget {
  final String tag;
  const _Tag({required this.tag});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.accent.withAlpha(18),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      '#$tag',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
      ),
    ),
  );
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
        ),
      ),
    ],
  );
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 40,
    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
  );
}
