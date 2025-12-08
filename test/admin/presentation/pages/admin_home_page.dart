import 'package:flutter/material.dart';
import '../../../../lib/core/theme/app_colors.dart';
import '../../../../lib/core/theme/app_text_styles.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userEmail = args?['userEmail'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin',
              style: AppTextStyles.title1.copyWith(color: AppColors.neutral1),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: AppTextStyles.body3.copyWith(color: AppColors.neutral3),
            ),
            const SizedBox(height: 24),
            Text(
              'Demo quyền Admin',
              style: AppTextStyles.title3.copyWith(color: AppColors.neutral1),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Khu vực này chỉ dành cho tài khoản có role=admin.\n'
                'Bạn có thể đặt các chức năng quản trị (quản lý người dùng, phê duyệt, báo cáo...) ở đây.',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Thoát'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

