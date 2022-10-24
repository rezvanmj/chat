part of 'chat_room_bloc.dart';

class ChatRoomState {
  final bool? isLoading;
  final bool? isSending;
  final bool? isTyping;

  final Map<String, File>? file;
  final ApiResponse? uploadFileRep;
  final List<ChatMessages>? chats;
  final TextEditingController? chatTextController;
  ScrollController chatScrollController = ScrollController();

  ChatRoomState(
      {this.isLoading,
      this.uploadFileRep,
      this.isSending,
      this.chats,
      this.file,
      this.chatTextController,
      this.isTyping});

  static ChatRoomState init() {
    return ChatRoomState(
        uploadFileRep: ApiResponse(),
        file: {},
        chatTextController: TextEditingController(),
        isLoading: false,
        isSending: false,
        isTyping: false,
        chats: []);
  }

  ChatRoomState copyWith(
      {bool? isLoading,
      bool? isSending,
      bool? isTyping,
      ApiResponse? uploadFileRep,
      Map<String, File>? file,
      List<ChatMessages>? chats,
      TextEditingController? chatTextController}) {
    return ChatRoomState(
        file: file ?? this.file,
        uploadFileRep: uploadFileRep ?? this.uploadFileRep,
        isTyping: isTyping ?? this.isTyping,
        chatTextController: chatTextController ?? this.chatTextController,
        isSending: isSending ?? this.isSending,
        isLoading: isLoading ?? this.isLoading,
        chats: chats ?? this.chats);
  }

  void scrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (chatScrollController.hasClients) {
      final position = chatScrollController.position.maxScrollExtent;
      chatScrollController.animateTo(
        position,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
