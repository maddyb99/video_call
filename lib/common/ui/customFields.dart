import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String hintText, initailValue;
  final TextInputType inputType;
  final bool isPassword, isSignUp;
  final void Function(String) fn;
  final VoidCallback func;
  final int minLines, maxLines, maxLength;
  final TextInputAction inputAction;
  final FocusNode nextTextField, focusNode;
  static String password;
  final IconData prefix;
  final Widget suffix;
  final double elevation;
  final GlobalKey<FormState> key;
  final TextCapitalization textCapitalization;

  InputField(
    this.hintText,
    this.fn, {
    this.elevation,
    this.key,
    this.inputType,
    this.isPassword: false,
    this.minLines: 1,
    this.maxLines: 2,
    this.inputAction,
    this.maxLength:0,
    this.initailValue,
    this.focusNode,
    this.nextTextField,
    this.func,
    this.isSignUp = false,
    this.prefix,
    this.suffix,
    this.textCapitalization: TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
//    print(elevation);
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: TextFormField(
        textCapitalization: textCapitalization,
        key: key,
        obscureText: isPassword,
        focusNode: focusNode,
        initialValue: initailValue,
        textInputAction: inputAction,
        keyboardType: inputType,
        minLines: minLines,
        maxLines: isPassword ? 1 : maxLines,
//        maxLength: (maxLength == 0) ? null : maxLength,
        onSaved: (input) => fn(input),
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: prefix == null
              ? prefix
              : Icon(
                  prefix,
                  size: 20,
                ),
          suffixIcon:  suffix,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'please enter this field';
          }
//          print(value.length);
//          print(maxLength);
          if (maxLength != 0 && value.length > maxLength) {
            return 'max length exceeded';
          }
          if (isSignUp && isPassword && hintText == "Password")
            password = value;
          else if (isSignUp && isPassword && value != password)
            return 'Passwords don\'t match';
          return null;
        },
        onEditingComplete: () {
          if (inputAction == TextInputAction.done) func();
        },
        onFieldSubmitted: (nextTextField == null)
            ? null
            : (_) {
                FocusScope.of(context).requestFocus(nextTextField);
              },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;

  CustomCard({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}

class CustomCardTitle extends StatelessWidget {
  final String title;

  CustomCardTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textScaleFactor: 1.5,
          )
        ],
      ),
    );
  }
}
