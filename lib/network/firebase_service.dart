import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    final channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
);

    registerOnFirebase() {
      _firebaseMessaging.subscribeToTopic('all');
      _firebaseMessaging.getToken().then((token) => print('haha: $token'));
    }

      void getMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      if(notification != null && android != null) {
        print(notification.title);
        print(notification.body);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            )
          )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
      print('OnMessageOpenedApp');
    });
  }
}