import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'homepage.dart';

void main() {
  AwesomeNotifications().initialize(
  null,
  [
    NotificationChannel(
        channelKey: 'alarm_channel',
        channelName: 'alarm',
        channelDescription: 'alarm app',
        importance: NotificationImportance.Max,
        soundSource: 'resource://raw/check',
        playSound: true        
        )
  ],
  debug: true
);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((value){
      if(!value){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}

