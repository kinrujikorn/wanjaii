import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dating_app/services/user_service.dart';
import 'package:flutter_dating_app/widgets/bottom_nav_bar.dart';
import 'package:flutter_dating_app/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/EditProfile';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => EditProfileScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _imageUrls;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _languageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _profileAboutController = TextEditingController();
  TextEditingController _jobTitleController = TextEditingController();

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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _stateController.text = userData['state'] ?? '';
          _countryController.text = userData['country'] ?? '';
          _languageController.text = userData['language'] ?? '';
          _genderController.text = userData['gender'] ?? '';
          _phoneNumberController.text = userData['phoneNumber'] ?? '';
          _profileAboutController.text = userData['profileAbout'] ?? '';
          _jobTitleController.text = userData['jobTitle'] ?? '';
        });
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
        elevation: 0,
        centerTitle: false,
        // automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Text(' Edit Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  )),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: const BottomNavBar(index: 3),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFBB254A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(233, 64, 87, 0.3),
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(233, 64, 87, 0.5),
                                          width: 10,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.transparent,
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
                            GestureDetector(
                              onTap: () async {
                                final imagePath =
                                    await StorageService().pickImage();
                                if (imagePath != null) {
                                  final imageUrls = await StorageService()
                                      .uploadImage(imagePath);
                                  await UserService()
                                      .updateUserImage(imageUrls: imageUrls);
                                  _imageUrls = imageUrls;
                                  setState(() {});
                                }
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_enhance,
                                  size: 40,
                                  color: Color(0xFFBB254A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        // Expanded(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(40),
                        //         topRight: Radius.circular(40),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          child: Container(
                            width: 1000,
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Setting',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sk-Modernist',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: _buildNameField(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: _buildPhoneNumberField(),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Discovery Setting',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Sk-Modernist',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildCityField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildStateField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildCountryField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildLanguageField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildGenderField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildprofileAboutField(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: _buildjobTitleField(),
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFFBB254A)),
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.all(16)),
                                          minimumSize:
                                              MaterialStateProperty.all<Size>(
                                            Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                15),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // If the form is valid, send data to the backend
                                            updateUserData();
                                          }
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sk-Modernist',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Name',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Phone Number',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' City',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter your city',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' State',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _stateController,
              decoration: InputDecoration(
                hintText: 'Enter your state',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Country',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                hintText: 'Enter your country',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Preferred Languages',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _languageController,
              decoration: InputDecoration(
                hintText: 'Enter your Preferred Languages',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Gender',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                hintText: 'Enter you gender',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildprofileAboutField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Bio',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _profileAboutController,
              decoration: InputDecoration(
                hintText: 'Enter your profile about',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildjobTitleField() {
    return SizedBox(
      height: 71,
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE0E2E9)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Job Title',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
              ),
            ),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                hintText: 'Enter your job title',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sk-Modernist',
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'name': _nameController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'language': _languageController.text,
          'gender': _genderController.text,
          'phoneNumber': _phoneNumberController.text,
          'profileAbout': _profileAboutController.text,
          'jobTitle': _jobTitleController.text,
        });
        // Data updated successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('User data updated successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update user data: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
