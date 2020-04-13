import 'package:flutter/material.dart';
import 'package:video_call/common/ui/customFields.dart';

class ProfileInput extends StatefulWidget{
  final Function back;
  ProfileInput({this.back});
  @override
  _ProfileInputState createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return Container(
          margin: EdgeInsets.only(
            top: constraints.maxHeight / 10,
            bottom: constraints.maxHeight / 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Enter Details:'),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.4,
                    child: InputField('Enter OTP', (str) {}),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text('Cancel'),
                  ),
                  BackButton(
                    onPressed: widget.back,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}