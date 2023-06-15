import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void main() {


  runApp(MaterialApp(
    home: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.contacts),),
              Tab(icon: Icon(Icons.camera_alt),),
              Tab(icon: Icon(Icons.view_column_outlined),)
            ],
          ),
        ),
        body:
        TabBarView(
          children: [
            register(),
            secondScreen(),
            view()
          ],
        ),
      ),
    ),
  ));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_database();
  }
  Future<Database> get_database() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table

          await db.execute(
              'CREATE TABLE user1(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT,birth TEXT,pass TEXT)');
        });
    return database;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User Intergeration")),
        body: register()

    );
  }
}

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register>  with SingleTickerProviderStateMixin{
   late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }
  @override

  Future<Database> get_database() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table

          await db.execute(
              'CREATE TABLE user1(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT,birth TEXT,pass TEXT)');
        });
    return database;
  }

  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController birth = TextEditingController();
    TextEditingController pass = TextEditingController();
    TextEditingController conpass = TextEditingController();


    return ListView(shrinkWrap: true,
      children: [
        Container(
          width: 200,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              TextField(controller: name,
                  decoration: InputDecoration(hintText: "Enter Your Name")),
              TextField(controller: email,
                  decoration: InputDecoration(hintText: "Enter Your Email")),
              TextField(controller: birth,
                  decoration: InputDecoration(hintText: "Date of Birth")),
              TextField(controller: pass,
                  decoration: InputDecoration(hintText: "Enter Password")),
              TextField(controller: conpass,
                  decoration:
                  InputDecoration(hintText: "Enter conform password")),
              InkWell(onTap: () {
                String n = name.text;
                String e = email.text;
                String d = birth.text;
                String p = pass.text;

                get_database().then((value) async {
                  String qry = "insert into user1 values(null,'$n','$e','$d','$p')";
                  value.rawInsert(qry);
                });
                  // _tabController.animateTo((_tabController.index + 1) );

                setState(() {});
              },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("Register"),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class secondScreen extends StatefulWidget {
  @override
  State<secondScreen> createState() => _secondScreenState();
}

class _secondScreenState extends State<secondScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('',
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }
}

class view extends StatefulWidget {
  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  List l = [];
  bool t = false;
  @override
  Future<Database> get_database() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table

          await db.execute(
              'CREATE TABLE user1(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT,birth TEXT,pass TEXT)');
        });
    return database;
  }

  Widget build(BuildContext context) {
 setState(() {
   get_database().then((value) async {
     String sql="select * from user1";
     value.rawQuery(sql).then((value){
       l = value;
       print(l);
     });
   });
 });

    return (true)?Container(
      child: ListView.builder(itemCount: l.length,itemBuilder: (context, index) {
        return Container(padding:EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(flex: 5,
                child: Container(padding: EdgeInsets.all(10),margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  height: 100,
                  width: 200,
                  child: Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("name :  ${l[index]['name']}"),
                      Text("email : ${l[index]['email']}"),
                      Text("DOB :   ${l[index]['birth']}"),
                      Text("Password   ${l[index]['pass']}:"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                  height: 100,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.edit),
                      InkWell(onTap: () {
                        get_database().then((value) async {
                          String qry3 ="delete from user where id='${index}'";
                          value.delete(qry3).then((value){
                          });
                        });
                        setState(() {
                        });
                      },child: Icon(Icons.delete)),
                    ],
                  ),

                ),
              )
            ],
          ),
        );
      },),
    ):Center(child: CircularProgressIndicator(),);
  }
}
