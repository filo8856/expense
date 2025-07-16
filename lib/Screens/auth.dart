import 'dart:convert';
import 'package:expense1/Screens/card_class.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://backend-2-72zt.onrender.com/api';

  Future<String?> register(String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return null; // success
      } else {
        return body['error'] ?? 'Registration failed';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String?> signin(String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return null; // success
      } else {
        return body['error'] ?? 'Login failed';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String?> create(String description, String category,double amount, DateTime date,String user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expense/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': user,
          'amount':amount,
          'description':description,
          'date': date.toIso8601String(),
          'category':category,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return body['createdExpense']['_id']; // success
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  Future<List<Exp>> getExpenses(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expense/all'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> data = body['expenses'];

        return data.map((e) => Exp(
          id:e['_id'],
          desc: e['description'],
          cat: e['category'],
          amount: (e['amount'] as num).toDouble(),
          date: DateTime.parse(e['date']),
        )).toList();
      } else {
        print('Server error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Fetch error: $e');
      return [];
    }
  }
  Future<String?> delete(String expenseId, String userId) async {
    try {
      final url = Uri.parse('$baseUrl/expense/delete/$expenseId');

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return null; // Success
      } else {
        return body['message'] ?? 'Delete failed';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String?> edit(String description, String category,double amount, DateTime date,String user,String id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/expense/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': user,
          'amount':amount,
          'description':description,
          'date': date.toIso8601String(),
          'category':category,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return null; // success
      }
    } catch (e) {
      return null;
    }
  }
}
