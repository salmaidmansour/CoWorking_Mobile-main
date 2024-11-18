import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String TODO = "TODO";
  static const String IN_PROGRESS = "IN PROGRESS";
  static const String COMPLETED = "COMPLETED";
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: TODO,
              ),
              Tab(
                text: IN_PROGRESS,
              ),
              Tab(
                text: COMPLETED,
              ),
            ],
          ),
          title: const Text(
            'Tasks Management',
          ),
        ),
        body: TabBarView(
          children: [
            getWidgetWithStatus(TODO),
            getWidgetWithStatus(IN_PROGRESS),
            getWidgetWithStatus(COMPLETED),
          ],
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  String? _getStatusToDoItem(String id) {
    return todosList.where((item) => item.id == id).single.status;
  }

  void _changeToDoItemStatus(String id) {
    _dialogBuilder(context, id);
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
  }

  Widget widgetAddTodoItem() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              right: 20,
              left: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                  hintText: 'Add a new todo item', border: InputBorder.none),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
            right: 20,
          ),
          child: ElevatedButton(
            onPressed: () {
              if(_todoController.text.isNotEmpty) {
                _addToDoItem(_todoController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tdBlue,
              minimumSize: const Size(60, 60),
              elevation: 10,
            ),
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget getWidgetWithStatus(String status) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  '',
                ),
              ),
              for (ToDo todoo in _foundToDo
                  .where((todo) => todo.status == status)
                  .toList()
                  .reversed)
                ToDoItem(
                  todo: todoo,
                  onToDoChanged: _handleToDoChange,
                  onDeleteItem: _deleteToDoItem,
                  onLongPressItem: _changeToDoItemStatus,
                ),
            ],
          ),
        ),
        widgetAddTodoItem()
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String idItem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'YOU WANT TO CHANGE THIS TASK TO ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: _getStatusToDoItem(idItem) == TODO
                  ? null
                  : () {
                      setState(() {
                        todosList
                            .where((item) => item.id == idItem)
                            .single
                            .status = TODO;
                      });
                      Navigator.of(context).pop();
                    },
              child: const Text(TODO),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: _getStatusToDoItem(idItem) == IN_PROGRESS
                  ? null
                  : () {
                      setState(() {
                        todosList
                            .where((item) => item.id == idItem)
                            .single
                            .status = IN_PROGRESS;
                      });
                      Navigator.of(context).pop();
                    },
              child: const Text(IN_PROGRESS),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: _getStatusToDoItem(idItem) == COMPLETED
                  ? null
                  : () {
                      setState(() {
                        todosList
                            .where((item) => item.id == idItem)
                            .single
                            .status = COMPLETED;
                      });
                      Navigator.of(context).pop();
                    },
              child: const Text(COMPLETED),
            ),
          ],
        );
      },
    );
  }
}
