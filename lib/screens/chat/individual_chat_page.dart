import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/screens/chat/chat_screen.dart';
import 'package:flutter_dating_app/services/chat_service.dart';
import 'package:flutter_dating_app/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/chat/chat_bubbles.dart';

class IndividualChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  IndividualChatPage(
      {super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final ChatServices _chatService = ChatServices();

  final messageController = TextEditingController();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchImagePath();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      // print("sendButton Pressed");

      await _chatService.sendMessage(widget.receiverId, messageController.text);
      messageController.clear();
      scrollDown();
    }
  }

  void sendImage() async {
    final imagePath = await StorageService().pickImage();
    if (imagePath != null) {
      final imageUrls = await StorageService().uploadImage(imagePath);
      await _chatService.sendImage(widget.receiverId, imageUrls);
      scrollDown();
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  String imageProfilePath = "";
  String name = "";
  fetchImagePath() async {
    QuerySnapshot imageProfilePathQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.receiverId)
        .get();
    // print("this is query");
    // print(imageProfilePathQuery.docs[0]["imageUrls"]);
    setState(() {
      imageProfilePath = imageProfilePathQuery.docs[0]["imageUrls"];
      name = imageProfilePathQuery.docs[0]["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(imageProfilePath),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                color: Color(0xFFBB254A),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFFBB254A),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatScreen(
                          chatId: '',
                        )),
              ); // Navigate back to chat screen
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(currentUserID, widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Color(0xFFBB254A),
            );
          }

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final Timestamp timestamp = data["timestamp"];
    String date = DateFormat.yMMMEd().format(
        timestamp.toDate()); // Use 'yMMMEd' for date with month name and year
    String time = DateFormat.Hm().format(timestamp.toDate());

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubbles(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            timestamp: data["timestamp"],
            type: data["type"],
            imageUrls: data["imageUrls"],
          ),
          Container(
            // padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
            child: Text(
              date + " " + "on" + " " + time,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.w700,
                color: Color(0xFFBB254A),
              ),
            ),
          ),
          const SizedBox(height: 3.0), // Spacing after the date
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            IconButton(
              onPressed: () =>
                  {sendImage()}, // Arrow function for sequential execution
              icon: const Icon(Icons.photo, color: Color(0xFFBB254A)),
            ),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFBB254A),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                ),
                focusNode: myFocusNode,
              ),
            ),
            IconButton(
              onPressed: () => {
                sendMessage(),
              }, // Arrow function for sequential execution
              icon: const Icon(Icons.send, color: Color(0xFFBB254A)),
            ),
          ],
        ),
      ),
    );
  }
}
