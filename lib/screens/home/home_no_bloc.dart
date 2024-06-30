import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/home/match.dart';
import 'package:flutter_dating_app/screens/home/profile_screen.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/picture_screen.dart';
import 'package:flutter_dating_app/screens/onboarding/onbroading_screen.dart';
import 'package:flutter_dating_app/widgets/app_bar.dart';
import 'package:flutter_dating_app/widgets/bottom_nav_bar.dart';
import 'package:flutter_dating_app/widgets/choice_button.dart';
import 'package:flutter_dating_app/widgets/user_card.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';

//const ip = '192.168.100.107'; //POOHPOOM
const ip = '192.168.0.164'; //My home
//const ip = '172.20.10.2'; //My home

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserCard _userCard;
  final _currentUserRef = FirebaseFirestore.instance.collection('users');
  List<User> _users = [];
  List<User> _swipedUsers = [];
  User? _currentUser;
  bool _showRightSwipeIcon = false;
  bool _showLeftSwipeIcon = false;
  String? _selectedLocation;
  String _selectedGender = ''; // Possible values: 'male', 'female', ''
  int _minAgeFilter = 18;
  int _maxAgeFilter = 50;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchData();
  }

  /* Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://$ip:3000/users'));
      if (response.statusCode == 200) {
        final usersJson = jsonDecode(response.body);
        setState(() {
          _users = usersJson
              .map<User>((userJson) => User.fromJson(userJson))
              .where((user) =>
                  !_swipedUsers.contains(user) &&
                  (user.uid != (_currentUser?.uid ?? '')) &&
                  !(_currentUser?.likedUsers.contains(user.uid) ?? false))
              .toList();
        });
      } else {
        print('Failed to fetch users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  } */

  // Modify _fetchData method
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://$ip:3000/users'));
      if (response.statusCode == 200) {
        final usersJson = jsonDecode(response.body);
        setState(() {
          _users = usersJson
              .map<User>((userJson) => User.fromJson(userJson))
              .where((user) =>
                  !_swipedUsers.contains(user) &&
                  !(_currentUser?.dislikedUsers.contains(user.uid) ?? false) &&
                  (user.uid != (_currentUser?.uid ?? '')) &&
                  !(_currentUser?.likedUsers.contains(user.uid) ?? false) &&
                  (_selectedGender.isEmpty || user.gender == _selectedGender) &&
                  (user.age >= _minAgeFilter && user.age <= _maxAgeFilter))
              .toList();
        });
      } else {
        print('Failed to fetch users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  Future<void> _getCurrentUser() async {
    try {
      print("currentUserId: $currentUserId");
      if (currentUserId != null) {
        final response =
            await http.get(Uri.parse('http://$ip:3000/users/$currentUserId'));
        if (response.statusCode == 200) {
          final userJson = jsonDecode(response.body);
          setState(() {
            _currentUser = User.fromJson(userJson);
            print("current user data: $_currentUser");
          });
        } else {
          print('Failed to fetch current user: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error fetching current user: $error');
    }
  }

  /* Future<void> _updateLikedUsers(String likedUserId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://192.168.1.39:3000/users/${_currentUser?.uid}/like/$likedUserId'),
      );
      if (response.statusCode == 200) {
        print('Liked user updated successfully');
      } else {
        print('Failed to update liked user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating liked user: $error');
    }
  } */

  void _applyFilters(
      String selectedGender, String selectedLocation, int minAge, int maxAge) {
    setState(() {
      _selectedGender = selectedGender;
      _selectedLocation = selectedLocation;
      _minAgeFilter = minAge;
      _maxAgeFilter = maxAge;
    });
    _fetchData();
  }

  void _onKeepSwiping(List<User> swipedUsers) {
    setState(() {
      _swipedUsers = swipedUsers;
      _users.removeWhere((user) => swipedUsers.contains(user));
    });
  }

/*   void _swipeLeft() {
    setState(() {
      if (_users.isNotEmpty) {
        _swipedUsers.add(_users.removeAt(0));
      }
    });
    print('Swiped left');
  } */

  void _swipeLeft() {
    if (_users.isNotEmpty) {
      final dislikedUser = _users.removeAt(0);
      _swipedUsers.add(dislikedUser);
      if (dislikedUser.uid != null && _currentUser?.uid != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update({
          'dislikedUsers': FieldValue.arrayUnion([dislikedUser.uid]),
        });
      }

      // Update the _userCard with the next user in the list
      if (_users.isNotEmpty) {
        setState(() {
          _userCard = UserCard(user: _users[0]);
        });
      }
    }
  }

  void _swipeRight() async {
    if (_users.isNotEmpty) {
      final swipedUser = _users.removeAt(0);
      //_swipedUsers.add(swipedUser);
      await _currentUserRef.doc(_currentUser!.uid).update({
        'likedUsers': FieldValue.arrayUnion([swipedUser.uid]),
      });
      print("Update the current user's liked users list");

      final response =
          await http.get(Uri.parse('http://$ip:3000/users/${swipedUser.uid}'));
      if (response.statusCode == 200) {
        final updatedSwipedUser = User.fromJson(jsonDecode(response.body));
        print('match: $updatedSwipedUser');
        print('current user: $_currentUser');
        //_showMatchScreen(_currentUser!, updatedSwipedUser);
        if (updatedSwipedUser.likedUsers.contains(_currentUser!.uid)) {
          // Both users have liked each other, show the MatchScreen and update Firestore
          await FirebaseFirestore.instance.collection('matches').add({
            'user1': _currentUser!.uid,
            'user2': updatedSwipedUser.uid,
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchScreen(
                currentUser: _currentUser!,
                matchedUser: updatedSwipedUser,
                swipedUsers: _swipedUsers,
                onKeepSwiping: _onKeepSwiping,
              ),
            ),
          );
        } else {
          setState(() {
            if (_users.isNotEmpty) {
              _swipedUsers.add(updatedSwipedUser);
            }
          });
          print(
              'swiped user:${swipedUser.uid}, current user:${_currentUser!.uid}');
          print('Swiped right');
        }
      } else {
        print('Failed to fetch updated swiped user: ${response.statusCode}');
      }
    }
  }

  void _showMatchScreen(User currentUser, User updatedSwipedUser) {
    var swipedUserId = updatedSwipedUser.uid;
    var currentUserId = currentUser.uid;
    if (currentUser.likedUsers.contains(updatedSwipedUser.uid)) {
      if (updatedSwipedUser.likedUsers.contains(currentUser.uid)) {
        // Both users have liked each other, show the MatchScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchScreen(
              currentUser: currentUser,
              matchedUser: updatedSwipedUser,
              swipedUsers: _swipedUsers,
              onKeepSwiping: _onKeepSwiping,
            ),
          ),
        );
      }
    } else {
      setState(() {
        if (_users.isNotEmpty) {
          _swipedUsers.add(updatedSwipedUser);
        }
      });
      print('swiped user:$swipedUserId, current user:$currentUserId');
      print('Swiped right');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        _users.where((user) => !_swipedUsers.contains(user)).toList();
    //final usercard = filteredUsers[0];
    final usercard = filteredUsers.isNotEmpty ? filteredUsers[0] : null;
    print('user card: $usercard');
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
        location: '',
        onApplyFilters: _applyFilters,
        lastSelectedGender: _selectedGender, // Add this line
        lastSelectedLocation: _selectedLocation, // Add this line
        lastSelectedMinAge: _minAgeFilter, // Add this line
        lastSelectedMaxAge: _maxAgeFilter, // Add th
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
      body: _users.isEmpty
          ? Center(
              child: Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFBB254A),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'No more users available!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Sk-Modernist',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                filteredUsers.isNotEmpty
                    ? GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                user: filteredUsers[0],
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Draggable(
                              child: _userCard =
                                  UserCard(user: filteredUsers[0]),
                              feedback: UserCard(user: filteredUsers[0]),
                              childWhenDragging: filteredUsers.length > 1
                                  ? UserCard(user: filteredUsers[1])
                                  : Container(),
                              onDragUpdate: (details) {
                                if (details.delta.dx > 0) {
                                  // Show right swipe icon
                                  setState(() {
                                    _showRightSwipeIcon = true;
                                  });
                                } else if (details.delta.dx < 0) {
                                  // Show left swipe icon
                                  setState(() {
                                    _showLeftSwipeIcon = true;
                                  });
                                }
                              },
                              onDragEnd: (drag) {
                                if (drag.offset.dx < 0) {
                                  _swipeLeft();
                                } else {
                                  _swipeRight();
                                }
                                setState(() {
                                  _showRightSwipeIcon = false;
                                  _showLeftSwipeIcon = false;
                                });
                              },
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _showRightSwipeIcon
                                    ? Material(
                                        elevation: 8,
                                        shape: const CircleBorder(),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 60,
                                            color: Color(0xFFBB254A),
                                          ),
                                        ),
                                      )
                                    : _showLeftSwipeIcon
                                        ? Material(
                                            elevation: 8,
                                            shape: const CircleBorder(),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.clear,
                                                size: 60,
                                                color: Color(0xFFBB254A),
                                              ),
                                            ),
                                          )
                                        : Container(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _swipeLeft,
                        child: const ChoiceButton(
                          width: 80,
                          height: 80,
                          size: 30,
                          hasGradient: false,
                          color: Color.fromRGBO(242, 113, 33, 1),
                          icon: Icons.clear_rounded,
                        ),
                      ),
                      InkWell(
                        onTap: _swipeRight,
                        child: const ChoiceButton(
                          width: 105,
                          height: 105,
                          size: 54,
                          hasGradient: true,
                          color: Colors.white,
                          icon: Icons.favorite,
                        ),
                      ),
                      const ChoiceButton(
                        width: 80,
                        height: 80,
                        size: 30,
                        hasGradient: false,
                        color: Color.fromRGBO(138, 35, 135, 1),
                        icon: Icons.star,
                      ),
                      // TextButton(
                      //   child: const Text(
                      //     'Cancel',
                      //     style: TextStyle(
                      //       fontSize: 19,
                      //       fontFamily: 'Sk-Modernist',
                      //       color: Color(0xFFBB254A),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const ProfileSetupScreen(
                      //               tabController: widget.tapco)),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
