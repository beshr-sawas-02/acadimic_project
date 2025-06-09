import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class DialogHelper {
  // Show error dialog
  static void showErrorDialog({
    String title = 'Error',
    String? message,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'Something went wrong',
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show success dialog
  static void showSuccessDialog({
    String title = 'Success',
    String? message,
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'Operation completed successfully',
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  if (onConfirm != null) onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirm dialog
  static void showConfirmDialog({
    String title = 'Confirm',
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'Are you sure you want to continue?',
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) onCancel();
                    },
                    child: Text(cancelText),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show loading dialog
  static void showLoading({String message = 'Loading...'}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: Get.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  // Show snackbar
  static void showSnackbar({
    String title = '',
    String message = '',
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = AppColors.secondary,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: AppColors.textLight,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  // Show error snackbar
  static void showErrorSnackbar({
    String title = 'Error',
    String message = 'Something went wrong',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  // Show success snackbar
  static void showSuccessSnackbar({
    String title = 'Success',
    String message = 'Operation completed successfully',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
    );
  }

  // Show info snackbar
  static void showInfoSnackbar({
    String title = 'Info',
    String message = '',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.info,
    );
  }

  // Show warning snackbar
  static void showWarningSnackbar({
    String title = 'Warning',
    String message = '',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
    );
  }

  // Show bottom sheet
  static void showBottomSheet({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    Get.bottomSheet(
      child,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }
}