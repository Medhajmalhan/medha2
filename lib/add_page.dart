

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({
    super.key,
  this.todo,
  });
  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if(todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
titleController.text = title;
descriptionController.text = description;
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isEdit? updateData : addTodo,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    isEdit? 'Update' : 'Add ToDo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call update without todo data');
      return;
    }
    final id = todo['_id'];
    final url = 'https://api.nstack.in/v1/todos/659bd08a5d2db94280a842f0';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Successful creation, you might want to navigate back to the ToDoListPage
      Navigator.pop(context);
    } else {
      // Handle error
      print('Updation Failed. Status code: ${response.statusCode}');
    }

  }

  Future<void> addTodo() async {
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Successful creation, you might want to navigate back to the ToDoListPage
      Navigator.pop(context);
    } else {
      // Handle error
      print('Failed to add ToDo. Status code: ${response.statusCode}');
    }
  }



}
