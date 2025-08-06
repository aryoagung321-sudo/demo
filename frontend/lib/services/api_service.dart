import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_data.dart';

class ApiService {
  // Use localhost for development, change to production URL when deploying
  static const String baseUrl = 'http://localhost:9000/api';
  // static const String baseUrl = 'https://d.seoikrom.com/api'; // Production URL
  
  // Login dengan nomor telepon
  static Future<Map<String, dynamic>> loginWithPhone(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber}),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Verifikasi OTP
  static Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'otp': otp,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('OTP verification failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Submit form data (new endpoint for Flutter app)
  static Future<Map<String, dynamic>> submitFormData(UserData userData) async {
    try {
      print('Submitting to: $baseUrl/flutter/submit-form');
      print('Data: ${userData.toJson()}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/flutter/submit-form'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData.toJson()),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Form data submission failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in submitFormData: $e');
      throw Exception('Network error: $e');
    }
  }
  
  // Submit loan data (new endpoint for Flutter app)
  static Future<Map<String, dynamic>> submitLoanData(Map<String, dynamic> loanData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/flutter/submit-loan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loanData),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Loan data submission failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Submit data user (legacy endpoint)
  static Future<Map<String, dynamic>> submitUserData(UserData userData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userData.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Data submission failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Upload foto KTP (new endpoint for Flutter app)
  static Future<Map<String, dynamic>> uploadKtpPhoto(File photoFile, String userId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/flutter/upload-photo'),
      );
      
      request.fields['userId'] = userId;
      request.fields['photoType'] = 'ktp';
      request.files.add(
        await http.MultipartFile.fromPath('photo', photoFile.path),
      );
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('KTP upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
  
  // Upload foto KTP (legacy endpoint)
  static Future<Map<String, dynamic>> uploadKtpPhotoLegacy(File photoFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/ktp'),
      );
      
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('ktp_photo', photoFile.path),
      );
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('KTP upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
  
  // Upload foto selfie (new endpoint for Flutter app)
  static Future<Map<String, dynamic>> uploadSelfiePhoto(File photoFile, String userId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/flutter/upload-photo'),
      );
      
      request.fields['userId'] = userId;
      request.fields['photoType'] = 'selfie';
      request.files.add(
        await http.MultipartFile.fromPath('photo', photoFile.path),
      );
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Selfie upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
  
  // Upload foto selfie (legacy endpoint)
  static Future<Map<String, dynamic>> uploadSelfiePhotoLegacy(File photoFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/selfie'),
      );
      
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('selfie_photo', photoFile.path),
      );
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Selfie upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
  
  // Submit loan application
  static Future<Map<String, dynamic>> submitLoanApplication(Map<String, dynamic> loanData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loans'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(loanData),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Loan application failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Get loan products (new endpoint for Flutter app)
  static Future<List<Map<String, dynamic>>> getLoanProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/flutter/loan-products'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['loanProducts'] != null) {
          final List<dynamic> products = data['loanProducts'];
          return products.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to get loan products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Get loan products (legacy endpoint)
  static Future<List<Map<String, dynamic>>> getLoanProductsLegacy() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/loan-products'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get loan products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Get loan status
  static Future<List<Map<String, dynamic>>> getLoanStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loans/status'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get loan status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 