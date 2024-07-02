import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:try_code/database_helper.dart';
import 'package:try_code/todo.dart';

void main() => runApp(MyApp());

// stl
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLiteでCRUDする方法',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// stf
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // DatabaseHelperをインスタンス化
  final dbHelper = DatabaseHelper();
  List<bool> _expandedList = [];

  @override
  Widget build(BuildContext context) {
    List<Todo> todos = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('SQLiteでCRUDできるアプリ'),
      ),
      // Todoリストを表示
      body: FutureBuilder<List<Todo>>(
        future: dbHelper.getTodos(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Todo>> snapshot,
        ) {
          if (snapshot.hasData) {
            todos = snapshot.data!;
            if (_expandedList.length != todos.length) {
              //todosリストの大きさが変わったときのみ実行する文
              _expandedList = List<bool>.filled(todos.length, false);
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(todos[index].title),
                      leading: Checkbox(
                        value: todos[index].done,
                        onChanged: (value) {
                          // Todoの’done’を更新
                          final todo = Todo(
                            id: todos[index].id,
                            title: todos[index].title,
                            detail: todos[index].detail,
                            done: value!,
                          );
                          dbHelper.updateCheckbox(todo); // データベースを更新
                          setState(() {
                            todos[index].done = value; // 画面を更新
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                        ),
                        // タスクリストの消去
                        onPressed: () {
                          dbHelper.deleteTodo(todos[index].id!);
                          setState(() {
                            todos.removeAt(index);
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _expandedList[index] = !_expandedList[index];
                        });
                      },
                    ),
                    if (_expandedList[index])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(todos[index].detail),
                        ),
                      ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //モーダルボトムシートを表示
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
