import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/employee_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class AddEditEmployeeScreen extends StatelessWidget {
  const AddEditEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();
    final isEditing = controller.selectedEmployee.value != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_employee'.tr : 'add_employee'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'employee_information'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        CustomTextField(
                          label: 'name'.tr,
                          hint: 'enter_employee_name'.tr,
                          icon: Icons.person,
                          controller: controller.nameController,
                          onChanged: (value) => controller.name.value = value,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        CustomTextField(
                          label: 'email'.tr,
                          hint: 'enter_employee_email'.tr,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          onChanged: (value) => controller.email.value = value,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Date of Birth
                        CustomTextField(
                          label: 'dob'.tr,
                          hint: 'YYYY-MM-DD',
                          icon: Icons.calendar_today,
                          controller: controller.dobController,
                          readOnly: true,
                          onTap: () => _selectDate(context, controller),
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        CustomTextField(
                          label: isEditing
                              ? 'new_password_hint'.tr
                              : 'password'.tr,
                          hint: isEditing ? 'enter_new_password'.tr : 'enter_password'.tr,
                          icon: Icons.lock,
                          isPassword: true,
                          controller: controller.passwordController,
                          onChanged: (value) => controller.password.value = value,
                          required: !isEditing,
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        CustomTextField(
                          label: isEditing ? 'confirm_new_password'.tr : 'confirm_password'.tr,
                          hint: 'confirm_password_hint'.tr,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: controller.confirmPasswordController,
                          onChanged: (value) => controller.confirmPassword.value = value,
                          required: !isEditing,
                        ),
                        const SizedBox(height: 24),

                        CustomButton(
                          text: isEditing ? 'update_employee'.tr : 'add_employee'.tr,
                          onPressed:
                          isEditing ? controller.updateEmployee : controller.createEmployee,
                          backgroundColor: AppColors.secondary,
                          icon: isEditing ? Icons.save : Icons.add,
                          width: double.infinity,
                          height: 56,
                          isLoading: controller.isLoading.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context, EmployeeController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dob.value.isNotEmpty
          ? DateTime.parse(controller.dob.value)
          : DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.dob.value = DateFormat('yyyy-MM-dd').format(picked);
      controller.dobController.text = controller.dob.value;
    }
  }
}
