import 'package:flutter/material.dart';
import 'package:video_call/Utils/floating_action_button.dart';

import 'GetContacts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetContacts(),
      ),
      floatingActionButton: FAB(),
    );
  }
}
