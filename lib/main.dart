import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new BlogList(),
    );
  }
}

class BlogList extends StatefulWidget {
  @override
  createState() => new BlogListState();
}

class BlogListState extends State<BlogList> {
void readData() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "my_blogs.db");
    print(databasesPath);
// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "blogs.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    var blogs = await getBlogs();
    setState(() => this._blogs = blogs);
    print(blogs.length);
  }


  @override
  void initState() {
    super.initState();
    readData();
  }

  var _blogs = <Blog>[];

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('博客大赛'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: ()=>Void,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    if (_blogs.length == 0) {
      return null;
    }
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _blogs.length) {
          print('啊哈哈');
        }
        return _buildRow(_blogs[index]);
      },
    );
  }

  Widget _buildRow(Blog blog) {
    return new ListTile(
      title: new Text(
        blog.name,
        style: _biggerFont,
      ),
    );
  }
}
