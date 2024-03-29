import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models/task.dart';

class DetailTaskScreen extends StatefulWidget{
  final int id;
  DetailTaskScreen({this.id}):super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailTaskScreenState();
  }
}


class _DetailTaskScreenState extends State<DetailTaskScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Task'),
      ),
      body: FutureBuilder(
        future: fetchTaskById(http.Client(), widget.id),
          builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
          }
          else if(snapshot.hasData){
            return DetailTask(task: snapshot.data);
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          }),
    );
  }
}

class DetailTask extends StatefulWidget{
  Task task;
  DetailTask({Key key,this.task}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailTaskState();
  }


}
class _DetailTaskState extends State<DetailTask>{
  Task task=new Task();
  bool isLoadedTask=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(isLoadedTask==false){
      setState(() {
        this.task=Task.fromTask(widget.task);
        this.isLoadedTask=true;
      });
    }

    final TextField _txtTaskName=new TextField(
      decoration: InputDecoration(
        hintText: 'Enter task name',
        contentPadding: EdgeInsets.all(10.0),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      controller: TextEditingController(text: this.task.name),
      textAlign: TextAlign.left,
      onChanged: (text){
        setState(() {
          this.task.name=text;
        });
      },

    );

    final _txtFinished=Text('Finished', style: TextStyle(fontSize: 16.0),);
    final Checkbox _cbFinished=Checkbox(
        value: this.task.finished,
        onChanged: (bool value){
          this.task.finished=value;
        }
    );

    final _btnSave=RaisedButton(
      child: Text('Save'),
      color: Colors.green,
      elevation: 4.0,
      onPressed: () async{
        //update an existing task

        Map<String, dynamic> params=Map<String, dynamic>();
        params["id"]=this.task.id.toString();
        params["name"]=this.task.name;
        params["isfinished"]=this.task.finished?"1":"0";
        params["todoid"]=this.task.todoId.toString();

        await updateTask(http.Client(), params);
        Navigator.pop(context);


      },
    );

    final _btnDelete=RaisedButton(
      child: Text('Delete'),
      color: Colors.redAccent,
      onPressed: () async{
        //Delete a task

        showDialog(
            context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
              return AlertDialog(
                title: Text('Confirmation'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Are you sure you want to delete this ?')
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: Text('Yes'),
                      onPressed: () async{
                        await deleteTask(http.Client(), this.task.id);
                        await Navigator.pop(context); //quit dialog
                        Navigator.pop(context); //quit a prev screen
                      }),
                  new FlatButton(
                      child: Text('No'),
                      onPressed: () async{
                        Navigator.pop(context); //quit a prev screen
                      })
                ],

              );
          }

        );


      },
    );


    final _column=Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _txtTaskName,
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _txtFinished,
              _cbFinished
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(child: _btnSave,),
            Expanded(child: _btnDelete,)
          ],
        )
      ],

    );


    return Container(
      margin: EdgeInsets.all(10.0),
      child: _column,
    );
  }
}