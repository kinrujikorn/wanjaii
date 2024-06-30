import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:flutter_dating_app/screens/home/home_no_bloc.dart';
import 'package:flutter_dating_app/screens/onboarding/onbroading_screen.dart';
// import "package:newwanjaii/homepage.dart";
import '../../onboarding/onboarding_screens/create_screen.dart';
import 'dart:async';

// import "package:newwanjaii/main.dart";

class UserVerification extends StatefulWidget {
  const UserVerification({super.key});

  @override
  State<UserVerification> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerification> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      // sendEmailVerification();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      // if (isEmailVerified) {}
    });
    // if (isEmailVerified) {
    //   timer?.cancel();
    // }
  }

  Future sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      // setState(() => canResendEmail = false);
      // await Future.delayed(const Duration(seconds: 5));
      // setState(() => canResendEmail = true);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text(
                  "Successfully Resend!",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                content: const Text(
                  "You will be able to send again in 30 seconds.",
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Sk-Modernist',
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'OK',
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
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(e.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) =>
      isEmailVerified ? const OnboardingScreen() : _buildVerificationScaffold();

  Widget _buildVerificationScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email_outlined,
              color: Color(0xFFBB254A),
              size: 70.0,
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Verification email has been sent!",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.bold,
                color: Color(0xFFBB254A),
              ),
            ),
            const Text(
              "Please verify your email to proceed.",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.bold,
                color: Color(0xFFBB254A),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Resend verification email if user wants to retry
                    // canResendEmail ? await sendEmailVerification() : null;
                    await sendEmailVerification();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFBB254A)),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(50, 56)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Resend Verification Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sk-Modernist',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Resend verification email if user wants to retry
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Create(title: "")),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFBB254A)),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(50, 56)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sk-Modernist',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
