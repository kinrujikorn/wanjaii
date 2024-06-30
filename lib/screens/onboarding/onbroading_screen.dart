import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/screens/screens.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'GenderSelectionScreen'),
    Tab(text: 'InterestScreen'),
    Tab(text: 'ProfileSetupScreen'),
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final currentEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirstTime();
  }

  bool isFirsttime = false;

  Future<void> checkFirstTime() async {
    try {
      QuerySnapshot uidQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: currentEmail)
          .get();

      if (uidQuery.docs.isNotEmpty) {
        setState(() {
          isFirsttime = uidQuery.docs[0]["uid"] == "";
        });
      } else {
        // Handle case where no documents were found
        setState(() {
          isFirsttime =
              true; // Assuming default behavior is to treat it as first time
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      // Handle error gracefully
    }
  }

  @override
  // Widget build(BuildContext context) => _onBordingBuilder();
  Widget build(BuildContext context) =>
      isFirsttime ? _onBordingBuilder() : const HomeScreen();

  Widget _onBordingBuilder() {
    return DefaultTabController(
      length: OnboardingScreen.tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          body: GestureDetector(
            onHorizontalDragCancel: () {},
            child: TabBarView(
              children: [
                GenderSelectionScreen(
                    tabController: tabController,
                    onGenderSelected: (bool isWomen,
                        {bool isChooseAnother = true}) {}),
                InterestScreen(tabController: tabController),
                ProfileSetupScreen(
                  tabController: tabController,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
