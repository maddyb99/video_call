import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

class Contacts {
  List<Contact> contacts;
  List<Contact> finalContacts;
  QuerySnapshot temp;

  Contacts() {
    contacts = List<Contact>();
  }

  Future<void> getAllContacts() async {
    Iterable<Contact> tmp;
    tmp = await ContactsService.getContacts();
//    tmp=contacts.where((c)=>c.displayName!=null&&c.phones.length!=0);
    tmp.forEach((contact) {
      print("DP" + contact.givenName.toString());
      if (contact.givenName != null && contact.phones.isNotEmpty)
        contacts.add(contact);
    });
//    contacts=tmp;
    await reduceContacts();
    print(contacts);
    print(contacts.length);
    return;
  }

  Future<void> reduceContacts() async {
    print("reduce");
    temp = await Firestore.instance.collection("Users").getDocuments();
    contacts.forEach((c) async {
      if (await isRegistered(c)) finalContacts.add(c);
//      print("final: "+finalContacts.length.toString());
    });
    return;
  }

  Future<bool> isRegistered(Contact c) async {
    c.phones.forEach((phone) {
      if (temp.documents.firstWhere((d) {
            return phone.value.compareTo(d.data["Mobile"]) == 0;
          }, orElse: () {
            return null;
          }) !=
          null)
        return true;
      return false;
    });
    return false;
  }
}
