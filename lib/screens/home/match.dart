import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/models/user_model.dart';
import 'package:flutter_dating_app/screens/chat/individual_chat_page.dart';

class MatchScreen extends StatelessWidget {
  final User currentUser;
  final User matchedUser;
  final List<User> swipedUsers;
  final Function(List<User>) onKeepSwiping;

  const MatchScreen({
    Key? key,
    required this.currentUser,
    required this.matchedUser,
    required this.swipedUsers,
    required this.onKeepSwiping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 420,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 95,
                      child: Transform.rotate(
                        angle: 0.15,
                        child: Container(
                          width: 250,
                          height: 340,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: 150,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 4,
                                        blurRadius: 8,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(matchedUser.imageUrls),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                elevation: 8,
                                shape: const CircleBorder(),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Color(0xFFBB254A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 55,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: Container(
                          width: 250,
                          height: 340,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: 150,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 4,
                                        blurRadius: 8,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(currentUser.imageUrls),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                elevation: 8,
                                shape: const CircleBorder(),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Color(0xFFBB254A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'It\'s a match, ${matchedUser.name}!',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFBB254A),
                  fontFamily: 'Sk-Modernist',
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Start a conversation now with each other',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  fontFamily: 'Sk-Modernist',
                ),
              ),
              const SizedBox(height: 80.0),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualChatPage(
                          receiverEmail: matchedUser.email,
                          receiverId: matchedUser.uid ?? '',
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFBB254A)), // Change button color
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(295, 56)), // Set button width and height
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Set border radius here
                      ),
                    ),
                  ),
                  child: const Text(
                    'Say hello',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFFFFFFF),
                    ),
                  )),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(matchedUser);
                    onKeepSwiping(swipedUsers);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFf8e9ed)), // Change button color
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(295, 56)), // Set button width and height
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Set border radius here
                      ),
                    ),
                  ),
                  child: const Text(
                    'Keep swiping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFBB254A),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
