import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:httpcrud/global.dart';
class Task {
  int id;
  String name;
  bool finished;
  int todoId;



  //Constructor
  Task({this.id, this.name, this.finished, this.todoId});

  factory Task.fromJson(Map<String, dynamic> json) {
    Task newTask = Task(
        id: json['id'],
        name: json['name'],
        finished: json['isfinished']=='true'? true : false,
        todoId: json['todoid']);

    return newTask;
  }

  //clone a Task or copy constructor

factory Task.fromTask(Task anotherTask){
    return Task(
      id: anotherTask.id,
      name: anotherTask.name,
      finished: anotherTask.finished,
      todoId: anotherTask.todoId
    );
}
}
//Controllers =" functions relating to Task

Future<List<Task>> fetchTasks(http.Client client, int todoId) async{
  print('$URL_TASKS_BY_TODOID$todoId');
  final response=await client.get('$URL_TASKS_BY_TODOID$todoId');
  if(response.statusCode==200){
    var mapResponse=convert.jsonDecode(response.body);
    if(mapResponse[0]['result']=='ok'){
      final tasks=mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return tasks.map<Task>((json){
        return Task.fromJson(json);
      }).toList();
    }
    else{
      return [];
    }
  }
  else{
    throw Exception('Failed to load Task');
  }
}


//fetch task by id

Future<Task> fetchTaskById(http.Client client, int taskId) async{
  print('$URL_TASKS_BY_TASKID$taskId');
  final response=await client.get('$URL_TASKS_BY_TASKID$taskId');
  if(response.statusCode==200){
    var mapResponse=convert.jsonDecode(response.body);
    if(mapResponse[0]['result']=='ok'){
      var mapTask=mapResponse[0]['data'];
        return Task.fromJson(mapTask);
    }
    else{
      return Task();
    }
  }
  else{
    throw Exception('Failed to get detail task with Id={taskId}');
  }
}

//update a task
Future<Task> updateTask(http.Client client, Map<String, dynamic> params)async{
  final response=await client.put('$URL_TASKS/${params["id"]}', body: params);
  print('response22=$response');
  if(response.statusCode==200){
    var responseBody=await convert.jsonDecode(response.body);
    var mapTask=responseBody[0]['data'];
    return Task.fromJson(mapTask);
  }
  else{
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}

Future<Task> deleteTask(http.Client client,int id)async{
  final response=await client.delete('$URL_TASKS/$id');
  print('response22=$response');
  if(response.statusCode==200){
    var responseBody=await convert.jsonDecode(response.body);
    return Task.fromJson(responseBody[0]["data"]);

  }
  else{
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}


