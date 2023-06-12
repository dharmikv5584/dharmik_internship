import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'DataModel.dart';
import 'User.dart';
import 'InsertPage.dart';
import 'UpdateUserPage.dart';

enum SortField {
  RegistrationMainId,
  UserCode,
  FirstName,
  MiddleName,
  LastName,
  PhoneNumber,
  PhoneCountryCode,
  Email,
  CreatedTime,
}

enum FilterOption {
  All,
  MoreThan24Hours,
  LessThan24Hours,
}

class ListPage extends StatefulWidget {
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  List<User> _users = [];
  SortField currentSortField = SortField.FirstName;
  String searchText = '';
  bool isSearching = false;
  List<User> filteredUsers = [];
  FilterOption currentFilterOption = FilterOption.All;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getList();
    _users = filteredUsers;
  }

  void sortStudents() {
    filteredUsers = _users
        .where((user) =>
            user.first_name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    switch (currentFilterOption) {
      case FilterOption.MoreThan24Hours:
        filteredUsers = filteredUsers.where((user) {
          DateTime currentTime = DateTime.now();
          DateTime createdTime = DateTime.parse(user.created_time);
          Duration difference = currentTime.difference(createdTime);
          return difference.inHours > 24;
        }).toList();
        break;
      case FilterOption.LessThan24Hours:
        filteredUsers = filteredUsers.where((user) {
          DateTime currentTime = DateTime.now();
          DateTime createdTime = DateTime.parse(user.created_time);
          Duration difference = currentTime.difference(createdTime);
          return difference.inHours <= 24;
        }).toList();
        break;
      case FilterOption.All:
      default:
        // No additional filtering required
        break;
    }

    switch (currentSortField) {
      case SortField.RegistrationMainId:
        _users.sort(
            (a, b) => a.registration_main_id.compareTo(b.registration_main_id));
        break;
      case SortField.UserCode:
        _users.sort((a, b) => a.user_code.compareTo(b.user_code));
        break;
      case SortField.FirstName:
        _users.sort((a, b) => a.first_name.compareTo(b.first_name));
        break;
      case SortField.MiddleName:
        _users.sort((a, b) => a.middle_name.compareTo(b.middle_name));
        break;
      case SortField.LastName:
        _users.sort((a, b) => a.last_name.compareTo(b.last_name));
        break;
      case SortField.PhoneNumber:
        _users.sort((a, b) => a.phone_number.compareTo(b.phone_number));
        break;
      case SortField.PhoneCountryCode:
        _users.sort(
            (a, b) => a.phone_country_code.compareTo(b.phone_country_code));
        break;
      case SortField.Email:
        _users.sort((a, b) => a.email.compareTo(b.email));
        break;
      case SortField.CreatedTime:
        _users.sort((a, b) => a.created_time.compareTo(b.created_time));
        break;
    }
  }



  void getList() async {
    // Create the request body
    Map<String, dynamic> requestBody = {};

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);

    await Future.delayed(Duration(seconds: 2));
    // Make the API call to validate login credentials
    final response = await http.post(
      Uri.parse(
          'https://glexas.com/hostel_data/API/test/new_admission_list.php'),
      headers: {'Content-Type': 'application/json'},
      body: requestBodyJson,
    );

    var x = json.decode(response.body);
    var listResponse = DataModel.fromJson(x);
    setState(() => _users = listResponse.response);
    setState(() {
      _isLoading = false;
    });
  }



  void deleteUser(int i) async {
    Map<String, dynamic> requestBody = {
      'registration_main_id': _users[i].registration_main_id
    };
    // Make the API call to validate login credentials
    final deleteResponse = await http.post(
      Uri.parse(
          'https://glexas.com/hostel_data/API/test/new_admission_delete.php'),
      body: requestBody,
    );
    if (deleteResponse.statusCode == 200) {
      _users.removeAt(i);
      setState(() => _users = _users);
      getList();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Succesfull'),
          content: Text('User is Deleted Successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      throw Exception('Failed to delete album.');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Failed'),
          content: Text(deleteResponse.toString()),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      throw Exception('Failed to delete album.');
    }
  }




  void showDetails(BuildContext context, List<User> student, int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Student Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registration Id : ${student[i].registration_main_id}'),
              Text('User Code : ${student[i].user_code}'),
              Text('First Name : ${student[i].first_name}'),
              Text('Middle Name : ${student[i].middle_name}'),
              Text('Last Name : ${student[i].last_name}'),
              Text(
                  'Phone Number : ${student[i].phone_country_code} ${student[i].phone_number}'),
              Text('Email : ${student[i].email}'),
              Text('Created Time : ${student[i].created_time}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: !isSearching
            ? Text('Student Details')
            : TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    sortStudents();
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchText = '';
                      sortStudents();
                    });
                  },
                  icon: Icon(Icons.cancel),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<SortField>(
              value: currentSortField,
              onChanged: (SortField? newValue) {
                setState(() {
                  currentSortField = newValue!;
                  sortStudents();
                });
              },
              icon: Icon(Icons.sort, color: Colors.purple),
              items: SortField.values.map<DropdownMenuItem<SortField>>(
                (SortField value) {
                  String fieldName = value.toString().split('.').last;
                  return DropdownMenuItem<SortField>(
                    value: value,
                    child: Text(fieldName),
                  );
                },
              ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<FilterOption>(
              value: currentFilterOption,
              onChanged: (FilterOption? option) {
                setState(() {
                  currentFilterOption = option!;

                });
              },
              icon: Icon(Icons.filter_alt_outlined, color: Colors.purple),
              items: FilterOption.values.map((FilterOption option) {
                return DropdownMenuItem<FilterOption>(
                  value: option,
                  child: Text(option.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length > 0 ? filteredUsers.length : 1,
              itemBuilder: (BuildContext context, int i) {
                final student = _users[i];

                //should Display button
                String createdTimeString = _users[i].created_time;
                DateTime createdTime = DateTime.parse(createdTimeString);
                DateTime currentTime = DateTime.now();
                Duration timeDifference = currentTime.difference(createdTime);
                int hoursDifference = timeDifference.inHours;
                bool shouldDisplayButtons = hoursDifference > 24;

                if (filteredUsers.isNotEmpty) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text('${filteredUsers[i].first_name} ${filteredUsers[i].middle_name}'),
                        const Expanded(
                          child: SizedBox.shrink(),
                          flex: 3,
                        ),
                        InkWell(
                          child: shouldDisplayButtons
                              ? const Icon(
                                  Icons.edit,
                                  color: Colors.black87,
                                  size: 25,
                                )
                              : SizedBox(),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Update Student'),
                                    content: const Text(
                                        'You can update the student data here.'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Update'),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          final Updateresult =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateUserPage()),
                                          );
                                          getList();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          child: shouldDisplayButtons
                              ? const Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                )
                              : SizedBox(),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Student'),
                                    content: const Text(
                                        'Are you sure, You want to delete?'),
                                    actions: [
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          deleteUser(
                                              i); //deleteUser Function Call.
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      showDetails(context, filteredUsers, i);
                    },
                  );
                } else {
                  return const ListTile(
                    title: Text('No results'),
                  );
                }
                ;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Insert Student'),
                  content: Text('You can insert a new student here.'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Insert'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InsertPage()),
                        );
                        getList();
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
