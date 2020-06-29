import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/common/provider/notif_provider.dart';
import 'package:video_call/common/resource/notification_manager.dart';
import 'package:video_call/common/ui/floating_action_button.dart';
import 'package:video_call/home_page/provider/contacts_provider.dart';
import 'package:video_call/home_page/ui/contact_tile.dart';
import 'package:video_call/video_call/init.dart';

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
    NotificationManger.init(context: context);
    var contactsProvider = Provider.of<ContactsProvider>(context);
    var notificationProvider=Provider.of<NotificationProvider>(context);
    return ChangeNotifierProvider.value(
      value: contactsProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Call"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              contactsProvider.contacts.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => ContactTile(
                          contact: contactsProvider.contacts[index],
                          onPressed: () {
                            startVideo = StartVideo();
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return startVideo;
                                },
                              ),
                            );
                          },
                        ),
                        itemCount: contactsProvider.contacts.length,
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FAB(),
      ),
    );
  }
}
