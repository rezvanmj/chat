import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../domain/chat_room/chat_room_model.dart';
import 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late IO.Socket chatSocket;
  int notificationCounter = 0;
  HomeBloc(HomeState init) : super(HomeState.init());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    List<ChatRoomModel> tempChatRooms = [];
    final prefs = await SharedPreferences.getInstance();
    chatSocket = io(
        // 'https://test111web.ca/chat',
        'https://test111web.ca/chat',
        OptionBuilder().disableAutoConnect().setAuth({
          'isPanel': true,
          'token': prefs.get('token')
        }).setTransports(['websocket']).build());

    try {
      chatSocket.on('room:update', (data) {
        tempChatRooms.clear();
        notificationCounter = 0;
        _getChatRooms(tempChatRooms, notificationCounter);
      });

      chatSocket.on('room:remove', (data) {
        ChatRoomModel removedRoom = ChatRoomModel.fromJson(data);
        tempChatRooms.removeWhere((element) => element.id == removedRoom.id);
        emit(state.copyWith(chatRooms: tempChatRooms));
      });
      chatSocket.emit('admin:join');
      chatSocket.on('admin:newUser', (_) {
        notificationCounter++;
        FlutterAppIconBadge.updateBadge(notificationCounter);
        emit(state.copyWith(isLoading: true));
        _notifyNewGroupChat();
        _getChatRooms(tempChatRooms, notificationCounter);
      });
    } on Exception catch (err, s) {
      SnackBar(content: Text('error : ${err.toString()}'));
      yield state.copyWith(isLoading: false);
    } catch (err) {
      SnackBar(content: Text('error : ${err.toString()}'));
      yield state.copyWith(isLoading: false);
    }

    if (event is DisConnectSocket) {
      chatSocket.disconnect();
    }
    if (event is GetChatRoomsEvent) {
      try {
        tempChatRooms.clear();
        yield state.copyWith(isLoading: true);

        _onSocketConnect(tempChatRooms);
        _getChatRooms(tempChatRooms, notificationCounter);
      } on Exception catch (err, s) {
        SnackBar(content: Text('error : ${err.toString()}'));
        yield state.copyWith(isLoading: false);
      } catch (err) {
        SnackBar(content: Text('error : ${err.toString()}'));
        yield state.copyWith(isLoading: false);
      }
    }
  }

  void _notifyNewGroupChat() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        actionType: ActionType.Default,
        wakeUpScreen: true,
        id: 123,
        criticalAlert: true,
        channelKey: 'basic_channel',
        title: 'notification',
        body: 'new user joined chatRoom',
        payload: {"name": "FlutterCampus"},
      ),
    );
  }

  void _onSocketConnect(List<ChatRoomModel> tempChatRooms) {
    chatSocket.connect();
    chatSocket.onConnect((_) async {
      print('Chat Rooms connected  :> ');
    });

    chatSocket.emit('admin:join');
    chatSocket.on('admin:newUser', (_) {});

    chatSocket
        .onDisconnect((_) => print('Connection Disconnected CHAT ROOM:<'));
    chatSocket.onConnectError((err) => print(err));
    chatSocket.onError((err) => print(err));
  }

  void _socketConfig() {
    chatSocket.connect();
    chatSocket.onDisconnect((_) => print('Connection Disconnected CHAT:<'));
    chatSocket.onConnectError((err) => print(err));
    chatSocket.onError((err) => print(err));
  }

  void _getChatRooms(
      List<ChatRoomModel> tempChatRooms, int notificationCounter) {
    notificationCounter = 0;
    chatSocket.emit('rooms:fetch');
    chatSocket.on('rooms:response', (chatRooms) {
      tempChatRooms.clear();
      List<dynamic> dynamicList = [];
      dynamicList.addAll(chatRooms);
      log('chatRooms GET ${dynamicList.length}');
      dynamicList.forEach((e) {
        tempChatRooms.add(ChatRoomModel.fromJson(e));
      });
      tempChatRooms.forEach((element) {
        if (element.unreadMessagesCount != 0) {
          notificationCounter++;
        }
      });
      if (notificationCounter == 0) {
        FlutterAppIconBadge.removeBadge();
      } else {
        FlutterAppIconBadge.updateBadge(notificationCounter);
      }
      emit(state.copyWith(isLoading: false, chatRooms: tempChatRooms));
    });
  }

// @override
// Future<void> close() {
//   chatSocket.dispose();
//   chatSocket.disconnect();
//   return super.close();
// }
}
