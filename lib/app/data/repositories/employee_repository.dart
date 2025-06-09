import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/employee_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class EmployeeRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Create employee
  Future<Employee> createEmployee(CreateEmployeeRequest request) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.createEmployee,
        data: request.toMap(),
      );

      return Employee.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to create employee';
      } else {
        throw e.message ?? 'Failed to create employee';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get all employees
  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await _apiProvider.get(
        ApiConstants.findAllEmployees,
      );

      return (response.data as List)
          .map((employee) => Employee.fromMap(employee))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get employees';
      } else {
        throw e.message ?? 'Failed to get employees';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get employee by id
  Future<Employee> getEmployeeById(String id) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.employees}/find-byid/$id',
      );

      return Employee.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get employee';
      } else {
        throw e.message ?? 'Failed to get employee';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Update employee
  Future<Employee> updateEmployee(String id, UpdateEmployeeRequest request) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.employees}/update/$id',
        data: request.toMap(),
      );

      return Employee.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to update employee';
      } else {
        throw e.message ?? 'Failed to update employee';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete employee
  Future<String> deleteEmployee(String id) async {
    try {
      final response = await _apiProvider.delete(
        '${ApiConstants.employees}/delete/$id',
      );

      return response.data['message'] ?? 'Employee deleted successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to delete employee';
      } else {
        throw e.message ?? 'Failed to delete employee';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}