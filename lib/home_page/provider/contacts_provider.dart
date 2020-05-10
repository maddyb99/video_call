import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/common/resource/user_repository.dart';

class ContactsProvider extends ChangeNotifier {
  ContactsProvider() {
    clear();
    _getContactList();
  }

  List<Contact> contacts;

  reloadData() {
//    clear();
    _getContactList();
  }

  void clear({bool notify = true}) {
    contacts = [];
    if (notify) notifyListeners();
  }

  void _getContactList() {
    List<Contact> _contacts = [];
    List<String> _contacts2 = [];
    ContactsService.getContacts().then((value) async {
      value.forEach(
        (contact) {
          print("DP" + contact.givenName.toString());
          if (contact.givenName != null && contact.phones.isNotEmpty) {
            _contacts.add(contact);
            contact.phones.forEach((element) => _contacts2.add(element.value));
//            _contacts2.add(value)
          }
        },
      );
      print(_contacts2);
      _addNewContacts(_contacts, _contacts2);
//      print(_contacts);
//      print(_contacts.length);
    });
//    tmp=contacts.where((c)=>c.displayName!=null&&c.phones.length!=0);

//    contacts=tmp;
    return;
  }

  void _addNewContacts(var _contacts, var _contactsString) async {
    print("reduce");
    List<dynamic> availContacts =
        await UserRepo.multiUserExist(_contactsString);
    for (var c in _contacts) {
      print(c.phones);
      if (contacts.contains(c)) continue;
      for (var num in c.phones)
        if (availContacts.contains(num.value)) {
          contacts.add(c);
          notifyListeners();
          break;
        }
//      print("final: "+finalContacts.length.toString());
    }
    return;
  }
}
