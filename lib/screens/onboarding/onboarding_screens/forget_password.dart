import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/signin.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailValue = TextEditingController();

  void messagePopup(String type, String message, String action) {
    print('Sign In button pressed');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                type,
                style: const TextStyle(
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
                  child: Text(
                    action,
                    style: const TextStyle(
                      fontSize: 19,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFBB254A),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                ),
              ]);
        });
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    emailValue.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailValue.text.trim());
      messagePopup(
          "Success!", "Reset password email has been sent to your email", "OK");
    } on FirebaseAuthException catch (e) {
      messagePopup("ERROR!", e.message.toString(), "Cancel");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            const Image(
              image: AssetImage('assets/images/password.png'),
              width: 200.0, // Adjust width as needed (in pixels)
              height: 100.0, // Adjust height as needed (in pixels)
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Trouble Logging In?",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 10.0),

            const Text(
              "Enter your email and we'll send you",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Sk-Modernist',
                color: Color(0xFF6C6C6C),
              ),
            ),

            const Text(
              "a link to get back to your account.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Sk-Modernist',
                color: Color(0xFF6C6C6C),
              ),
            ),
            const SizedBox(height: 20.0),

            SizedBox(
              width: 295,
              height: 56,
              child: TextField(
                controller: emailValue,
                keyboardType: TextInputType.emailAddress,
                // onSaved: (String email) {
                //   profile.email = email;
                // },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "Enter Email",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFB3B3B3),
                    ),
                    contentPadding: const EdgeInsets.all(20.0)),
              ),
            ),
            const SizedBox(
                height: 20.0), // Add spacing between field and button
            ElevatedButton(
                onPressed: () {
                  passwordReset();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFBB254A)), // Change button color
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(295, 56)), // Set button width and height
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Set border radius here
                    ),
                  ),
                ),
                child: const Text(
                  'Reset Password',
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
    );
  }
}
