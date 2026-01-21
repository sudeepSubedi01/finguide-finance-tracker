import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dashboard/models/transaction.dart';
import '../dashboard/models/timeline_stat.dart';
import '../dashboard/models/category_stat.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.55:5000";
  static const _storage = FlutterSecureStorage();

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  // LOGIN
  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await _storage.write(key: "token", value: data["access_token"]);
        // await saveToken(data["access_token"]);
        return true;
      } else {
        final data = jsonDecode(res.body);
        print("Login failed: ${data['error']}");
        return false;
      }
    } catch (e) {
      print("Error connecting to API: $e");
      return false;
    }
  }

  // REGISTER
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String currencyCode,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "currency_code": currencyCode,
      }),
    );

    return {"status": res.statusCode, "body": jsonDecode(res.body)};
  }

  // DASHBOARD SUMMARY
  static Future<Map<String, dynamic>> getSummary(int user_id) async {
    // final token = await getToken();
    final uri = Uri.parse(
      "$baseUrl/stats/summary",
    ).replace(queryParameters: {"user_id": user_id.toString()});

    final res = await http.get(
      // Uri.parse("$baseUrl/stats/summary"),
      uri,
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to load summary");
    }
    print(res.body);
    return jsonDecode(res.body);
  }

  // TRANSACTIONS
  static Future<List<TransactionModel>> getTransactions(int user_id) async {
    // final token = await getToken();
    final uri = Uri.parse(
      "$baseUrl/transactions",
    ).replace(queryParameters: {"user_id": user_id.toString()});

    final res = await http.get(
      // Uri.parse("$baseUrl/transactions"),
      uri,
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Error from code: Failed to load transactions");
    }

    final List data = jsonDecode(res.body);
    print(data);
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  static Future<List<TimelineStat>> getTimelineStats({
    required int userId,
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse("$baseUrl/stats/timeline").replace(
      queryParameters: {
        "user_id": userId.toString(),
        "start_date": startDate,
        "end_date": endDate,
      },
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Failed to load timeline stats");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => TimelineStat.fromJson(e)).toList();
  }

  static Future<List<CategoryStat>> getCategoryStats({
    required int userId,
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse("$baseUrl/stats/categories").replace(
      queryParameters: {
        "user_id": userId.toString(),
        "start_date": startDate,
        "end_date": endDate,
      },
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Failed to load category stats");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CategoryStat.fromJson(e)).toList();
  }
}
