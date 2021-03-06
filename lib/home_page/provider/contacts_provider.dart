import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
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

  void _getContactList() async {
    await getPermissions();
    List<Contact> _contacts = [];
    List<String> _contacts2 = [];
    ContactsService.getContacts().then((value) async {
      for (var contact in value) {
//          print("DP" + contact.givenName.toString());
        if (!contacts.contains(contact) &&
            contact.givenName != null &&
            contact.phones.isNotEmpty) {
          _contacts.add(contact);
          contact.phones
              .forEach((element) => _contacts2.add(element.value.trim()));
          if (_contacts2.length >= 500) {
            _addNewContacts(_contacts, _contacts2);
            _contacts2.clear();
            _contacts.clear();
//              break;
          }
        }
      }
      if (_contacts.isNotEmpty) _addNewContacts(_contacts, _contacts2);
    });
    return;
  }

  void _addNewContacts(var _contacts, var _contactsString) async {
    print("reduce");
    List<dynamic> availContacts =
        await UserRepo.multiUserExist(_contactsString);
    for (var c in _contacts) {
//      print(c.phones);
      if (contacts.contains(c)) continue;
      for (var num in c.phones)
        if (availContacts.contains(num.value)) {
          contacts.add(c);
          print(c.toString());
          notifyListeners();
          break;
        }
    }
    return;
  }

  Future<void> getPermissions() async {
    List<PermissionGroup> permission = [PermissionGroup.contacts];
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permission);
    permissions.forEach((PermissionGroup pg, PermissionStatus ps) {
      print(pg.toString() + " " + ps.toString() + "\n");
    });
  }
}
