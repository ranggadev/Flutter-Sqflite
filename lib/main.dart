import 'package:flutter/material.dart';
import 'helpers/DatabaseHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Try Sqflite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List myData = [];

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Try Sqflite"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('insert', style: TextStyle(fontSize: 20),),
            onPressed: () {_insert();},
          ),
          RaisedButton(
            child: Text('query', style: TextStyle(fontSize: 20),),
            onPressed: () {_query();},
          ),
          RaisedButton(
            child: Text('update', style: TextStyle(fontSize: 20),),
            onPressed: () {_update();},
          ),
          RaisedButton(
            child: Text('delete', style: TextStyle(fontSize: 20),),
            onPressed: () {_delete();},
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myData.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        myData[index][DatabaseHelper.columnId].toString() + " " +
                        myData[index][DatabaseHelper.columnName].toString() + " " +
                        myData[index][DatabaseHelper.columnAge].toString()
                    ),
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : 'Rangga Saputra',
      DatabaseHelper.columnAge  : 21
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    //allRows.forEach((row) => print(row));

    setState(() {
      myData.clear();
      allRows.forEach((row) => myData.add(row));
    });
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId   : 1,
      DatabaseHelper.columnName : 'Mary',
      DatabaseHelper.columnAge  : 32
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}