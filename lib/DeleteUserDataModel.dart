class Delete {
  final bool status;
  final String? messege;

  const Delete({required this.status, this.messege});

  factory Delete.fromJson(Map<String, dynamic> json) {
    return Delete(
      status: json['status'],
      messege: json['messege'],
    );
  }
}


