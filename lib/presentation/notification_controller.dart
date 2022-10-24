import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  bool? _initialized;
  NotificationController() {
    ReceivePort port = ReceivePort();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      'background_notification_action',
    );

    port.listen((var received) async {
      print('background NOTIIIIIIIIIIIIIIIIIIIIIIIIIIIF');
      onSilentActionHandle(received);
    });
    _initialized = true;
  }

  @pragma("vm:entry-point")
  Future<void> onSilentActionHandle(ReceivedAction received) async {
    if (!_initialized!) {
      SendPort? uiSendPort =
          IsolateNameServer.lookupPortByName('background_notification_action');
      if (uiSendPort != null) {
        uiSendPort.send(received);
        return;
      }
    }
    await _handleBackgroundAction(received);
  }

  static Future<void> _handleBackgroundAction(ReceivedAction received) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        actionType: ActionType.Default,
        wakeUpScreen: true,
        id: 123,
        criticalAlert: true,
        channelKey: 'basic_channel',
        title: 'Hillz chat',
        body: 'new message from user',
        payload: {"name": "FlutterCampus"},
      ),
    );
    AndroidForegroundService.startAndroidForegroundService(
        content: NotificationContent(
            id: 2341234,
            body: 'Service is running!',
            wakeUpScreen: true,
            criticalAlert: true,
            title: 'Hillz chat',
            channelKey: 'basic_channel',
            notificationLayout: NotificationLayout.Messaging,
            category: NotificationCategory.Service),
        actionButtons: [
          NotificationActionButton(
              key: 'SHOW_SERVICE_DETAILS', label: 'Show details')
        ]);
    // Your background action handle
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        padding: EdgeInsets.all(10),
        backgroundColor: Colors.orange,
        content: Text(
          'new User joined chatroom',
          style: TextStyle(color: Colors.black),
        )));
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
    BuildContext context,
  ) async {
    // Your code goes here
    // Navigator.of(context).pushNamedAndRemoveUntil(homePage, (route) => false);

    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //     (route) =>
    //         (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}
