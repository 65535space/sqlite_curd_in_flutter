import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class DatabaseHelper {
  // データベースのバージョン
  static const int _databaseVersion = 1;
  // データベースの名前
  static const String _databaseName = 'todo.db';

  //データベースのインスタンスの取得
  Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName), //データベースのパスを指定
      version: _databaseVersion, //データベースのバージョンを指定
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY,title TEXT, detail TEXT, done INTEGER)',
        );
      },
    );
  }

  //データの挿入
  Future<void> insertTodo(Todo todo) async {
    final Database db = await _getDB();
    await db.insert(
      'todos', //テーブル名を指定
      todo.toJson(), //引数のtodoをMap型に変換して挿入
      conflictAlgorithm: ConflictAlgorithm.replace, // IDの重複時の振る舞い（この場合は上書き）
    );
  }

  //全てのデータの取得
  Future<List<Todo>> getTodos() async {
    final Database db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('todo');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        detail: maps[i]['detail'],
        done: maps[i]['done'] == 1,
      );
    });
  }

  //Checkboxの更新メソッド
  Future<void> updateCheckbox(Todo todo) async {
    //get a reference to the database
    final db = await _getDB();
    await db.update(
      'todos',
      {'done': todo.done ? 1 : 0},
      where: "id = ?",
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  //データの削除
  Future<void> deleteTodo(int id) async {
    final db = await _getDB();
    await db.delete(
      'todos',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
