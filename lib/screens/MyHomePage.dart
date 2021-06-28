import 'package:flutter/material.dart';
import '../constants/globals.dart';
import 'package:covid_lib/services/fetchNews.dart';
import 'package:covid_lib/screens/HomeScreen.dart';
import 'package:covid_lib/screens/GraphsScreen.dart';
import 'package:covid_lib/screens/NewsScreen.dart';
import 'package:covid_lib/screens/CommentsScreen.dart';
import 'package:covid_lib/screens/CountrySelect.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    GraphsScreen(),
    NewsScreen(),
    CommentsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          newsData = fetchNews(countryName);
          break;
        case 3:
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (countryName == '') {
      return CountrySelect();
    }
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'GRAPHS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'NEWS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'COMMENTS',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        backgroundColor: Color(0xff6d6d6d),
        iconSize: 50.0,
        selectedFontSize: 15.0,
        unselectedFontSize: 15.0,
      ),
    );
  }
}
