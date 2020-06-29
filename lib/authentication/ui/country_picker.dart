import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/country_codes_const.dart';
import 'package:video_call/common/provider/user_provider.dart';

class CountryPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Container(
        constraints: BoxConstraints(minWidth: 80,maxWidth: 150,),
        child: DropdownButtonFormField<String>(
          items: List.generate(
            countryCodes.length,
            (index) => DropdownMenuItem<String>(
              value: countryCodes[index]['dial_code'],
              child: Text(
                "${countryCodes[index]['code']}\t(${countryCodes[index]['dial_code']})",
              ),
            ),
          ),
          onChanged: (countryCode) => userProvider.countryCode = countryCode,
          value: userProvider.countryCode,
          onSaved: (code) => userProvider.countryCode = code,
          decoration: InputDecoration(
            icon: Icon(
              Icons.phone,
            ),
            contentPadding: EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }
}
