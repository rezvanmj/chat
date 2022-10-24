import 'dart:io';

import 'package:chat_project/application/chat_room/chat_room_bloc.dart';
import 'package:chat_project/domain/chat_room/chat_messages_model.dart';
import 'package:chat_project/domain/chat_room/chat_room_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:intl/intl.dart';

import '../../core/dio_init.dart';
import '../../core/service_locator.dart';
import '../../domain/core/enums.dart';
import '../../domain/core/general_exceptions.dart';

GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();

class ChatRoomView extends StatefulWidget {
  ChatRoomModel chatRoom;
  File? pickedFile;

  ChatRoomView({Key? key, required this.chatRoom}) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  ScrollController chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatRoomBloc>()
        ..add(GetMessagesEvent(widget.chatRoom.id!))
        ..add(UpdateMessageEvent(chatRoomId: widget.chatRoom.id!)),
      child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
        builder: (context, ChatRoomState state) {
          return _chatRoomBody(context, state);
        },
        listener: _blocListener,
      ),
    );
  }

  void _blocListener(context, ChatRoomState state) {
    BlocProvider.of<ChatRoomBloc>(context)
        .add(SeenMessages(widget.chatRoom.id!));

    if (mounted) {
      state.scrollToEnd();
    }

    // success
    if (state.uploadFileRep?.response is Success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('file Uploaded'),
          backgroundColor: Colors.green,
        ),
      );
    }
    // failure
    if (state.uploadFileRep?.response is Failure) {
      final failure = state.uploadFileRep!.response as Failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.failuer.toString()),
          backgroundColor: Colors.red,
        ),
      );

      /// 403 response
      if (failure.failuer is NotTrustedException) {
        const SnackBar(
          content: Text('FAILED'),
        );
      }
    }
  }

  Widget _chatRoomBody(context, ChatRoomState state) {
    return Scaffold(
      key: loginScaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              BlocProvider.of<ChatRoomBloc>(context)
                  .add(DisConnectSocket(widget.chatRoom.id!));
              Navigator.pop(context);
            },
          ),
          title: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  child: Image.network(
                      CDNBaseUrl + widget.chatRoom.creator!.avatar!),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.chatRoom.creatorIp!,
                    style: const TextStyle(fontSize: 17)),
                state.isTyping!
                    ? const Text(
                        'is Typing...',
                        style: TextStyle(fontSize: 14),
                      )
                    : const SizedBox()
              ],
            ),
          ])),
      body: state.isLoading!
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _chats(context, state),
                ),
                _typingInput(context, state)
              ],
            ),
    );
  }

  Widget _chats(context, ChatRoomState state) {
    return ListView.separated(
      controller: state.chatScrollController,
      itemCount: state.chats!.length,
      separatorBuilder: (BuildContext context, int index) {
        return _listViewSeparator(state, index);
      },
      itemBuilder: (BuildContext context, int index) {
        return _chatBubble(state.chats![index], context);
      },
    );
  }

  Widget _listViewSeparator(ChatRoomState state, int index) {
    DateTime currentChatDate = DateTime.parse(state.chats![index].createdAt!);
    DateTime nextChatDate = DateTime.parse(
        state.chats![state.chats!.indexOf(state.chats![index]) + 1].createdAt!);

    if (state.chats![index] != state.chats!.last &&
        currentChatDate.day != nextChatDate.day) {
      String chatDate =
          DateFormat.yMMMMd('en_US').format(currentChatDate).toString();
      return _chatDateItem(chatDate);
    } else if (state.chats![index] == state.chats!.first) {
      String chatDate =
          DateFormat.yMMMMd('en_US').format(currentChatDate).toString();
      return _chatDateItem(chatDate);
    }
    return const SizedBox.shrink();
  }

  Widget _chatDateItem(String date) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              date,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          )),
        ),
      ),
    );
  }

  ChatBubble _chatBubble(ChatMessages chat, context) {
    var time = DateTime.parse(chat.createdAt!).toLocal();

    String chatTime = DateFormat('hh:mm').format(time);

    return ChatBubble(
      clipper: ChatBubbleClipper4(
          type:
              chat.isSelf! ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: chat.isSelf! ? Alignment.bottomRight : Alignment.bottomLeft,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor:
          chat.isSelf! ? Colors.blue.withOpacity(0.4) : Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chatContent(context, chat),
          _space(height: 10),
          _chatInfo(chat, chatTime)
        ],
      ),
    );
  }

  Widget _chatInfo(ChatMessages chat, String chatTime) {
    return Wrap(
      children: [
        chat.status == 'seen' ? _seenIcon() : _sentIcon(),
        _space(width: 5),
        Text(
          chatTime,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _sentIcon() {
    return const Icon(
      Icons.done,
      size: 18,
      color: Colors.black,
    );
  }

  Widget _seenIcon() {
    return const Icon(
      Icons.done_all,
      size: 18,
      color: Colors.green,
    );
  }

  Widget _space({double? height, double? width}) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }

  Widget _chatContent(context, ChatMessages chat) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: chat.messageType == 'text'
          ? _textChat(chat)
          : chat.messageType == 'image'
              ? _imageChat(chat)
              : _fileChat(chat),
    );
  }

  Widget _imageChat(ChatMessages chat) {
    return Column(
      children: [
        Image.network(
          CDNBaseUrl + chat.src,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress != null) {
              return const Center(child: CircularProgressIndicator());
            }
            return child;
          },
        ),
        _space(),
        Text(chat.message! ?? '')
      ],
    );
  }

  Widget _fileChat(ChatMessages chat) {
    return Column(
      children: [
        const Icon(
          Icons.file_present,
          color: Colors.black,
          size: 50,
        ),
        Text(
          chat.originalFileName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        _space(),
        Text(chat.message! ?? '')
      ],
    );
  }

  Widget _textChat(ChatMessages chat) {
    return Text(
      chat.message!,
      style: TextStyle(color: chat.isSelf! ? Colors.black : Colors.white),
    );
  }

  Widget _typingInput(BuildContext context, ChatRoomState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value) {
          if (value.isNotEmpty) {
            BlocProvider.of<ChatRoomBloc>(context).add(IsAdminTypingEvent(
                chatRoom: widget.chatRoom, isAdminTyping: true));
          } else if (value.isEmpty) {
            BlocProvider.of<ChatRoomBloc>(context).add(IsAdminTypingEvent(
                chatRoom: widget.chatRoom, isAdminTyping: false));
          }
        },
        keyboardType: TextInputType.text,
        controller: state.chatTextController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.orange, width: 2)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          // border: InputBorder.none,
          suffixIcon: Wrap(
            children: [
              state.isSending! ? const SizedBox.shrink() : _attachmentIcon(),
              state.isSending! ? _loadingWidget() : _sendIcon(state, context),
            ],
          ),
          hintText: 'type something ... ',
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 13),
      child: SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          )),
    );
  }

  Widget _attachmentIcon() {
    return IconButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: [
              'jpg',
              'pdf',
              'png',
              'jpeg',
            ],
          );
          if (result != null) {
            widget.pickedFile = File(result.files.single.path.toString());
            String fileName = result.names.toString();
            showDialog<ChatRoomBloc>(
                context: loginScaffoldKey.currentContext!,
                builder: (context) {
                  return fileDialog(fileName, {'chatFile': widget.pickedFile});
                });
          } else {
            const SnackBar(content: Text('no file chosen'));
          }
        },
        icon: const Icon(
          Icons.attach_file,
          color: Colors.orange,
        ));
  }

  Dialog fileDialog(String fileName, Map<String, File?> fileMap) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('do you want to send this file ?'),
            _space(),
            const Icon(
              Icons.file_present,
              size: 40,
              color: Colors.orange,
            ),
            Text(fileName),
            _space(),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      BlocProvider.of<ChatRoomBloc>(
                              loginScaffoldKey.currentState!.context)
                          .add(UploadFileEvent(widget.chatRoom.id!, fileMap));
                      Navigator.pop(context);
                    },
                    child: const Text('send')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _sendIcon(ChatRoomState state, BuildContext context) {
    return IconButton(
        onPressed: () {
          BlocProvider.of<ChatRoomBloc>(context).add(IsAdminTypingEvent(
              chatRoom: widget.chatRoom, isAdminTyping: false));
          if (state.chatTextController!.text.isNotEmpty) {
            BlocProvider.of<ChatRoomBloc>(context)
                .add(SendMessageEvent(chatRoomId: widget.chatRoom.id!));
          }
        },
        icon: const Icon(
          Icons.send,
          color: Colors.orange,
        ));
  }
}
