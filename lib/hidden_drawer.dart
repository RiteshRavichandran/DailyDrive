import 'package:daily_drive/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Daily Drive',
              baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.white,
          ),
          HomePage()),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
        screens: _pages,
        backgroundColorMenu: Colors.green.shade400,
        backgroundColorAppBar: Colors.green,
        initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 20,
    );
  }
}
