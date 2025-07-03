import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/employee_model.dart';
import '../data/repositories/employee_repository.dart';
import '../utils/dialog_helper.dart';
import '../utils/constants.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _employeeRepository = Get.find<EmployeeRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Employee> employees = <Employee>[].obs;
  final Rx<Employee?> selectedEmployee = Rx<Employee?>(null);

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString dob = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    nameController.text = name.value;
    emailController.text = email.value;
    dobController.text = dob.value;
    passwordController.text = password.value;
    confirmPasswordController.text = confirmPassword.value;

    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    dobController.addListener(() => dob.value = dobController.text);
    passwordController.addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(() => confirmPassword.value = confirmPasswordController.text);

    fetchAllEmployees();
  }

  Future<void> fetchAllEmployees() async {
    try {
      isLoading.value = true;
      final result = await _employeeRepository.getAllEmployees();
      employees.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'fetch_failed'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getEmployeeById(String id) async {
    try {
      isLoading.value = true;
      final result = await _employeeRepository.getEmployeeById(id);
      selectedEmployee.value = result;

      name.value = result.name;
      email.value = result.email;
      dob.value = result.dob;
      password.value = '';
      confirmPassword.value = '';

      nameController.text = name.value;
      emailController.text = email.value;
      dobController.text = dob.value;
      passwordController.text = password.value;
      confirmPasswordController.text = confirmPassword.value;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'get_failed'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createEmployee() async {
    if (name.value.isEmpty || email.value.isEmpty || dob.value.isEmpty || password.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'fill_required_fields'.tr,
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'passwords_not_match'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final createRequest = CreateEmployeeRequest(
        name: name.value,
        email: email.value,
        dob: dob.value,
        password: password.value,
      );

      await _employeeRepository.createEmployee(createRequest);

      DialogHelper.showSuccessSnackbar(
        title: 'success'.tr,
        message: 'create_success'.tr,
      );

      resetForm();
      fetchAllEmployees();
      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'create_failed'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmployee() async {
    if (selectedEmployee.value == null) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'no_employee_selected'.tr,
      );
      return;
    }

    if (password.value.isNotEmpty && password.value != confirmPassword.value) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'passwords_not_match'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final updateRequest = UpdateEmployeeRequest(
        name: name.value != selectedEmployee.value!.name ? name.value : null,
        email: email.value != selectedEmployee.value!.email ? email.value : null,
        dob: dob.value != selectedEmployee.value!.dob ? dob.value : null,
        password: password.value.isNotEmpty ? password.value : null,
      );

      await _employeeRepository.updateEmployee(selectedEmployee.value!.id, updateRequest);

      DialogHelper.showSuccessSnackbar(
        title: 'success'.tr,
        message: 'update_success'.tr,
      );

      fetchAllEmployees();
      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'update_failed'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmployee(String id) async {
    DialogHelper.showConfirmDialog(
      title: 'delete_employee'.tr,
      message: 'delete_confirmation'.tr,
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _employeeRepository.deleteEmployee(id);

          DialogHelper.showSuccessSnackbar(
            title: 'success'.tr,
            message: 'delete_success'.tr,
          );

          fetchAllEmployees();

          if (selectedEmployee.value != null && selectedEmployee.value!.id == id) {
            selectedEmployee.value = null;
            Get.back();
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'error'.tr,
            message: '${'delete_failed'.tr}: ${e.toString()}',
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void resetForm() {
    name.value = '';
    email.value = '';
    dob.value = '';
    password.value = '';
    confirmPassword.value = '';

    nameController.clear();
    emailController.clear();
    dobController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void setSelectedEmployee(Employee employee) {
    selectedEmployee.value = employee;

    name.value = employee.name;
    email.value = employee.email;
    dob.value = employee.dob;
    password.value = '';
    confirmPassword.value = '';

    nameController.text = name.value;
    emailController.text = email.value;
    dobController.text = dob.value;
    passwordController.text = password.value;
    confirmPasswordController.text = confirmPassword.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
