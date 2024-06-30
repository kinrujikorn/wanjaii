import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/screens/home/home_no_bloc.dart';

import 'package:flutter_dating_app/screens/onboarding/widgets/custom_image_container.dart';
import 'package:flutter_dating_app/services/storage_service.dart';
import 'package:flutter_dating_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  final TabController tabController;

  const ProfileSetupScreen({
    required this.tabController,
  });

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String _firstName = '';
  String _lastName = '';
  DateTime _selectedDate = DateTime.now();
  String? dropdownValue;
  late String? _imageUrls;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Function to show the date picker modal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<String?> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    }

    return pickedFile.path;
  }

  String get fullName => '$_firstName $_lastName';
  int get age => DateTime.now().year - _selectedDate.year;

  // Future<void> _uploadData(String imagePath) async {
  //   void errorMessagePopup(String message) {
  //     // print('Sign In button pressed');
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //               title: const Text(
  //                 "ERROR",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontFamily: 'Sk-Modernist',
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               content: Text(
  //                 message,
  //                 style: const TextStyle(
  //                   fontSize: 19,
  //                   fontFamily: 'Sk-Modernist',
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text(
  //                     'Cancel',
  //                     style: TextStyle(
  //                       fontSize: 19,
  //                       fontFamily: 'Sk-Modernist',
  //                       color: Color(0xFFBB254A),
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ]);
  //         });
  //   }

  //   final file = File(imagePath);
  //   // if (imagePath == null || _firstName.isEmpty || _lastName.isEmpty) {
  //   //   return; // Show error message if data is missing
  //   // }
  //   if (imagePath == "") {
  //     errorMessagePopup("No picture added");
  //   }
  //   if (_firstName.isEmpty) {
  //     errorMessagePopup("Enter your first name");
  //   }

  //   if (_lastName.isEmpty) {
  //     errorMessagePopup("Enter your last name");
  //   }

  //   final ref = FirebaseStorage.instance
  //       .ref()
  //       .child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //   final uploadTask = ref.putFile(file);
  //   final snapshot = await uploadTask.whenComplete(() {});
  //   final imageUrls = await snapshot.ref.getDownloadURL();

  //   final user = FirebaseAuth.instance.currentUser;
  //   final userData = {
  //     'imageUrls': imageUrls,
  //   };
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user?.uid)
  //       .update(userData);
  // }

  Future<void> _fetchUserData() async {
    final userData = await UserService().getUserData();
    //_bioController.text = userData.bio;
    _imageUrls = userData.imageUrls;
    setState(() {});
  }

  void _handleUpload(
      int age, String _firstName, String _lastName, String? imagePath) async {
    // print("this is imagepath");
    // print(imagePath);
    void errorMessagePopup(String message) {
      // print('Sign In button pressed');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text(
                  "ERROR",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                content: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 19,
                    fontFamily: 'Sk-Modernist',
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Sk-Modernist',
                        color: Color(0xFFBB254A),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    }

    final user = FirebaseAuth.instance.currentUser;
    if (_firstName == "" || _lastName == "") {
      errorMessagePopup("Some field is empty.");
      if (_firstName == "") {
        setState(() {
          _firstNameError = _firstName == "";
        });
      }
      if (_lastName == "") {
        setState(() {
          _lastNameError = _lastName == "";
        });
      }
    } else {
      if (imagePath == null) {
        errorMessagePopup("Please Add your image.");
        setState(() {
          _imageError = imagePath == "";
          // _lastNameError = _lastName == "";
        });
      } else {
        if (age >= 18 && age <= 50) {
          final userData = {
            'name': fullName,
            'age': age,
            'email': user?.email,
          };
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .update(userData);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } catch (e) {
            print("age is not in range of 18 to 50");
          }
        } else {
          errorMessagePopup("Age is not in range of 18 to 50");
        }
      }
    }
  }

  bool _firstNameError = false;
  bool _lastNameError = false;
  bool _imageError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: AppBar(
            leading: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Color(0xFFE94057),
                onPressed: () {
                  widget.tabController
                      .animateTo(widget.tabController.index - 1);
                },
              ),
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => const HomeScreen()),
            //       );
            //     },
            //     child: const Text(
            //       'Skip',
            //       style: TextStyle(
            //         color: Color(0xFFE94057),
            //         fontSize: 18,
            //         fontFamily: 'Sk-Modernist',
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                width: 295,
                child: Text(
                  'Profile details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                  ),
                ),
              ),
              const SizedBox(height: 80.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120),
                          color: Colors.transparent,
                          border: Border.all(width: 2, color: Colors.white),
                          image: _imageUrls != null
                              ? DecorationImage(
                                  image: NetworkImage(_imageUrls!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                          'assets/images/profile_placeholder.png')
                                      as ImageProvider,
                                )),
                      child: _imageUrls == null
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 39,
                                width: 39,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFFBB254A),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  color: Colors.white,
                                  onPressed: () async {
                                    // Update user profile image
                                    final imagePath =
                                        await StorageService().pickImage();
                                    if (imagePath != null) {
                                      final imageUrls = await StorageService()
                                          .uploadImage(imagePath);
                                      await UserService().updateUserImage(
                                          imageUrls: imageUrls);
                                      _imageUrls = imageUrls;
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 60.0),
                  // First Name
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _firstName = value;
                        _firstNameError = false; // Reset error when typing
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: const TextStyle(
                        color: Colors.black45,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _firstNameError
                              ? const Color(0xFFBB254A)
                              : Colors
                                  .black12, // Change border color to red if there's an error
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _firstNameError
                              ? const Color(0xFFBB254A)
                              : Colors.black45,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _firstNameError
                              ? const Color(0xFFBB254A)
                              : Colors.black12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  // Last Name
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _lastName = value;
                        _lastNameError = false; // Reset error when typing
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(
                        color: Colors.black45,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _lastNameError
                              ? const Color(0xFFBB254A)
                              : Colors
                                  .black12, // Change border color to red if there's an error
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _lastNameError
                              ? const Color(0xFFBB254A)
                              : Colors.black45,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _lastNameError
                              ? const Color(0xFFBB254A)
                              : Colors.black12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(
                                    0xFFBB254A), // Change the primary color as needed
                                onPrimary: Colors.white,
                              ),
                              buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFf8e9ed),
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_today),
                          prefixIconColor: Color(0xFFBB254A),
                          labelText: 'Choose birthday date',
                          labelStyle: TextStyle(
                            color: Color(0xFFBB254A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        style: TextStyle(
                          color: Color(0xFFBB254A),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Sk-Modernist',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 110.0),
              ElevatedButton(
                  onPressed: () =>
                      {_handleUpload(age, _firstName, _lastName, _imageUrls)},
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
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFFFFFFF),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
