import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


getBlogs() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    // 设置数据库的路径。注意：使用 `path` 包中的 `join` 方法是
    // 确保在多平台上路径都正确的最佳实践。
    join(await getDatabasesPath(), 'my_blogs.db'),
    // When the database is first created, create a table to store dogs.
    // 当数据库第一次被创建的时候，创建一个数据表，用以存储狗狗们的数据。
    // onCreate: (db, version) {
    //   return db.execute(
    //     "CREATE TABLE BLOG (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,CREATEDATE TEXT,CONTENT TEXT)",
    //   );
    // },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    // 设置版本。它将执行 onCreate 方法，同时提供数据库升级和降级的路径。
    version: 1,
  );

  
  Future<List<Blog>> blogs() async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;

    // Query the table for all The Dogs (查询数据表，获取所有的狗狗们)
    final List<Map<String, dynamic>> maps = await db.query('BLOG');

    // Convert the List<Map<String, dynamic> into a List<Dog> (将 List<Map<String, dynamic> 转换成 List<Dog> 数据类型)
    return List.generate(maps.length, (i) {
      return Blog(
        id: maps[i]['ID'],
        name: maps[i]['NAME'],
        createDate: maps[i]['CREATEDATE'],
        content: maps[i]['CONTENT'],
      );
    });
  }

return (await blogs());
}

class Blog {
  final int id;
  final String name;
  final String createDate;
  final String content;
  
  Blog({this.id, this.name, this.createDate,this.content});
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createDate': createDate,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'Blog{id: $id, name: $name, createDate: $createDate, content: $content}';
  }
}