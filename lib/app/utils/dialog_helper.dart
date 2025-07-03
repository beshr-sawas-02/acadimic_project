import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class DialogHelper {
  // Show error dialog
  static void showErrorDialog({
    String title = 'error',
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
                title.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                (message ?? 'something_wrong').tr,
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: Text('ok'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show success dialog
  static void showSuccessDialog({
    String title = 'success',
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
                title.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                (message ?? 'operation_completed').tr,
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
                child: Text('ok'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirm dialog
  static void showConfirmDialog({
    String title = 'confirm',
    String? message,
    String confirmText = 'confirm',
    String cancelText = 'cancel',
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
                title.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                (message ?? 'confirm_continue').tr,
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
                    child: Text(cancelText.tr),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmText.tr),
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
  static void showLoading({String message = 'loading'}) {
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
                message.tr,
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
      title.tr,
      message.tr,
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
    String title = 'error',
    String message = 'something_wrong',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  // Show success snackbar
  static void showSuccessSnackbar({
    String title = 'success',
    String message = 'operation_completed',
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
    );
  }

  // Show info snackbar
  static void showInfoSnackbar({
    String title = 'info',
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
    String title = 'warning',
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
