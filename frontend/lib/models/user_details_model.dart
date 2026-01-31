class UserDetails {
  final int userId;
  final String name;
  final String email;
  final String currencyCode;

  UserDetails({required this.userId, required this.name, required this.email, required this.currencyCode});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      currencyCode: json['currency_code'] ?? '',
    );
  }

  String get firstName => name.trim().split(' ').first;
}
