// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/chat/individual_chat_page.dart';
import 'package:flutter_dating_app/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dating_app/services/firestore_service.dart';
// import 'package:flutter_dating_app/screens/chat/chat_service.dart';
// import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const ChatScreen(
        chatId: '',
      ),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreService = FirestoreService();
  // final ChatServices _chatService = ChatServices();
  List<dynamic> _users = [];
  List<dynamic> _filteredMatches = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchData();
    _filteredMatches = _users;
  }

  // void _filterUsers(String query) {
  //   print("query: ${query.toLowerCase()}");

  //   // Perform filtering
  //   final filter = _users
  //       .where((user) =>
  //           (user.name as String).toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   print("filter: $filter");

  //   // Update filtered matches
  //   setState(() {
  //     _filteredMatches = filter;
  //   });

  //   print("_filteredMatches: $_filteredMatches");
  // }
  // void _filterUsers(String query) {
  //   List<dynamic> filteredUsers = [];
  //   print("query: $query");

  //   for (var user in _users) {
  //     if ((user.name as String).toLowerCase().contains(query.toLowerCase())) {
  //       print("user: ${user.name}");
  //       filteredUsers.add(user);
  //     }
  //   }
  //   print("filteredUsers: $filteredUsers");
  //   setState(() {
  //     _filteredMatches = filteredUsers;
  //   });
  // }

  List<dynamic> _filterUsers(String query) {
    Set<dynamic> filteredUsers = {}; // Using Set to ensure uniqueness
    print("query: $query");

    for (var user in _users) {
      if ((user.name as String).toLowerCase().contains(query.toLowerCase())) {
        final userIn = (
          uid: user.uid,
          name: user.name,
          imageUrls: user.imageUrls,
          email: user.email,
        );
        print("user: ${userIn.name}");
        filteredUsers.add(userIn); // Adding user to the set
      }
    }

    List<dynamic> _filteredMatches =
        filteredUsers.toList(); // Convert set back to list
    print("_filteredMatches: $_filteredMatches");

    return _filteredMatches;
  }

  Future<void> _fetchData() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId != null) {
        final matchesSnapshot = await FirebaseFirestore.instance
            .collection('matches')
            .where('user2', isEqualTo: currentUserId)
            .get();
        final matchesSnapshot2 = await FirebaseFirestore.instance
            .collection('matches')
            .where('user1', isEqualTo: currentUserId)
            .get();

        final List<String> matchedUserIds = [];

        for (var match in matchesSnapshot.docs) {
          matchedUserIds.add(match['user1']);
        }
        for (var match in matchesSnapshot2.docs) {
          matchedUserIds.add(match['user2']);
        }
        final uniqueMatchedUserIds = matchedUserIds.toSet().toList();
        final List matchList = [];
        final List userList = [];
        for (var userId in uniqueMatchedUserIds) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          if (userDoc.exists) {
            final user = (
              uid: userId,
              name: userDoc['name'],
              imageUrls: userDoc['imageUrls'],
              email: userDoc['email'],
              // message: " "
            );
            userList.add(user);
          } else {
            print('User data not found for user ID: $userId');
          }
        }
        //Print
        // for (var user in matchList) {
        //   print('User ID: ${user.uid}');
        //   print('Name: ${user.name}');
        //   print('imageUrls: ${user.imageUrls}');
        //   print('email: ${user.email}');
        // }

        // print('current user: $currentUserId');
        setState(() {
          _users = userList;
        });
        setState(() {
          _filteredMatches = matchList;
        });
      } else {
        print('User not logged in.');
      }
    } catch (error) {
      print('Error fetching matched users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Messages',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sk-Modernist',
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(index: 2), // Removed const
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // Removed const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0), // Removed const
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 1),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          _filteredMatches = _filterUsers(query);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search_rounded),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 183, 178, 179)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 183, 178, 179)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Sk-Modernist',
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Visibility(
            //   visible: _searchController.text.isNotEmpty &&
            //       _filteredMatches.isNotEmpty,
            //   child: Expanded(
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         children: _filteredMatches
            //             .map(
            //               (user) => Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: ChatTile(
            //                   // context,
            //                   name: user.name,
            //                   message:
            //                       " ", // Assuming this property exists in your tuple
            //                   image: user.imageUrls,
            //                   receiverEmail: user.email,
            //                   receiverId: user.uid,
            //                 ),
            //               ),
            //             )
            //             .toList(),
            //       ),
            //     ),
            //   ),
            // ),
            Visibility(
              visible: _searchController.text.isNotEmpty &&
                  _filteredMatches.isNotEmpty,
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.vertical, // Set scroll direction to vertical
                  child: Column(
                    // Wrap Row with Column
                    children: _filteredMatches
                        .map(
                          (user) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChatTile(
                              // context,
                              name: user.name,
                              message: " ",
                              image: user.imageUrls,
                              receiverEmail: user.email,
                              receiverId: user.uid,
                              timestamp: Timestamp.now(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible:
                  _searchController.text.isNotEmpty && _filteredMatches.isEmpty,
              child: Center(
                child: Text(
                  'No Match',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sk-Modernist',
                  ),
                ),
              ),
            ),

            if (_searchController.text.isEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'New Matches',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sk-Modernist',
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _users
                              .map((user) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildChatUser(
                                      context,
                                      user.name,
                                      user.imageUrls,
                                      user.uid,
                                      user.email,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sk-Modernist',
                        ),
                      ),
                      Expanded(
                        child: _buildMessageList(context),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('matches').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Color(0xFFBB254A),
          ); // Display loading indicator while waiting for data
        }
        if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Display error message if there's an error
        }

        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final matchedUserIds = <String, dynamic>{};

        for (var doc in snapshot.data!.docs) {
          if (doc['user1'] == currentUserId) {
            matchedUserIds[doc['user2']] = {
              'user1': doc['user1'],
              'user2': doc['user2']
            };
          } else if (doc['user2'] == currentUserId) {
            matchedUserIds[doc['user1']] = {
              'user1': doc['user1'],
              'user2': doc['user2']
            };
          }
        }
        print("matchedUserIds: $matchedUserIds");

        // Fetch timestamps from chat_room collection
        Future<void> fetchTimestamps() async {
          for (var userId in matchedUserIds.keys) {
            print("userId: $userId");
            String user1 = matchedUserIds[userId]['user1'];
            String user2 = matchedUserIds[userId]['user2'];
            print("user1: $user1");
            print("user2: $user2");

            List<String> ids = [user1, user2];
            ids.sort();
            String chatRoomId = ids.join('_');
            var querySnapshot = await FirebaseFirestore.instance
                .collection('chat_room')
                .doc(chatRoomId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();
            print("querySnapshot");

            if (querySnapshot.docs.isNotEmpty) {
              var latestMessageDoc = querySnapshot.docs.first;
              print("latestMessageDoc data: ${latestMessageDoc.data()}");
              matchedUserIds[userId]['timestamp'] =
                  latestMessageDoc['timestamp'];
              print(
                  "matchedUserIds[userId]['timestamp']: ${matchedUserIds[userId]['timestamp']}");
              matchedUserIds[userId]['message'] = latestMessageDoc['message'];
            } else {
              // Set default timestamp and message if no messages found
              matchedUserIds[userId]['timestamp'] = null;
              matchedUserIds[userId]['message'] = '';
            }
            print("NEW matchedUserIds: $matchedUserIds");
          }
        }

        // Call fetchTimestamps() and build ChatTile widgets once timestamps are fetched
        return FutureBuilder(
          future: fetchTimestamps(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color(0xFFBB254A),
              ); // Display loading indicator while waiting for timestamps
            }

            // Sort matchedUserIds by timestamp of latest message
            // Sort matchedUserIds by timestamp of latest message
            // Filter out entries with null timestamps
            var filteredUserIds = matchedUserIds.keys
                .where((userId) => matchedUserIds[userId]['timestamp'] != null);

// Sort filteredUserIds by timestamp of latest message
            var sortedUserIds = filteredUserIds.toList()
              ..sort((a, b) {
                var timestampA = matchedUserIds[a]['timestamp'];
                var timestampB = matchedUserIds[b]['timestamp'];

                // Compare timestamps
                return timestampB!.compareTo(timestampA!);
              });

            print("sortedUserIds");
            print(sortedUserIds);

            return ListView.builder(
              itemCount: sortedUserIds.length,
              itemBuilder: (context, index) {
                final userId = sortedUserIds[index];

                // final userId = matchedUserIds.elementAt(index);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Color(0xFFBB254A),
                      ); // Display loading indicator while waiting for user data
                    }
                    if (userSnapshot.hasError) {
                      return Text(
                          'Error: ${userSnapshot.error}'); // Display error message if there's an error
                    }

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    final userName = userData['name'];
                    final userImage = userData['imageUrls'] != null &&
                            userData['imageUrls'].isNotEmpty
                        ? userData['imageUrls']
                        : Icons.person;
// Null-aware access to imageUrls
                    print("userImage: $userImage");

                    // Define function to fetch latest message
                    Stream<QuerySnapshot> getLatestMessageStream(
                        String currentUserId, String otherUserId) {
                      List<String> ids = [currentUserId, otherUserId];
                      ids.sort();
                      String chatRoomId = ids.join('_');
                      return FirebaseFirestore.instance
                          .collection("chat_room")
                          .doc(chatRoomId)
                          .collection("messages")
                          .orderBy("timestamp", descending: true)
                          .limit(1)
                          .snapshots();
                    }

                    // Fetch latest message
                    var latestMessageStream =
                        getLatestMessageStream(currentUserId!, userId);
                    Stream<List<Map<String, dynamic>>> latestMessagesStream =
                        Stream.periodic(Duration(seconds: 5))
                            .asyncMap((_) async {
                      List<Map<String, dynamic>> latestMessages = [];

                      for (var userId in matchedUserIds.keys) {
                        String user1 = matchedUserIds[userId]['user1'];
                        String user2 = matchedUserIds[userId]['user2'];

                        List<String> ids = [user1, user2];
                        ids.sort();
                        String chatRoomId = ids.join('_');

                        var querySnapshot = await FirebaseFirestore.instance
                            .collection('chat_room')
                            .doc(chatRoomId)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var latestMessageDoc = querySnapshot.docs.first;
                          latestMessages.add({
                            'userId': userId,
                            'timestamp': latestMessageDoc['timestamp'],
                            'message': latestMessageDoc['message']
                          });
                        }
                      }

                      // Sort latest messages based on timestamp
                      latestMessages.sort((a, b) =>
                          (b['timestamp'] as Timestamp)
                              .compareTo(a['timestamp']));

                      return latestMessages;
                    });

                    return StreamBuilder<QuerySnapshot>(
                      stream: latestMessageStream,
                      builder: (context, messageSnapshot) {
                        if (messageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Color(0xFFBB254A),
                          ); // Display loading indicator while waiting for message data
                        }
                        if (messageSnapshot.hasError) {
                          return Text(
                              'Error: ${messageSnapshot.error}'); // Display error message if there's an error
                        }

                        // Retrieve message
                        var messageDocs = messageSnapshot.data!.docs;
                        if (messageDocs.isEmpty) {
                          return SizedBox(); // Return an empty SizedBox if there's no message
                        }

                        var message = messageDocs.first['message'];
                        var type = messageDocs.first['type'];
                        var sender = messageDocs.first['senderId'];
                        var timestamp = messageDocs.first['timestamp'];

                        print("type, $type");
                        print("message, $message");
                        // Check conditions
                        if (message == "" && type != 'image') {
                          return SizedBox(); // Return SizedBox if message is null and type is not image
                        } else if (message == "" &&
                            type == 'image' &&
                            sender == userId) {
                          message =
                              '$userName sent a photo'; // Set message to 'You sent a photo' if message is null and type is image
                        } else if (message == "" &&
                            type == 'image' &&
                            sender != userId) {
                          message = 'You sent a photo';
                        }
                        print("timestamp");
                        print("$timestamp");

                        return ChatTile(
                            name: userName,
                            message: message,
                            image: userImage,
                            receiverEmail: userData['email'],
                            receiverId: userId,
                            timestamp: timestamp);
                      },
                    );
                  },
                );
                // Fetch user data and build ChatTile widget here
              },
            );
          },
        );
      },
    );
  }
}

Widget _buildChatUser(BuildContext context, String name, String imagePath,
    String receiverId, String receiverEmail) {
  print("imagePath: ${imagePath}");
  // const receiverId = "duzR4XhvrEWmLqV2xSLvKmygiZh1";
  // const receiverEmail = "koontung0110@gmail.com";
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndividualChatPage(
              receiverEmail: receiverEmail, receiverId: receiverId),
        ),
      );
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFFBB254A), // Set border color to red
              width: 2.0, // Set border width
            ),
          ),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(imagePath),
          ),
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 16.0, fontFamily: 'Sk-Modernist'),
        ),
      ],
    ),
  );
}

class ChatTile extends StatefulWidget {
  final String name;
  final String image;
  final String message;
  final String receiverEmail;
  final String receiverId;
  final Timestamp timestamp;

  const ChatTile({
    Key? key,
    required this.name,
    required this.image,
    required this.message,
    required this.receiverEmail,
    required this.receiverId,
    required this.timestamp,
  }) : super(key: key);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late String _message;
  late Timestamp _timestamp;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadLatestMessage();

    // Set up a timer to fetch new messages periodically
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _loadLatestMessage();
    });
  }

  void _loadLatestMessage() {
    // Assign the latest message text to the _message variable
    _message = widget.message;
    _timestamp = widget.timestamp;

    setState(() {}); // Trigger a rebuild to update the message in the UI
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("widget.image: ${widget.image}");
    // print("widget.name: ${widget.name}");
    // Format the timestamp
    final Timestamp timestamp = _timestamp;
    String date = DateFormat.yMMMEd().format(
        timestamp.toDate()); // Use 'yMMMEd' for date with month name and year
    String time = DateFormat.Hm().format(timestamp.toDate());
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(widget.image),
      ),
      title: Text(
        widget.name,
        style: TextStyle(
          fontFamily: 'Sk-Modernist',
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _message,
            style: TextStyle(
              fontFamily: 'Sk-Modernist',
            ),
          ),
          Text(
            // Assuming timestamp is of type Timestamp
            time.toString(), // Convert timestamp to string
            style: TextStyle(
              fontFamily: 'Sk-Modernist',
              fontSize: 12, // Adjust font size as needed
              color: Colors.grey, // Optionally adjust color
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatPage(
              receiverEmail: widget.receiverEmail,
              receiverId: widget.receiverId,
            ),
          ),
        );
      },
      // Add the Divider widget as the trailing property
      trailing: Container(
        height: 50, // Adjust the height of the line as needed
        width: 2, // Adjust the width of the line as needed
        color: Color(0xFFBB254A), // Set the color of the line to red
      ),
    );
  }
}
