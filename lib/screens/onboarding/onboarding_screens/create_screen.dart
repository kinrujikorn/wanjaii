import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/signin.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/signup.dart';
import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/verification.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Create extends StatefulWidget {
  final String title;
  //final TabController tabController;

  Create({
    Key? key,
    required this.title,
    //required this.tabController,
  }) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  // late PageController _pageController;
  int currentIndex = 0;
  final controller = CarouselController();
  double pageValue = 0.0;
  late List<Map<String, dynamic>> rawData;
  late List photo;
  int activeIndex = 0;
  final displayPhoto = [
    Image.asset('assets/images/girl1.png'),
    Image.asset('assets/images/girl2.png'),
    Image.asset('assets/images/girl3.png')
  ];

  final List<String> text1 = ["Algorithm", "Matches", "Premium"];
  final List<String> text2 = [
    "Users going through a vetting process to",
    "We match you with people that have a",
    "Sign up today and enjoy the first month"
  ];
  final List<String> text3 = [
    "ensure you never match with bots.",
    "large array of similar interests.",
    "of premium benefits on us."
  ];

  @override
  void initState() {
    super.initState();

    // rawData = [
    //   {
    //     'image': 'assets/girl1.png',
    //     'index': 1,
    //   },
    //   {
    //     'image': 'assets/girl2.png',
    //     'index': 2,
    //   },
    //   {
    //     'image': 'assets/girl3.png',
    //     'index': 3,
    //   },
    // ];
    // photo = rawData.map((data) => data["image"]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),

          SingleChildScrollView(
            child: CarouselSlider(
                // carouselController: controller,
                // itemCount: photo.length,
                // itemBuilder: (context, index, realIndex) {
                //   final urlImage = photo[index];
                //   return buildImage(urlImage, index);
                // },
                options: CarouselOptions(
                    height: 350,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                    aspectRatio: 8.0,
                    viewportFraction: 0.6, // Adjust this to show 3 images
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index)),
                items: displayPhoto),
          ),

          // const Text(
          //   "Algorithm",
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //     fontFamily: 'Sk-Modernist',
          //     color: Color(0xFFBB254A),
          //   ),
          // ),
          buildTextList(text1, text2, text3, activeIndex),
          const SizedBox(height: 40),
          buildIndicator(),
          const SizedBox(height: 40),
          // const SizedBox(height: 2),
          // const Text(
          //   'Users going through a vetting process to ',
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontFamily: 'Sk-Modernist',
          //     color: Color(0xFF323755),
          //   ),
          // ),
          // const Text(
          //   'ensure you never match with bots. ',
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontFamily: 'Sk-Modernist',
          //     color: Color(0xFF323755),
          //   ),
          // ),
          // const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp()),
              );
              print('Create Account button pressed');
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFBB254A)),
              minimumSize: MaterialStateProperty.all<Size>(const Size(295, 56)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sk-Modernist',
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Sk-Modernist',
                  color: Color(0xFF323755),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Sk-Modernist',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE94057),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const WormEffect(
            dotWidth: 10, dotHeight: 10, activeDotColor: Color(0xFFE94057)),
        activeIndex: activeIndex,
        count: displayPhoto.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String photo, int index) =>
    Container(child: Image.network(photo, fit: BoxFit.cover));

Widget buildTextList(List<String> text1, List<String> text2, List<String> text3,
    int activeIndex) {
  return ListView.builder(
    itemCount: 1,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return Column(
        children: [
          Text(
            text1[activeIndex],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sk-Modernist',
              color: Color(0xFFBB254A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text2[activeIndex],
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Sk-Modernist',
              color: Color(0xFF323755),
            ),
          ),
          Text(
            text3[activeIndex],
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Sk-Modernist',
              color: Color(0xFF323755),
            ),
          ),
        ],
      );
    },
  );
}
