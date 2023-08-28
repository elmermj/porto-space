import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final String appTitle;

  const HomeScreen({super.key, required this.title, required this.appTitle});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showDirectMessageBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ) ,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDirectMessageBox = true;
                  });
                },
                child: Dismissible(
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      showDirectMessageBox = true;
                    });
                  },
                  child: const ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Open Direct Message Box'),
                  ),
                ),
              ),
              // Add more content here as desired
            ],
          ),
          if (showDirectMessageBox)
            Container(
              color: Colors.black54,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showDirectMessageBox = false;
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text('Direct Message Box'),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
