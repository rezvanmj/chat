import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../application/home/home_bloc.dart';
import '../../application/home/home_state.dart';
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
        title: const Center(child: Text('Chat Rooms')),
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
          Navigator.of(context)
              .pushNamed(chatRoomPage, arguments: {'chatRoomId': chatRoom});
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
                title: Text(chatRoom.name ?? 'chatRoom'),
                leading: const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    child: Icon(
                      Icons.group,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
