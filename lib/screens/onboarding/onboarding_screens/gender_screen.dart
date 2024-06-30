import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dating_app/screens/onboarding/widgets/custom_botton.dart';

class GenderSelectionScreen extends StatefulWidget {
  final TabController tabController;
  final Function(bool, {bool isChooseAnother}) onGenderSelected;

  const GenderSelectionScreen({
    required this.tabController,
    required this.onGenderSelected,
  });

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  bool _isWomanSelected = false;
  bool _isManSelected = false;
  bool _isNotSelected = false;

  void _selectGender(bool isWoman, {bool isChooseAnother = false}) {
    setState(() {
      if (isChooseAnother) {
        _isWomanSelected = false;
        _isManSelected = false;
        _isNotSelected = true;
      } else {
        _isWomanSelected = isWoman;
        _isManSelected = !isWoman;
        _isNotSelected = false;
      }

      widget.onGenderSelected(isWoman, isChooseAnother: isChooseAnother);
    });
    // Store the selected gender in Firestore
    _storeGenderInFirestore(isWoman, isNotSelected: isChooseAnother);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(80.0),
        //   child: Padding(
        //     padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
        //     child: AppBar(
        //       leading: Container(
        //         padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        //         decoration: BoxDecoration(
        //           border: Border.all(color: Colors.black12), // Add border here
        //           borderRadius:
        //               BorderRadius.circular(15.0), // Set border radius
        //         ),
        //         child: IconButton(
        //           icon: const Icon(Icons.arrow_back_ios),
        //           color: Color(0xFFE94057),
        //           onPressed: () {
        //             widget.tabController
        //                 .animateTo(widget.tabController.index - 1);
        //           },
        //         ),
        //       ),
        //       // actions: [
        //       //   TextButton(
        //       //     onPressed: () {
        //       //       // Handle skip button press
        //       //       widget.tabController
        //       //           .animateTo(widget.tabController.index + 1);
        //       //     },
        //       //     child: const Text(
        //       //       'Skip',
        //       //       style: TextStyle(
        //       //           color: Color(0xFFE94057),
        //       //           fontSize: 18,
        //       //           fontFamily: 'Sk-Modernist',
        //       //           fontWeight: FontWeight.w600),
        //       //     ),
        //       //   ),
        //       // ],
        //     ),
        //   ),
        // ),
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 150.0),
          const SizedBox(
            width: 295,
            child: Text(
              'I am a',
              style: TextStyle(
                color: Colors.black,
                fontSize: 34,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.w700,
                height: 0.04,
              ),
            ),
          ),
          const SizedBox(height: 100.0),
          InkWell(
            onTap: () => _selectGender(true),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: _isWomanSelected ? Color(0xFFBB254A) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: _isWomanSelected
                    ? null
                    : Border.all(color: Colors.black12, width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Woman',
                      style: TextStyle(
                          color: _isWomanSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Sk-Modernist'),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.check, // Add your icon here
                      color: _isWomanSelected ? Colors.white : Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          InkWell(
            onTap: () => _selectGender(false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: _isManSelected ? Color(0xFFBB254A) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: _isManSelected
                    ? null
                    : Border.all(color: Colors.black12, width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Man',
                      style: TextStyle(
                          color: _isManSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Sk-Modernist'),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.check, // Add your icon here
                      color: _isManSelected ? Colors.white : Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          InkWell(
            onTap: () => _selectGender(false, isChooseAnother: true),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: _isNotSelected ? Color(0xFFBB254A) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: _isNotSelected
                    ? null
                    : Border.all(color: Colors.black12, width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose another',
                      style: TextStyle(
                          color: _isNotSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Sk-Modernist'),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios, // Add your icon here
                      color: _isNotSelected ? Colors.white : Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100.0),
          CustomButton(
            tabController: widget.tabController,
            text: 'Continue',
          )
        ],
      ),
    ));
  }
}

Future<void> _storeGenderInFirestore(bool isWoman,
    {bool isNotSelected = false}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String gender;
    if (isNotSelected) {
      gender = 'not specific';
    } else {
      gender = isWoman ? 'woman' : 'man';
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'gender': gender,
      'likedUsers': [],
      'uid': user.uid,
    });
  }
}
