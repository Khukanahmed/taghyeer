import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taghyeer/core/colors/app_colors.dart';
import 'package:taghyeer/core/service/shared_preferences_helper.dart';
import 'package:taghyeer/core/theme/theme_controller.dart';
import 'package:taghyeer/feature/auth/screen/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<Map<String, String>> _loadUser() async {
    final name = await SharedPreferencesHelper.getName() ?? '';
    final email = await SharedPreferencesHelper.getEmail() ?? '';
    final image = await SharedPreferencesHelper.getImage() ?? '';
    final username = await SharedPreferencesHelper.getUsername() ?? '';
    return {'name': name, 'email': email, 'image': image, 'username': username};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 28),

              FutureBuilder<Map<String, String>>(
                future: _loadUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const _UserCardSkeleton();
                  }

                  final user = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withAlpha(60)
                              : Colors.black.withAlpha(10),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _Avatar(imageUrl: user['image']!, isDark: isDark),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name']!,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              _SubText('@${user['username']}', isDark: isDark),
                              const SizedBox(height: 2),
                              _SubText(user['email']!, isDark: isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // ── Preferences ─────────────────────────────────────────────
              _SectionLabel('Preferences', isDark: isDark),
              const SizedBox(height: 10),

              Obx(
                () => _SettingsTile(
                  icon: theme.isDarkMode.value
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  label: 'Dark Mode',
                  isDark: isDark,
                  trailing: Switch(
                    value: theme.isDarkMode.value,
                    onChanged: (_) => theme.toggleTheme(),
                    activeColor: AppColors.accent,
                    activeTrackColor: AppColors.accent.withAlpha(50),
                    inactiveThumbColor: isDark
                        ? const Color(0xFF666680)
                        : const Color(0xFFB0B0C0),
                    inactiveTrackColor: isDark
                        ? const Color(0xFF2A2A3A)
                        : const Color(0xFFE0E0EE),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Account ─────────────────────────────────────────────────
              _SectionLabel('Account', isDark: isDark),
              const SizedBox(height: 10),

              _SettingsTile(
                icon: Icons.logout_rounded,
                label: 'Logout',
                isDark: isDark,
                iconColor: AppColors.error,
                labelColor: AppColors.error,
                onTap: () => _showLogoutDialog(context, isDark),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await SharedPreferencesHelper.clearSession();
              Get.offAll(() => const LoginScreen());
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── User Card Skeleton ────────────────────────────────────────────────────────

class _UserCardSkeleton extends StatelessWidget {
  const _UserCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF0F0F8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 14, isDark: isDark),
                const SizedBox(height: 8),
                _ShimmerBox(width: 90, height: 12, isDark: isDark),
                const SizedBox(height: 6),
                _ShimmerBox(width: 150, height: 12, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE8E8EE),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final bool isDark;
  const _Avatar({required this.imageUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x406C63FF),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(),
                errorWidget: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF0F0F8),
    child: const Icon(Icons.person_rounded, color: AppColors.accent, size: 32),
  );
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
    ),
  );
}

// ── Sub Text ──────────────────────────────────────────────────────────────────

class _SubText extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SubText(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
    ),
  );
}

// ── Settings Tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.isDark,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(40)
                  : Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.accent).withAlpha(18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? AppColors.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color:
                      labelColor ??
                      (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
