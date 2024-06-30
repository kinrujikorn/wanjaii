import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dating_app/models/user_model.dart';
import 'package:flutter_dating_app/widgets/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  final User user;

  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  /*  static Route route() {
    return MaterialPageRoute(
      builder: (context) => ProfileScreen(),
      settings: const RouteSettings(name: routeName),
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: NetworkImage(user.imageUrls),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChoiceButton(
                            width: 80,
                            height: 80,
                            size: 30,
                            hasGradient: false,
                            color: Color.fromRGBO(242, 113, 33, 1),
                            icon: Icons.clear_rounded,
                          ),
                          ChoiceButton(
                            width: 105,
                            height: 105,
                            size: 54,
                            hasGradient: true,
                            color: Colors.white,
                            icon: Icons.favorite,
                          ),
                          ChoiceButton(
                            width: 80,
                            height: 80,
                            size: 30,
                            hasGradient: false,
                            color: Color.fromRGBO(138, 35, 135, 1),
                            icon: Icons.star,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.name}, ${user.age} ', // Use the name variable here
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Sk-Modernist',
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${user.jobTitle}',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Sk-Modernist',
                                fontWeight: FontWeight.w600,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFE8E6EA)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.launch,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sk-Modernist',
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${user.city} ${user.state}, ${user.country}',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Sk-Modernist',
                                fontWeight: FontWeight.w600,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFE8E6EA)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sk-Modernist',
                    ),
                  ),
                  SizedBox(height: 5), // Add some vertical space between lines

                  ReadMoreText(
                    '${user.profileAbout}',
                    trimLines:
                        3, // Number of lines to display before "Read more"
                    trimMode: TrimMode.Line, // Trimming mode
                    trimCollapsedText: 'Read more',
                    // Text to show when collapsed
                    trimExpandedText:
                        ' Show less', // Text to show when expanded
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Sk-Modernist',
                        fontWeight: FontWeight.w600,
                        color: Colors.black45),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sk-Modernist',
                    ),
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 5.0, // spacing between items
                    runSpacing: 5.0, // spacing between rows
                    children: user.interests
                        .map(
                          (interest) => Container(
                            width: 108,
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.only(top: 5.0, right: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFBB254A)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sk-Modernist',
                                  color: Color(0xFFBB254A),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  //SizedBox(height: 8), // Add some vertical space between lines

                  SizedBox(height: 20), // Add some vertical space between lines
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gallery', // Use the name variable here
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sk-Modernist',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        /* width: 200,
                        height: 52, */
                        child: TextButton(
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Sk-Modernist',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE94057),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/seeAll'); // Navigate to SeeAllPage
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 180,
                    width: 120,
                    child: Stack(
                      //fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: InstaImageViewer(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(user.imageUrls),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
