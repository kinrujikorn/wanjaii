import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;

  final String text;
  final bool isActive;

  const CustomButton({
    Key? key,
    required this.tabController,
    this.text = 'Create an account',
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 295,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            /*  if (emailController != null && passwordController != null) {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController!.text,
                password: passwordController!.text,
              );
            } */
            if (tabController.index <= 2) {
              tabController.animateTo(tabController.index + 1);
            } else {
              Navigator.pushNamed(context, '/');
            }
          },
          child: Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sk-Modernist',
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )),
        ));
  }
}
