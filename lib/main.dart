import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'todo.dart';

void main() => runApp(const MyApp());

// stl
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLiteでCRUDする方法',
      theme: ThemeData(
        fontFamily: 'NotoSansJP',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Todo> todos = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: const Icon(Icons.add),
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      //Column のchildrenで埋まった領域に対する残りの領域を縦方向に最小化するプロパティ
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallText(
                          text: 'title',
                          fontWeight: FontWeight.bold,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your text',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SmallText(
                          text: 'detail',
                          fontWeight: FontWeight.bold,
                        ),
                        TextField(
                          controller: _detailController,
                          maxLines: 5, // 最大行数を指定
                          decoration: const InputDecoration(
                            labelText: 'Enter your message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () async {
                              final todo = Todo(
                                title: _titleController
                                    .text, // .textプロパティでTextEditingControllerの値を取得
                                detail: _detailController.text,
                                done: false,
                              );
                              await dbHelper.insertTodo(todo);
                              setState(() {
                                Navigator.pop(context); //
                              });
                            },
                            child: const Text('保存'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// コンポーネント(部品)
class SmallText extends StatelessWidget {
  const SmallText({
    super.key,
    required this.text,
    required this.fontWeight,
  });

  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    double checkboxSize = 18.0;
    return Padding(
      padding: EdgeInsets.only(left: checkboxSize + 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
