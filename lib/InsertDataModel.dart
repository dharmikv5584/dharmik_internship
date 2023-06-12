class Insert {
  final bool status;
  final String? messege;

  const Insert({required this.status, this.messege});

  factory Insert.fromJson(Map<String, dynamic> json) {
    return Insert(
      status: json['status'],
      messege: json['messege'],
    );
  }
}