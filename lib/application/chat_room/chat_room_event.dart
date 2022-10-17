part of 'chat_room_bloc.dart';

@immutable
abstract class ChatRoomEvent {
  int chatRoomId;
  ChatRoomEvent(this.chatRoomId);
}

class GetMessagesEvent extends ChatRoomEvent {
  int chatRoomId;
  GetMessagesEvent(this.chatRoomId) : super(0);
}

class SendMessageEvent extends ChatRoomEvent {
  int chatRoomId;
  SendMessageEvent({required this.chatRoomId}) : super(0);
}

class IsUserTypingEvent extends ChatRoomEvent {
  int chatRoomId;
  IsUserTypingEvent({required this.chatRoomId}) : super(0);
}

class UpdateMessageEvent extends ChatRoomEvent {
  int chatRoomId;
  UpdateMessageEvent({required this.chatRoomId}) : super(0);
}

class ReceiveMessageEvent extends ChatRoomEvent {
  int chatRoomId;
  ReceiveMessageEvent({required this.chatRoomId}) : super(0);
}

class IsAdminTypingEvent extends ChatRoomEvent {
  ChatRoomModel chatRoom;
  bool isAdminTyping;
  IsAdminTypingEvent({required this.chatRoom, required this.isAdminTyping})
      : super(0);
}

class DisConnectSocket extends ChatRoomEvent {
  DisConnectSocket(super.chatRoomId);
}

class UploadFileEvent extends ChatRoomEvent {
  Map<String, File?> uploadedFile;
  UploadFileEvent(super.chatRoomId, this.uploadedFile);
}
