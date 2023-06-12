import 'User.dart';

class DataModel{
  DataModel({required this.status, required this.message, required this.response});
  bool status;
  String message;
  List<User> response;

  factory DataModel.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['response'] as List;

   List<User> userList = list.map((i) => User.fromJson(i)).toList();
    print(userList);

    return DataModel(
        status: parsedJson['status'],
        message: parsedJson['message'],
        response: userList
    );
  }
}







