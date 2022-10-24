// part of 'home_bloc.dart';
import '../../domain/chat_room/chat_room_model.dart';

class HomeState {
  final bool? isConnecting;
  final int? notificationCounter;
  final bool? isLoading;
  final List<ChatRoomModel>? chatRooms;
  final bool? isDeleting;
  HomeState({
    this.isConnecting,
    this.notificationCounter,
    this.isLoading,
    this.chatRooms,
    this.isDeleting,
  });

  static HomeState init() {
    return HomeState(
      isConnecting: true,
      isDeleting: false,
      notificationCounter: 0,
      chatRooms: [],
      isLoading: false,
    );
  }

  HomeState copyWith(
      {bool? isLoading,
      List<ChatRoomModel>? chatRooms,
      bool? isDeleting,
      bool? isConnecting,
      int? notificationCounter}) {
    return HomeState(
      isConnecting: isConnecting ?? this.isConnecting,
      isDeleting: isDeleting ?? this.isDeleting,
      isLoading: isLoading ?? this.isLoading,
      notificationCounter: notificationCounter ?? this.notificationCounter,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }
}
