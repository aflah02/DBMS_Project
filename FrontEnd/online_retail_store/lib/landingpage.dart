import 'package:flutter/material.dart';
import 'cart.dart';
import 'feed.dart';

class LandingPage extends StatefulWidget {
  final String uName;
  const LandingPage({Key? key, required this.uName}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late String _username;
  @override
  void initState() {
    super.initState();
    _username = widget.uName;

    print(_username);
    screens = [
      Feed(t: _username),
      Center(
        child: Text('Screen2'),
      )
    ];
  }

  var screens = [];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: SizedBox(
          height: 89,
          child: BottomNavigationBar(
            onTap: (newIndex) {
              setState(() {
                index = newIndex;
              });
            },
            currentIndex: index,
            backgroundColor: Colors.teal,
            selectedItemColor: Colors.white,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            iconSize: 24,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chair),
                label: 'Chair',
              ),
            ],
          ),
        ));
  }
}