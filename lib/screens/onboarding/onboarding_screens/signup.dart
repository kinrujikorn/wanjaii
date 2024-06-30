import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;s
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:newwanjaii/signin.dart';
import '../../onboarding/onboarding_screens/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailValue = TextEditingController();
  final passwordValue = TextEditingController();
  final confirmPasswordValue = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFBB254A),
            ),
          );
        });

    try {
      if (passwordValue.text == confirmPasswordValue.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailValue.text.trim(), password: passwordValue.text.trim());
        _storeEmailInFirestore(emailValue.text.trim());

        Navigator.pop(context);

        await sendEmailVerification();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SignIn()),
        // );
      } else {
        Navigator.pop(context);
        errorMessagePopup("Password doesn't matched");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e);
      errorMessagePopup(e.message.toString());
    }
  }

  void errorMessagePopup(String message) {
    print('Sign In button pressed');
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
                  "Success!",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                content: const Text(
                  "Email Verification has been sent",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 200.0, // Adjust width as needed (in pixels)
              height: 100.0, // Adjust height as needed (in pixels)
            ),
            const SizedBox(height: 20),
            const Text(
              "Let's Get Started",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Sk-Modernist',
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "We are happy to see you here!",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Sk-Modernist',
                color: Color(0xFF6C6C6C),
              ),
            ),
            const SizedBox(height: 50),
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
            const SizedBox(height: 15),
            SizedBox(
              width: 295,
              height: 56,
              child: TextField(
                controller: passwordValue,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "Password",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFB3B3B3),
                    ),
                    contentPadding: const EdgeInsets.all(20.0)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 295,
              height: 56,
              child: TextField(
                controller: confirmPasswordValue,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sk-Modernist',
                      color: Color(0xFFB3B3B3),
                    ),
                    contentPadding: const EdgeInsets.all(20.0)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () async {
                  registerUser();
                  print('Sign Up button pressed');
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sk-Modernist',
                    color: Color(0xFFFFFFFF),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}

Future<void> _storeEmailInFirestore(String email) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': email,
      'uid': "" // Include email in the Firestore document
    });
  }
}
