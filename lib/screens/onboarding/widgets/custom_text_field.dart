import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.text,
    this.controller,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295,
      height: 56,
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: text,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Sk-Modernist',
            color: Color(0xFFB3B3B3),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
