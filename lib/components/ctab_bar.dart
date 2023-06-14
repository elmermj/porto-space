import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class CTabBar extends StatelessWidget {
  const CTabBar({
    super.key,
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorWeight: 1.5,
      labelStyle: TextStyle(fontSize: Constants.textM),
      isScrollable: true,
      tabs: tabs
    );
  }
}