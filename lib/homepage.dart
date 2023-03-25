import 'package:alarm/alarm.dart';
import 'package:alarm/db.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:alarm/card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var ref;
var id=0;
var finished=false;
card c=card(); 
Future<List<alarm>>? _alarms;
List<alarm>? _currentAlarms;
class _HomePageState extends State<HomePage> {
  @override
  void initState() {           
    sqflite s=sqflite();
    ref=s;
    _alarms=s.getalarms();
    super.initState();
  }
  DateTime selectedTime =DateTime.now();
  _selecttime(context)async{
    TextEditingController _title=TextEditingController();
    var selecttitle=await showDialog(context: context,builder:(BuildContext context){
      return AlertDialog(content: TextField(controller: _title,decoration: InputDecoration(hintText:"Alarm-Title"),),actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("save"))],);
    });
    var selecttime=await DatePicker.showDateTimePicker(context,showTitleActions: true,onChanged: (time) => selectedTime=time);
      if(selecttime != null)
        {
          setState(() {
            selectedTime = selecttime;
            if(id>2){
              id=0;
            }
            ref.insert(alarm(id:id,hours:selectedTime.hour, min:selectedTime.minute,title:_title.text));
            id++;
            finished=true;
          });
          return selecttime;
        }
  }
  triggernotification(var a){
    AwesomeNotifications().createNotification(content: NotificationContent(
      id:10,
      channelKey: 'alarm_channel',
      title: 'Alarm Notification',
      body: 'Sim',
      criticalAlert: true,
    ),
    schedule: NotificationCalendar.fromDate(date:a),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Alarm"),backgroundColor: Color.fromRGBO(58, 107, 53, 1)),
        body:Column(
            children: [              
              Expanded(
                child: FutureBuilder(future: _alarms,builder: (context,snapshot){
                  if(snapshot.hasData){
                     _currentAlarms =snapshot.data;
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.map<Widget>((alarm){
                        return Container(
                          height: 120,
                          color: c.l[alarm.id??0],
                          width: 50,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Text("Time : ${alarm.hours}:${alarm.min}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10),
                              Text("Title : ${alarm.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton.extended(onPressed: (){
                                    ref.delete(alarm.title);
                                    setState(() {
                                      _alarms=ref.getalarms();
                                  });}, label: Text("Delete"),icon: Icon(Icons.delete),)
                                ],
                              )
                            ],
                          ),

                        );
                    }).toList()
                  );}
                  else{
                    return Center(child: Text("No Alarms"));
                  }
                }
                ),
              ),
            ],
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: ()async{
          var a =await _selecttime(context);
          setState((){
            if(finished){
            _alarms=ref.getalarms();
            }
          },
          );
          triggernotification(a);
        }, label: Text("next"),icon: Icon(Icons.alarm_add),),
      ),
    );
  }
}