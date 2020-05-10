import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final Function onPressed;
  ContactTile({@required this.contact, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
//              contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
      leading: Container(
//                color: Color(getColor(contact))==null?Colors.transparent:Color(getColor(contact)),
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
          child: Text(contact.initials()),
        ),
      ),
      title: Text(contact.displayName),
      children: List.generate(contact.phones.length, (index2) {
        return Padding(
          padding: const EdgeInsets.only(left: 80, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(contact.phones.elementAt(index2).value),
            ],
          ),
        );
      }),
      trailing: IconButton(icon: Icon(Icons.video_call), onPressed: onPressed),
    );
  }
}
