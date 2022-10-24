import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../application/home/home_bloc.dart';
import '../../application/home/home_state.dart';
import '../../core/dio_init.dart';
import '../../core/service_locator.dart';
import '../../domain/chat_room/chat_room_model.dart';
import '../core/const_routes.dart';

class HomeView extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => getIt<HomeBloc>()..add(GetChatRoomsEvent()),
        child: BlocBuilder<HomeBloc, HomeState>(builder: _blocBuilder));
  }

  void _blocListener(context, HomeState state) async {}

  Widget _blocBuilder(context, HomeState state) {
    return Scaffold(
      key: HomeView.navigatorKey,
      appBar: AppBar(
        title: Center(
            child: !state.isConnecting!
                ? const Text('connecting... ')
                : const Text('Chat Rooms')),
      ),
      body: state.isLoading!
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<HomeBloc>(context).add(GetChatRoomsEvent());
              },
              child: ListView(
                children: [
                  for (var chatRoom in state.chatRooms!)
                    _chatRoomItem(chatRoom, context)
                ],
              ),
            ),
    );
  }

  Widget _chatRoomItem(ChatRoomModel chatRoom, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(DisConnectSocket());
          Navigator.of(context).pushNamed(chatRoomPage,
              arguments: {'chatRoomId': chatRoom}).then((value) {
            BlocProvider.of<HomeBloc>(context).add(GetChatRoomsEvent());
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: chatRoom.unreadMessagesCount == 0
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (context) {},
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.close,
                    label: 'delete',
                  ),
                ],
              ),
              child: ListTile(
                isThreeLine: true,
                trailing: chatRoom.unreadMessagesCount == 0
                    ? const SizedBox.shrink()
                    : _counter(chatRoom),
                title: _groupName(chatRoom),
                subtitle: _showDate(chatRoom),
                leading: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    child:
                        Image.network(CDNBaseUrl + chatRoom.creator!.avatar!),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _counter(ChatRoomModel chatRoom) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(70))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            chatRoom.unreadMessagesCount.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _groupName(ChatRoomModel chatRoom) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _groupTitle(chatRoom),
          const SizedBox(
            height: 10,
          ),
          _groupMessage(chatRoom)
        ],
      ),
    );
  }

  Widget _groupMessage(ChatRoomModel chatRoom) =>
      chatRoom.chatMessages!.last.message == ''
          ? const Text(
              'Attachment 📎',
              style: TextStyle(color: Colors.grey),
            )
          : Text(chatRoom.chatMessages!.last.message!,
              style: const TextStyle(color: Colors.grey));

  Widget _groupTitle(ChatRoomModel chatRoom) {
    return Text(
      chatRoom.creatorIp ?? 'chatRoom',
      style: const TextStyle(fontWeight: FontWeight.w800),
    );
  }

  Widget _showDate(ChatRoomModel chatRoom) {
    return Wrap(children: [
      const Text(
        'created at :',
        style: TextStyle(color: Colors.black),
      ),
      Text(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(chatRoom.createdAt!)),
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.w500),
      ),
    ]);
  }
}
