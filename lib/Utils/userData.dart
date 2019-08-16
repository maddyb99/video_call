import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
//import 'package:experto/utils/bloc/syncDocuments.dart' as sync;

class UserData {
  static DocumentSnapshot detailsData;
  static FirebaseUser profileData;
}

//
//class Data {
//  DocumentSnapshot detailsData;
//  FirebaseUser profileData;
//}
//
//class DocumentSync extends StatefulWidget {
//  final Widget child;
//  final Data account;
//
//  DocumentSync(this.account, this.child);
//
//  @override
//  _DocumentSync createState() => _DocumentSync();
//
//  static TrueInheritedWidget of(BuildContext context) =>
//      context.inheritFromWidgetOfExactType(TrueInheritedWidget);
//}
//
//class _DocumentSync extends State<DocumentSync> {
//  Data account;
//
//  @override
//  void initState() {
//    account = widget.account;
//    syncDocument();
//    super.initState();
//  }
//
//  void syncDocument() async {
//    sync.syncDocument.getStatus.listen((newDocument) {
//      setState(() {
//        account = newDocument;
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return TrueInheritedWidget(account, widget.child);
//  }
//}
//
//class TrueInheritedWidget extends InheritedWidget {
//  final Data account;
//
//  TrueInheritedWidget(this.account, child) : super(child: child);
//
//  @override
//  bool updateShouldNotify(InheritedWidget oldWidget) => false;
//}

class Users {
  final String name, email, m;
  int mobile;

  Users({
    @required this.name,
    @required this.email,
    @required this.m,
    this.mobile = 0,
  }) {
    mobile = int.parse(m);
  }

  Map<String, dynamic> toJson() => {
        'Name': name,
        'emailID': email,
        'Mobile': mobile,
      };
}

var currentUser;
