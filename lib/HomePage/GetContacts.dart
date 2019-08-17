import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:video_call/Utils/floating_action_button.dart';
import 'package:video_call/video_call/init.dart';

import 'GetContactsReq.dart';

class GetContacts extends StatefulWidget {
  @override
  _GetContactsState createState() => _GetContactsState();
}

class _GetContactsState extends State<GetContacts> {
  Contacts contacts;

  @override
  void initState() {
    super.initState();
    contacts = new Contacts();
    contacts.finalContacts = new List<Contact>();
    getAllContacts();
  }

  Future<void> getAllContacts() async {
    await contacts.getAllContacts();
    setState(() {});
  }

  int getColor(Contact contact) {
    int val = 0;
    contact.displayName.split('').forEach((element) {
      val = val + element.codeUnitAt(0).round();
    });
    val = val * val;
    print(val);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: contacts.contacts.length != 0
          ? List.generate(contacts.contacts.length, (index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: ExpansionTile(
//              contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                  leading: Container(
//                color: Color(getColor(contacts.contacts.elementAt(index)))==null?Colors.transparent:Color(getColor(contacts.contacts.elementAt(index))),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            spreadRadius: 0)
                      ],
                    ),
                    padding: EdgeInsets.all(0.0),
                    width: 50,
                    height: 50,
                    child: Center(
                      child:
                          Text(contacts.contacts.elementAt(index).initials()),
                    ),
                  ),
                  title: Text(contacts.contacts.elementAt(index).displayName),
                  children: List.generate(
                      contacts.contacts.elementAt(index).phones.length,
                      (index2) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 80, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(contacts.contacts
                              .elementAt(index)
                              .phones
                              .elementAt(index2)
                              .value),
                        ],
                      ),
                    );
                  }),
                  trailing: IconButton(
                      icon: Icon(Icons.video_call),
                      onPressed: () {
                        startVideo = new StartVideo();
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return startVideo;
                            },
                          ),
                        );
                      }),
                ),
              );
            })
          : [CircularProgressIndicator()],
    );
  }
}