// Todoテーブルを定義
class Todo {
  int? id;
  String title;
  String detail;
  bool done;

  Todo({
    this.id,
    required this.title,
    required this.detail,
    this.done = false,
  });

  //Todo型からMap型に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
      'done': done ? 1 : 0, // boolをintに変換
    };
  }

  // データベースから読み込む際に、intをboolに変換
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      detail: map['detail'],
      done: map['done'] == 1, // "=="でintをboolに変換
    );
  }
}
