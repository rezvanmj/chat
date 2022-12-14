import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_project/domain/chat_room/file_path_model.dart';
import 'package:chat_project/domain/chat_room/send_file_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart' as prs;
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat_room/chat_messages_model.dart';
import '../../domain/chat_room/chat_room_model.dart';
import '../../domain/core/enums.dart';
import '../../main.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final SendFileRepository _sendFileRepository;
  late IO.Socket chatSocket;
  Timer? _debounce;
  var uuid = const Uuid();
  List<ChatMessages> tempChats = [];
  ChatMessages? newMessage;
  ChatRoomModel? updatedChatRoom;
  int tempRoomId = 0;
  List<ChatMessages> reversedList = [];
  bool tempIsTyping = false;
  List<String> creationIds = [];
  ChatRoomBloc(ChatRoomState init, this._sendFileRepository)
      : super(ChatRoomState.init());

  @override
  Stream<ChatRoomState> mapEventToState(ChatRoomEvent event) async* {
    final prefs = await SharedPreferences.getInstance();
    chatSocket = io(
        // 'https://test111web.ca/chat',
        'https://api.hillzusers.com/chat',
        OptionBuilder().disableAutoConnect().enableForceNew().setAuth({
          'isPanel': true,
          'token': prefs.get('token')
        }).setTransports(['websocket']).build());

    try {
      // if (creationIds.isNotEmpty) {
      //   chatSocket.emit('messages:seen', creationIds);
      // }

      chatSocket.on('message:get', (data) {
        _getMessage(data, event);
      });

      chatSocket.on('messages:update', (data) {
        _updateMessage(data, event);
      });

      chatSocket.on("isTyping", (data) {
        _isTyping(data, event);
      });
    } catch (err) {
      SnackBar(content: Text('error : ${err.toString()}'));
      yield state.copyWith(isLoading: false);
    } on Exception catch (err, s) {
      SnackBar(content: Text('error : ${err.toString()}'));
      yield state.copyWith(isLoading: false);
    }

    if (event is DisConnectSocket) {
      chatSocket.disconnect();
    }

    if (event is UploadFileEvent) {
      try {
        yield state.copyWith(isSending: true);
        String randomId = uuid.v4();
        FilePathModel uploadedFile =
            await _sendFileRepository.sendFile(event.uploadedFile);
        String message = state.chatTextController!.text;
        File? file = event.uploadedFile['chatFile'];
        Size size = _getFileSize(file);
        prs.MediaType fileType = _getFileType(file);
        _socketConfig();

        if (fileType.type == 'image') {
          _sengImageFile(event, message, randomId, uploadedFile, size);
          _addChat('image', uploadedFile.filePath, uploadedFile.fileName);
        } else {
          _sendOtherFiles(event, message, randomId, uploadedFile);
          _addChat('file', uploadedFile.filePath, uploadedFile.fileName);
        }
        yield state.copyWith(isSending: false);
      } on Exception catch (e, s) {
        yield state.copyWith(
            isSending: false, uploadFileRep: ApiResponse(response: Failure(e)));
      } catch (e, s) {
        yield state.copyWith(
            isSending: false, uploadFileRep: ApiResponse(response: Failure(e)));
      }
    }

    if (event is IsAdminTypingEvent) {
      try {
        List<dynamic> dynamicList = [event.chatRoom.name, event.isAdminTyping];
        chatSocket.onConnect((data) {
          chatSocket.emit('admin:isTyping', dynamicList);
        });
      } catch (err) {
        SnackBar(content: Text('error : ${err.toString()}'));
      } on Exception catch (err, s) {
        SnackBar(content: Text('error : ${err.toString()}'));
      }
    }

    if (event is SeenMessages) {
      if (creationIds.isNotEmpty) {
        _socketConfig();
        _seenMessages();
      }
    }

    if (event is SendMessageEvent) {
      try {
        String randomId = uuid.v4();
        yield state.copyWith(isLoading: true);
        _socketConfig();
        _sendMessage(event, randomId);
        _addChat('text', '', '');

        yield state.copyWith(isLoading: false, chats: reversedList);
      } catch (err) {
        SnackBar(content: Text('error : ${err.toString()}'));

        yield state.copyWith(isSending: false, isLoading: false);
      } on Exception catch (err, s) {
        SnackBar(content: Text('error : ${err.toString()}'));

        yield state.copyWith(isSending: false, isLoading: false);
      }
    }

    if (event is GetMessagesEvent) {
      try {
        yield state.copyWith(isLoading: true);
        _socketConfig();
        _getMessages(event, tempChats);
      } catch (err) {
        yield state.copyWith(isLoading: false);
        SnackBar(content: Text('error : ${err.toString()}'));
      }
    }
  }

  void _seenMessages() {
    chatSocket.emit('messages:seen', creationIds);
  }

  void _sendOtherFiles(UploadFileEvent event, String message, String randomId,
      FilePathModel uploadedFile) {
    Map<String, dynamic> fileMap = {
      'to': event.chatRoomId,
      'message': message,
      'creation_id': randomId,
      'file': {'name': uploadedFile.fileName, 'path': uploadedFile.filePath},
      'messageType': 'doc'
    };
    chatSocket.emit('message:newAdminMessage', fileMap);
  }

  void _sengImageFile(UploadFileEvent event, String message, String randomId,
      FilePathModel uploadedFile, Size size) {
    Map<String, dynamic> fileMap = {
      'to': event.chatRoomId,
      'message': message,
      'creation_id': randomId,
      'file': {'name': uploadedFile.fileName, 'path': uploadedFile.filePath},
      'mediaWidth': size.width,
      'mediaHeight': size.height,
      'messageType': 'image'
    };
    chatSocket.emit('message:newAdminMessage', fileMap);
  }

  prs.MediaType _getFileType(File? file) {
    final fileType = prs.MediaType("image", file!.path.split(".").last);
    return fileType;
  }

  Size _getFileSize(File? file) {
    final size = ImageSizeGetter.getSize(FileInput(file!));
    return size;
  }

  void _isTyping(data, ChatRoomEvent event) {
    List<dynamic> dynamicList = data;
    tempRoomId = dynamicList[0];
    tempIsTyping = dynamicList[1];
    if (tempRoomId == event.chatRoomId) {
      tempIsTyping = dynamicList[1];
      emit(state.copyWith(isTyping: tempIsTyping));
    }
  }

  void _updateMessage(data, ChatRoomEvent event) {
    print('message UPDATE');
    List<ChatMessages> updatedChats = [];
    List<dynamic> dynamicList = data;
    dynamicList.forEach((e) {
      ChatMessages updatedChat = ChatMessages.fromJson(e);
      updatedChats.add(updatedChat);
      if (reversedList.indexWhere((element) => element.id == updatedChat.id) !=
          -1) {
        reversedList[reversedList.indexWhere(
            (element) => element.id == updatedChat.id)] = updatedChat;
      }
    });
    emit(state.copyWith(isLoading: false, chats: reversedList));
  }

  void _getMessage(data, ChatRoomEvent event) {
    print('message get');
    newMessage = ChatMessages.fromJson(data);
    if (newMessage != null) {
      if (newMessage!.roomId == event.chatRoomId) {
        if (!newMessage!.isSelf! && !reversedList.contains(newMessage)) {
          if (reversedList.isNotEmpty) {
            if (reversedList.last.id != newMessage!.id) {
              reversedList.add(newMessage!);
              emit(state.copyWith(chats: reversedList));
              chatSocket.emit('message:seen', newMessage!.creationId);
            }
          }
        }
      }
    }
  }

  void _addChat(String messageType, String src, String fileName) {
    ChatMessages newChat = ChatMessages(
      isSelf: true,
      src: src,
      createdAt: DateTime.now().toString(),
      status: 'sent',
      messageType: messageType,
      originalFileName: fileName,
      message: state.chatTextController!.text,
      id: 0,
    );
    state.chatTextController!.clear();
    reversedList.add(newChat);
  }

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      chatSocket.emit('admin:isTyping', () {});
    });
  }

  void _socketConfig() {
    chatSocket.connect();
    chatSocket.onConnect((_) {});
    chatSocket.onDisconnect((_) {
      // _disconnectDialog();
      print('Connection Disconnected CHAT:<');
    });
    chatSocket.onConnectError((err) {
      print(err);
    });

    chatSocket.onError((err) {
      // _disconnectDialog();
      print(err);
    });
  }

  void _disconnectDialog() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  const Text('connection failed! '),
                  OutlinedButton(
                      onPressed: () async {
                        chatSocket.disconnect();

                        final prefs = await SharedPreferences.getInstance();
                        chatSocket = io(
                            // 'https://test111web.ca/chat',
                            'https://api.hillzusers.com/chat',
                            OptionBuilder().disableAutoConnect().setAuth({
                              'isPanel': true,
                              'token': prefs.get('token')
                            }).setTransports(['websocket']).build());
                        chatSocket.connect();
                        chatSocket.onConnect((data) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('try again'))
                ],
              ),
            ),
          );
        });
  }

  void _sendMessage(SendMessageEvent event, String randomId) {
    String message = state.chatTextController!.text;
    if (message.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "to": event.chatRoomId,
        "message": message,
        "creation_id": randomId,
        "messageType": 'text',
      };
      chatSocket.emit('message:newAdminMessage', messageMap);
    }
  }

  void _updateMessages(SendMessageEvent event, ChatRoomModel currentChatRoom) {
    chatSocket.emit('messages:fetch', event.chatRoomId);
    chatSocket.on('messages:response', (messages) {
      List<dynamic> dynamicList = [];
      dynamicList.addAll(messages);
      log('messages  ${dynamicList.length}');
      dynamicList.forEach((e) {});
    });
  }

  void _getMessages(GetMessagesEvent event, List<ChatMessages> tempChats) {
    try {
      print('Chat connected :>');
      print('CHAT ID ${event.chatRoomId}');
      chatSocket.emit('messages:fetch', event.chatRoomId);
      chatSocket.on('messages:response', (messages) {
        List<dynamic> dynamicList = [];
        tempChats.clear();
        dynamicList.addAll(messages);
        log('messages  ${dynamicList.length}');
        dynamicList.forEach((e) {
          tempChats.add(ChatMessages.fromJson(e));
        });
        reversedList = tempChats.reversed.toList();
        emit(state.copyWith(isLoading: false, chats: reversedList));
        tempChats.forEach((element) {
          if (!element.isSelf!) {
            creationIds.add(element.creationId ?? '');
          }
        });
        if (creationIds.isNotEmpty) {
          _socketConfig();
          chatSocket.emit('messages:seen', creationIds);
        }
      });
    } catch (err) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // @override
  // Future<void> close() {
  //   chatSocket.dispose();
  //   chatSocket.disconnect();
  //   return super.close();
  // }
}
