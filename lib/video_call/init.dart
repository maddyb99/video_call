import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_call/common/private/agora_sdk_constants.dart';
import 'package:video_call/common/ui/floating_action_button.dart';
import 'package:video_call/video_call/ui/bottom_buttons.dart';

class StartVideo extends StatefulWidget {
//  final Data user;

//  StartVideo({@required this.user});

  @override
  _StartVideoState createState() => _StartVideoState();
}

class _StartVideoState extends State<StartVideo> {
//  _StartVideoState({@required this.user});

//  final Data user;
  bool _isInChannel = false, _toggleView = true;

  final _infoStrings = <String>[];
  bool speaker = true, mic = false, camera = true, _buttonState = true;
  final _sessions = List<VideoSession>();
  RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    _addRenderView(0, (viewId) {
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
    });
    timer = RestartableTimer(Duration(seconds: 5), () {
      setState(() {
        _buttonState = !_buttonState;
      });
    });
    _toggleChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
//      SingleChildScrollView(child: _viewRows()),
          Stack(
        children: _viewRows() +
            [
              _buttonState
                  ? Positioned(
                      child: FlatButton(
                          shape: CircleBorder(),
                          onPressed: () {
//                            AgoraRtcEngine.disableVideo();
//                            AgoraRtcEngine.stopPreview();
                            Navigator.of(context).pop();
                          },
                          color: Color.fromARGB(100, 255, 227, 242),
                          child: Icon(Icons.keyboard_arrow_down)),
                      top: 35.0,
                      left: -10.0,
                    )
                  : SizedBox()
            ],
        alignment: AlignmentDirectional.bottomEnd,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buttonState
          ? FloatingActionButton(
              heroTag: "ad",
              onPressed: () {
                timer.reset();
                _toggleChannel();
                startVideo = null;
                Navigator.of(context).pop();
//                stateChangedInformNotification(false);
              },
              child: Icon(Icons.call_end),
              backgroundColor: Colors.red,
            )
          : null,
      extendBody: true,
      bottomNavigationBar: _buttonState
          ? Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  BottomButton(
                    icon: Icons.speaker_phone,
                    highlight: speaker,
                    func: () async {
                      setState(() {
                        speaker = !speaker;
                        timer.reset();
                      });
                      AgoraRtcEngine.setEnableSpeakerphone(speaker);
                    },
                  ),
                  BottomButton(
                    icon: Icons.mic_off,
                    highlight: mic,
                    func: () async {
                      setState(() {
                        mic = !mic;
                        timer.reset();
                      });
                      AgoraRtcEngine.enableLocalAudio(!mic);
                    },
                  ),
                  BottomButton(
                    icon: camera ? Icons.camera_rear : Icons.camera_front,
                    highlight: false,
                    func: () async {
                      setState(() {
                        camera = !camera;
                        timer.reset();
                      });
                      AgoraRtcEngine.switchCamera();
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(AgoraSdkInfo.appId);
    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _addRenderView(uid, (viewId) {
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
        });
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _removeRenderView(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  void _toggleChannel() async {
    //TODO: insert unique identifier from userdata
    print("phone" + (10000000000).toString());
    if (_isInChannel) {
      _isInChannel = false;
      AgoraRtcEngine.leaveChannel();
      AgoraRtcEngine.stopPreview();
    } else {
      _isInChannel = true;
      AgoraRtcEngine.startPreview();
      bool status = await AgoraRtcEngine.joinChannel(
          null,
          "notdemo",
          null,
          //TODO: insert unique identifier from userdata
          10000000000);
      print(status);
    }
    setState(() {});
  }

  List<Widget> _viewRows() {
    print("view rows");
    List<Widget> views = _getRenderViews();
    List<Widget> expandedViews = List<Widget>();
    print(views.length);
    if (views.length > 2) {
      views.forEach((view) {
        expandedViews.add(Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(100, 100, 100, 1.0),
              border: Border.all(color: Colors.red)),
          child: view,
        ));
      });
      return [
        InkWell(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,

//            scrollDirection: Axis.horizontal,
            itemCount: expandedViews.length,
            itemBuilder: (BuildContext context, int index) => Material(
              elevation: 1.0,
              child: expandedViews[index],
            ),
            staggeredTileBuilder: (int index) {
              if (expandedViews.length > 4)
                return StaggeredTile.count(
                    1, (expandedViews.length % 2 == 1.0 && index == 0 ? 2 : 1));
              else
                return StaggeredTile.count(
                    (expandedViews.length % 2 == 1.0 && index == 0) ? 2 : 1,
                    1.5);
            },
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          onTap: () {
            timer.reset();
            setState(() {
              _buttonState = !_buttonState;
              if (_buttonState)
                timer.reset();
              else
                timer.cancel();
            });
          },
        )
      ];
    } else if (views.length == 2) {
      expandedViews
          .add(Container(child: views[views.length - (_toggleView ? 1 : 2)]));
      expandedViews.add(InkWell(
        onTap: () {
          timer.reset();
          setState(() {
            _buttonState = !_buttonState;
            if (_buttonState)
              timer.reset();
            else
              timer.cancel();
          });
        },
        onDoubleTap: () async {
          if (_toggleView) return;
          setState(() {
            camera = !camera;
          });
          AgoraRtcEngine.switchCamera();
        },
        child: SizedBox(
          height: 700,
          width: 400,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ));
      expandedViews.add(
        Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(bottom: _buttonState ? 60 : 20, right: 20.0),
              child: Container(
                  height: 150,
                  width: 110,
                  child: views[views.length - (_toggleView ? 2 : 1)]),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _toggleView = !_toggleView;
                });
              },
              onDoubleTap: () async {
                if (!_toggleView) return;
                setState(() {
                  camera = !camera;
                });
                AgoraRtcEngine.switchCamera();
              },
              child: SizedBox(
                height: 130,
                width: 60,
              ),
            )
          ],
        ),
      );
      return expandedViews;
    } else if (views.length != 0) {
      expandedViews.add(Container(
          child: _toggleView
              ? Center(
                  child: Text("Reconnecting..."),
                )
              : views[0]));

      expandedViews.add(InkWell(
        onTap: () {
          timer.reset();
          setState(() {
            _buttonState = !_buttonState;
            if (_buttonState)
              timer.reset();
            else
              timer.cancel();
          });
        },
        onDoubleTap: () async {
          if (_toggleView) return;
          setState(() {
            camera = !camera;
          });
          AgoraRtcEngine.switchCamera();
        },
        child: SizedBox(
          height: 700,
          width: 400,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ));
      expandedViews.add(
        Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    bottom: _buttonState ? 70 : 20.0, right: 20.0),
                child: Container(
                    height: 150,
                    width: 110,
                    color: Colors.white,
                    padding: EdgeInsets.all(0.0),
                    child: _toggleView
                        ? views[0]
                        : Center(
                            child: Text("Reconnecting..."),
                          ))),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _toggleView = !_toggleView;
                });
              },
              onDoubleTap: () async {
                if (!_toggleView) return;
                setState(() {
                  camera = !camera;
                });
                AgoraRtcEngine.switchCamera();
              },
              child: SizedBox(
                height: 130,
                width: 60,
              ),
            )
          ],
        ),
      );
      return expandedViews;
    } else
      return null;
  }

  void _addRenderView(int uid, Function(int viewId) finished) {
    Widget view = AgoraRtcEngine.createNativeView((viewId) {
      _getVideoSession(uid).viewId = viewId;
      if (finished != null) {
        finished(viewId);
      }
    });
    VideoSession session = VideoSession(uid, view);
    _sessions.add(session);
  }

  void _removeRenderView(int uid) {
    VideoSession session = _getVideoSession(uid);
    if (session != null) {
      _sessions.remove(session);
    }
    AgoraRtcEngine.removeNativeView(session.viewId);
  }

  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

//  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

//  Widget _buildInfoList() {
//    return ListView.builder(
//      padding: const EdgeInsets.all(8.0),
//      itemExtent: 24,
//      itemBuilder: (context, i) {
//        return ListTile(
//          title: Text(_infoStrings[i]),
//        );
//      },
//      itemCount: _infoStrings.length,
//    );
//  }
}

class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}
