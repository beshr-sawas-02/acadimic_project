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

  // Form values as RxString
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString dob = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;

  // TextEditingControllers (ثابتة، لا تُنشأ جديدة في كل بناء)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // مزامنة قيم Rx مع النصوص في الـ Controllers
    nameController.text = name.value;
    emailController.text = email.value;
    dobController.text = dob.value;
    passwordController.text = password.value;
    confirmPasswordController.text = confirmPassword.value;

    // تحديث Rx عند تغيير النصوص
    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    dobController.addListener(() => dob.value = dobController.text);
    passwordController.addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(() => confirmPassword.value = confirmPasswordController.text);

    fetchAllEmployees();
  }

  // Fetch all employees
  Future<void> fetchAllEmployees() async {
    try {
      isLoading.value = true;
      final result = await _employeeRepository.getAllEmployees();
      employees.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to fetch employees: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get employee by ID
  Future<void> getEmployeeById(String id) async {
    try {
      isLoading.value = true;
      final result = await _employeeRepository.getEmployeeById(id);
      selectedEmployee.value = result;

      // تحديث قيم الفورم و TextEditingControllers
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
        title: 'Error',
        message: 'Failed to get employee: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create employee
  Future<void> createEmployee() async {
    if (name.value.isEmpty || email.value.isEmpty || dob.value.isEmpty || password.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Please fill all required fields',
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Passwords do not match',
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
        title: 'Success',
        message: AppConstants.createSuccess,
      );

      resetForm();

      fetchAllEmployees();

      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to create employee: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update employee
  Future<void> updateEmployee() async {
    if (selectedEmployee.value == null) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'No employee selected',
      );
      return;
    }

    if (password.value.isNotEmpty && password.value != confirmPassword.value) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Passwords do not match',
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
        title: 'Success',
        message: AppConstants.updateSuccess,
      );

      fetchAllEmployees();

      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to update employee: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete employee
  Future<void> deleteEmployee(String id) async {
    DialogHelper.showConfirmDialog(
      title: 'Delete Employee',
      message: 'Are you sure you want to delete this employee?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _employeeRepository.deleteEmployee(id);

          DialogHelper.showSuccessSnackbar(
            title: 'Success',
            message: AppConstants.deleteSuccess,
          );

          fetchAllEmployees();

          if (selectedEmployee.value != null && selectedEmployee.value!.id == id) {
            selectedEmployee.value = null;
            Get.back();
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'Error',
            message: 'Failed to delete employee: ${e.toString()}',
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  // Reset form
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

  // Set selected employee for editing
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
