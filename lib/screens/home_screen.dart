import 'package:flutter/material.dart';
import 'social_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Welcome to Celestify!')),
    SocialFeedScreen(),
    Center(child: Text('Another Tab Placeholder')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Celestify'
            : _selectedIndex == 1
            ? 'Eternal Stream'
            : 'Tools'),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Celestify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Eternal Stream',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Tools',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
