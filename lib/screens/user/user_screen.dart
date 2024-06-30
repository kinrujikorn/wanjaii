import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/create_screen.dart';
import 'package:flutter_dating_app/screens/user/edit_profile.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_dating_app/screens/home/home_no_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dating_app/models/user_model.dart';
import 'package:flutter_dating_app/widgets/bottom_nav_bar.dart';
import 'package:flutter_dating_app/services/user_service.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/signin.dart';

class UserScreen extends StatefulWidget {
  static const String routeName = '/user';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => UserScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _imageUrls;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await UserService().getUserData();
    print(userData);
    _imageUrls = userData.imageUrls;

    setState(() {});
  }

  Future<void> _getCurrentUser() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        //backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            children: [
              Text('Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  )),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Color(0xFFBB254A),
            onPressed: () {
              // Navigate to edit profile screen
              Navigator.pushNamed(context, EditProfileScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            color: Color(0xFFBB254A),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Create(title: "title")),
              );
              // Navigate to the login screen
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(index: 3),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFBB254A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Container(
                      width: 200, // เปลี่ยนจาก 160 เป็น 200
                      height: 200, // เปลี่ยนจาก 160 เป็น 200
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            100), // เปลี่ยนจาก 80 เป็น 100
                        border: Border.all(
                          color: Color.fromRGBO(233, 64, 87, 0.3),
                          width: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Color.fromRGBO(233, 64, 87, 0.5),
                          width: 10,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: _imageUrls != null
                              ? NetworkImage(_imageUrls!)
                              : AssetImage(
                                      'assets/images/profile_placeholder.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account Setting',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sk-Modernist',
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.name
                                              : 'Name',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sk-Modernist',
                                            color: const Color.fromARGB(
                                                255, 178, 173, 173),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.phoneNumber
                                              : 'phonenumber',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sk-Modernist',
                                            color: const Color.fromARGB(
                                                255, 178, 173, 173),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.email
                                              : 'email',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sk-Modernist',
                                            color: const Color.fromARGB(
                                                255, 178, 173, 173),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discovery Settings',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontFamily: 'Sk-Modernist',
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'City',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.city
                                              : 'city',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sk-Modernist',
                                              color: const Color.fromARGB(
                                                  255, 178, 173, 173)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'State',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.state
                                              : 'state',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sk-Modernist',
                                              color: const Color.fromARGB(
                                                  255, 178, 173, 173)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Country',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.country
                                              : 'country',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sk-Modernist',
                                              color: const Color.fromARGB(
                                                  255, 178, 173, 173)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: 350, // Fixed width
                                  height: 60, // Fixed height
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFE0E2E9)),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _currentUser != null
                                              ? _currentUser!.gender
                                              : 'gender',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sk-Modernist',
                                              color: const Color.fromARGB(
                                                  255, 178, 173, 173)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
