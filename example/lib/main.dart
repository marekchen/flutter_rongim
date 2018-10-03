import 'package:flutter/material.dart';
import 'package:flutter_rongim/flutter_rongim.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "11";
  String text2 = "22";
  String text3 = "33";
  String text4 = "44";
  String text5 = "55";
  String text6 = "66";

  setText(t) {
    setState(() {
      text = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterRongim.setRCLogInfoListener().listen((ResultCallback callback) {
      print(callback.result);
    });
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Text(text),
            RaisedButton(
              onPressed: () {
                FlutterRongim.connect(
                        "DeXCHkAUCq1+/KnE2kcjPymK9zfNTKzs1o7YBRltabb7QpIqeYzw1SbscpOT3ksI32e6F0aOrcnSu/kvvmxEPQ==")
                    .then((ConnectCallback callback) {
                  setState(() {
                    print("chenpei" + callback.isSuccess.toString());
                    if (callback.isSuccess) {
                      print(callback.toMap());
                      text = callback.toMap().toString();
                    } else {
                      print(callback.toMap());
                      text = callback.toMap().toString();
                    }
                  });
                });
              },
              child: Text("connect"),
            ),
            Text(text2),
            RaisedButton(
              onPressed: () {
                TextMessage content = TextMessage("test Text Message");
                Message message =
                    Message("chenpei2", ConversationType.PRIVATE, content);
                FlutterRongim.sendMessage(message)
                    .listen((ResultCallback callback) {
                  setState(() {
                    print("chenpei" + callback.isSuccess.toString());
                    if (callback.isSuccess) {
                      print(callback.result.toMap());
                      text2 = callback.result.toMap().toString();
                    } else {
                      print(callback.toMap());
                      text2 = callback.toMap().toString();
                    }
                  });
                });
              },
              child: Text("sendMessage"),
            ),
            Text(text3),
            RaisedButton(
              onPressed: () {
                ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                  ImageMessage content = ImageMessage(
                      thumbUri: file.uri, localUri: file.uri, isFull: false);
                  Message message =
                      Message("chenpei2", ConversationType.PRIVATE, content);
                  FlutterRongim.sendImageMessage(message)
                      .listen((ResultCallback callback) {
                    setState(() {
                      if (callback.isSuccess) {
                        print(callback.result.toMap());
                        text3 = callback.result.toMap().toString();
                      } else {
                        print(callback.toMap());
                        text3 = callback.toMap().toString();
                      }
                    });
                  });
                });
              },
              child: Text("pick-image"),
            ),
            Text(text4),
            RaisedButton(
              onPressed: () {
                ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                  FileMessage content = FileMessage(file.uri);
                  Message message =
                      Message("chenpei2", ConversationType.PRIVATE, content);
                  FlutterRongim.sendMediaMessage(message)
                      .listen((ResultCallback callback) {
                    setState(() {
                      if (callback.isSuccess) {
                        print(callback.result.toMap());
                        text4 = callback.result.toMap().toString();
                      } else {
                        print(callback.toMap().toString());
                        text4 = callback.toMap().toString();
                      }
                    });
                  });
                });
              },
              child: Text("pick-file"),
            ),
            RaisedButton(
              onPressed: () {
                FlutterRongim.clearMessagesUnreadStatus(
                        "chenpei", ConversationType.PRIVATE)
                    .then((response) {});
              },
              child: Text("clearMessagesUnreadStatus"),
            ),
            Text(text5),
            RaisedButton(
              onPressed: () {
                FlutterRongim.getConversationList([ConversationType.PRIVATE])
                    .then((ResultCallback<List<Conversation>> callback) {
                  setState(() {
                    print("chenpei" + callback.isSuccess.toString());
                    if (callback.isSuccess) {
                      print(callback.result);
                      text5 = callback.result
                          .map((conversation) => conversation.toMap())
                          .toList()
                          .toString();
                    } else {
                      print(callback.result.toString());
                      text5 = callback.result.toString();
                    }
                  });
                });
              },
              child: Text("getConversationList"),
            ),
            Text(text6),
            RaisedButton(
              onPressed: () {
                FlutterRongim.getHistoryMessages(
                        "chenpei2", ConversationType.PRIVATE, 0, 100)
                    .then((ResultCallback<List<Message>> callback) {
                  setState(() {
                    print("chenpei" + callback.isSuccess.toString());
                    if (callback.isSuccess) {
                      print(callback.result);
                      text6 = callback.result
                          .map((message) => message.toMap())
                          .toList()
                          .toString();
                    } else {
                      print(callback.result.toString());
                      text6 = callback.result.toString();
                    }
                  });
                });
              },
              child: Text("getHistoryMessages"),
            ),
          ],
        ),
      ),
    );
  }
}
