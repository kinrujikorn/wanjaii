import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/models/models.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 35,
        right: 35,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.imageUrls),
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 360,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRect(
                  clipper: _BottomClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withAlpha(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.name}, ${user.age}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sk-Modernist',
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          height: 1.2)),
                  Text('${user.jobTitle}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sk-Modernist',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, size.height * 0.3, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
