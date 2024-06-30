/* import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/screens.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
          currentIndex: index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color.fromRGBO(187, 37, 74, 1),
          unselectedItemColor: Colors.black.withAlpha(70),
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.home,
                    size: 30,
                  )),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MatchesScreen.routeName);
                },
                icon: const Icon(
                  Icons.favorite,
                  size: 30,
                ),
              ),
              label: 'Match',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.routeName);
                },
                icon: const Icon(
                  Icons.chat,
                  size: 30,
                ),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserScreen.routeName);
                },
                icon: const Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/screens.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color.fromRGBO(187, 37, 74, 1),
          unselectedItemColor: Colors.black.withAlpha(70),
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            // Navigate to the corresponding screen based on index
            switch (index) {
              case 0:
                Navigator.pushNamed(context, HomeScreen.routeName);
                break;
              case 1:
                Navigator.pushNamed(context, MatchesScreen.routeName);
                break;
              case 2:
                Navigator.pushNamed(context, ChatScreen.routeName);
                break;
              case 3:
                Navigator.pushNamed(context, UserScreen.routeName);
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: _selectedIndex == 0
                    ? const Color.fromRGBO(187, 37, 74, 1)
                    : Colors.black.withAlpha(70),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 30,
                color: _selectedIndex == 1
                    ? const Color.fromRGBO(187, 37, 74, 1)
                    : Colors.black.withAlpha(70),
              ),
              label: 'Match',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 30,
                color: _selectedIndex == 2
                    ? const Color.fromRGBO(187, 37, 74, 1)
                    : Colors.black.withAlpha(70),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
                color: _selectedIndex == 3
                    ? const Color.fromRGBO(187, 37, 74, 1)
                    : Colors.black.withAlpha(70),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
