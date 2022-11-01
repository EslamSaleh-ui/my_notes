// ignore_for_file: file_names, missing_return
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DB{
  static final DB D=DB.internal();
  static DB internal(){}
  static Database _db;
  Future<Database> create() async{
    if(_db != null) {
      return _db;
    }
    String path= join(await getDatabasesPath(),'notify.db');
    _db=await openDatabase(path,version: 1,onCreate: (Database b,int v)
    {
      b.execute('create table notes(id INTEGER primary key AUTOINCREMENT,title varchar(35),note varchar(500),font varchar(30),date varchar(100),color INTEGER,archived varchar(10))');
    } );
    return _db;
  }
  Future<void> insertDB(Note a) async{
    Database v=await create();
  int b=await  v.insert('notes', a.toMap());
  print(b);
  }
  Future<List> query() async{
    Database v=await create();
    return v.rawQuery("SELECT * FROM notes ");
  }
  Future<List> querys(String d) async{
    Database v=await create();
    var bb=  v.rawQuery("SELECT * FROM notes WHERE title LIKE '%"+d+"%'");
    if (bb !=null) {
      return bb;
    } else {
      return null;
    }
  }
  Future<int> delete(int id) async{
    Database v=await create();
    return v.delete('notes',where: 'id=?',whereArgs: [id]);
  }

  Future<int> updates(Note s) async{
    Database v=await create();
    var c= v.update('notes',s.toMap(),where: 'id=?',whereArgs: [s.id]);
    return c;
  }
}

class Note
{
  int id;
  String  title ,note,font,date,archived;
  int color;

  Note(dynamic obj)
  {id=obj['id'];
  title=obj['title'];
  note=obj['note'];
  font=obj['font'];
  date=obj['date'];
  color=obj['color'];
  archived=obj['archived'];
  }
  Note.fromMap(Map<String,dynamic> data)
  {id=data['id'];
  title=data['title'];
  note=data['note'];
  font=data['font'];
  date=data['date'];
  color=data['color'];
  archived=data['archived'];
  }
  Map<String,dynamic> toMap()=>{'id':id,'title':title,'note':note,'font':font,'date':date,'color':color,'archived':archived };
}