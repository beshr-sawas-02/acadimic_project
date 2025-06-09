import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import 'custom_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.hourglass_empty,
    this.onAction,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: actionText!,
              onPressed: onAction!,
              backgroundColor: AppColors.secondary,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
}