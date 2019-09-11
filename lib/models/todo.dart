import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:httpcrud/global.dart';
class Todo {
  int id;
  String name;
  String dueDate;
  String description;

  Todo({this.id, this.name, this.dueDate, this.description});

  //this is a static method

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        name: json['name'],
        dueDate: json['duedate'],
        description: json['description']);
  }
}

Future<List<Todo>> fetchTodos(http.Client client) async {
  final response=await client.get(URL_TODOS);

  if(response.statusCode==200){
    var mapResponse=convert.jsonDecode(response.body);

    if(mapResponse[0]['result']=="ok"){

      final todos=mapResponse[0]["data"].cast<Map<String, dynamic>>();

      print(todos.runtimeType);
      final listOfTodos=await todos.map<Todo>((json){
        return Todo.fromJson(json);
      }).toList();

      return listOfTodos;

    }
    else{
      return [];
    }



  }
  else{
    throw Exception('Failed to load Todo from the internet');
  }
  
  
}
