import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InterestScreen extends StatefulWidget {
  final TabController tabController;

  const InterestScreen({
    required this.tabController,
  });
  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  Set<String> selectedInterests = {};
  List<String> interests = [
    'Photography',
    'Shopping',
    'Karaoke',
    'Yoga',
    'Cooking',
    'Tennis',
    'Running',
    'Art',
    'Swimming',
    'Traveling',
    'Extreme',
    'Music',
    'Drinking',
    'Video games',
  ];

  Map<String, IconData> interestIcons = {
    'Photography': Icons.camera_alt_outlined,
    'Shopping': Icons.shopping_bag_outlined,
    'Karaoke': Icons.keyboard_voice_outlined,
    'Yoga': Icons.spa_outlined,
    'Cooking': Icons.ramen_dining_outlined,
    'Tennis': Icons.sports_baseball_outlined,
    'Running': Icons.directions_run,
    'Art': Icons.color_lens_outlined,
    'Swimming': Icons.waves_outlined,
    'Traveling': Icons.landscape_outlined,
    'Extreme': Icons.sports_motorsports_outlined,
    'Music': Icons.music_note_outlined,
    'Drinking': Icons.local_bar_outlined,
    'Video games': Icons.sports_esports_outlined,
  };

  void _saveInterests() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'interests': selectedInterests.toList(),
      });
    }
  }

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
            //       widget.tabController
            //           .animateTo(widget.tabController.index + 1);
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
          padding: EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 295,
                child: Text(
                  'Your interests',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              SizedBox(
                width: 295,
                child: Text(
                  "Select a few of your interests and let everyone know what you're passionate about.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: interests
                          .sublist(0, 7)
                          .map((interest) => buildInterestItem(interest))
                          .toList(),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      children: interests
                          .sublist(7, 14)
                          .map((interest) => buildInterestItem(interest))
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.0),
              ElevatedButton(
                  onPressed: () {
                    _saveInterests();
                    widget.tabController
                        .animateTo(widget.tabController.index + 1);
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
                    'Continue',
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

  Widget buildInterestItem(String interest) {
    final bool isSelected = selectedInterests.contains(interest);
    final IconData? icon = interestIcons[interest];
    void _onTap(String interest) {
      setState(() {
        if (selectedInterests.contains(interest)) {
          selectedInterests.remove(interest);
        } else {
          selectedInterests.add(interest);
        }
      });
    }

    return GestureDetector(
      onTap: () => _onTap(interest),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        height: 50,
        width: 400,
        child: OutlinedButton(
          onPressed: null, // Remove the onPressed callback
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (states) {
                return BorderSide(
                  color: Colors.black12,
                  width: 1,
                );
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                return selectedInterests.contains(interest)
                    ? Color(0xFFBB254A) // Change to red when selected
                    : Colors.white; // Keep white when not selected
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: selectedInterests.contains(interest)
                    ? Colors.white // Change to white when selected
                    : Color(0xFFBB254A),
              ),
              SizedBox(width: 4.5),
              Text(
                interest,
                style: TextStyle(
                  color: selectedInterests.contains(interest)
                      ? Colors.white // Change to white when selected
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
