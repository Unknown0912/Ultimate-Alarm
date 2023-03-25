import 'package:alarm/alarm.dart';
import 'package:alarm/homepage.dart';
import 'package:sqflite/sqflite.dart';
class sqflite{
  late Future<Database> data_base;
  sqflite(){
    data_base=db();
    print("database intialized");
  }
  Future <Database> db()async{
    return openDatabase(
      'alarm.db',
      version: 1,
      onCreate: (Database database, int version)async {
        await createtables(database);
      },
    );
  }
  Future <void> createtables(Database database)async{
      await database.execute("""CREATE TABLE alarm(
        id INTEGER,
        hours INTEGER,
        min INTEGER,
        title VARCHAR(20) PRIMARY KEY 
      )""");
  }
  void insert(alarm a)async{
    var d_b= await this.data_base;
    var f=d_b.insert("alarm",a.toJson());
  }
  Future<List<alarm>> getalarms() async{
    List<alarm>_alarms=[];
    var d_b= await this.data_base;
    var res=await d_b.query("alarm");
    res.forEach((element) {
      var alarminfo = alarm.fromJson(element);
      _alarms.add(alarminfo);
    });
    return _alarms;
  }
  void delete(String a)async{
    var d_b= await this.data_base;
    await d_b.delete("alarm",where :"title = ?",whereArgs:[a]);
  }
}