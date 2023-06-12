
class User{

  User({
    required this.registration_main_id,
    required this.user_code,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.phone_number,
    required this.phone_country_code,
    required this.email,
    required this.created_time,

  });

  String registration_main_id = "";
  String user_code ="";
  String first_name ="";
  String middle_name ="";
  String last_name ="";
  String phone_number ="";
  String phone_country_code ="";
  String email ="";
  String created_time ="";

   User.fromJson(Map<String, dynamic> parsedJson) {
      registration_main_id = parsedJson['registration_main_id'];
      user_code = parsedJson['user_code'];
      first_name = parsedJson['first_name'];
      middle_name = parsedJson['middle_name'];
      last_name = parsedJson['last_name'];
      phone_number = parsedJson['phone_number'];
      phone_country_code = parsedJson['phone_country_code'];
      email = parsedJson['email'];
      created_time = parsedJson['created_time'];
    }
}