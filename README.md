# sqlite_curd
実行方法

1. flutter pub get

2. flutter run

# 今回のTodoアプリを作る際に生じたQ&A

# todo.dart

Q. idをnullable型にする理由
A. Todoアプリを作るにあたって、idを指定するシステムが必要なかったから。
SQLiteではINTEGER PRIMARY KEYを指定することで、レコードが挿入される際に一意のidが自動的に生成される

Q. SQL文を大文字にしてるけどなぜ?別に小文字でも可能じゃん
A.　可読性と一貫性を向上させるため
クエリと、内容を明確に区別する

Q. なぜ、boolからintに変換してデータベースに値を渡しているのか
A. SQLiteにはBoolで保存する型がないから

Q. FutureBuilderとは
A. FutureBuilder は非同期処理が完了するまで待ち、その後に特定のウィジェットを構築する。snapshot プロパティを介して非同期操作の結果にアクセスする

Q. todos = snapshot.data!;のtodosに入るものは何?
A.snapshot.dataは、非同期操作が成功した場合に、その結果のデータを含むプロパティです。ここでは、Future<List<Todo>>が完了した後の結果であるList<Todo>が入ります。

Q. todos[index].idに!をつける理由
A. nullでないことを保証するため。
idの値はデータベースにより自動生成されるので、int? id;とした。よてnullable型を使っているので、!をつけることで、nullではないということを示さなければならない。

Q. 
return Padding(
    padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom,
),),
では何をしているのか

A.　スマホのキーボードが出現したときに、入力フォームが隠れないようにするため。 EdgeInsets.onlyは、特定の方向にのみパディングを設定し、MediaQueryは、デバイスの画面サイズや表示状態などの情報を取得するために使用される。
MediaQuery.of(context)は、現在のビルドコンテキストに基づいてメディア情報を取得する。
viewInsetsは、ソフトキーボードやシステムUIオーバーレイなど、表示されているインセット（余白）を表す。
viewInsets.bottomは、画面下部のインセットの値を取得します。これにより、ソフトキーボードが表示されているときの画面下部のインセット量をパディングとして使用できる。