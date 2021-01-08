import 'dart:io';


import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';




void main() {
  runApp(DonaldTrump());
}


class DonaldTrump extends StatefulWidget {
  @override
  _DonaldTrumpState createState() => _DonaldTrumpState();
}

class _DonaldTrumpState extends State<DonaldTrump> {
  WebViewController _controller;
  bool _donaldTrump = false;
  final assetsAudioPlayer = AssetsAudioPlayer();

  void trigger() async {
    setState(() {
      _donaldTrump = true;
    });
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 1000);
    }
    assetsAudioPlayer.open(
      Audio("assets/ymca.mp3"),
    );
      }

  void readJS() async{
    String html = await _controller.evaluateJavascript("window.document.getElementsByTagName('html')[0].outerHTML;");
    if (html.contains("Donald Trump") || html.contains("Donald J. Trump")) {
      print("DONALD TRUMP DETECTED");
      trigger();
    }
    myController.text = await _controller.currentUrl();
  }

  final myController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          leading: InkWell(
              child: Image.asset('assets/trump.png'),
            onTap: () {
                FocusScope.of(context).unfocus();
                _controller.loadUrl("https://donaldtrump.com");

            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
            ),
          ],
          title: Container(
            padding: EdgeInsets.fromLTRB(0,0,0,0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: TextField(
                onTap: () {
                  myController.selection = TextSelection(baseOffset: 0, extentOffset: myController.value.text.length);
                },
                decoration: new InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                controller: myController,
                onChanged: (val) {
                  if (!val.contains("https://")) {
                    myController.text = "https://";
                  }
                  final value = TextSelection.collapsed(offset: myController.text.length);
                  myController.selection = value;
                },
                onSubmitted: (val) {
                  FocusScope.of(context).unfocus();
                  print(val);
                  setState(() {
                    _donaldTrump = false;
                    assetsAudioPlayer.stop();
                    _controller.loadUrl(val);
                  });
                },

              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: "https://www.straitstimes.com",
              onWebViewCreated: (controller) {
                _controller = controller;
                myController.text = "https://www.straitstimes.com";
              },
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onPageFinished: (_) {
                readJS();
              },
            ),
            _donaldTrump ? Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(child: InkWell(
                  onTap: () {
                    setState(() {
                _donaldTrump = false;
                Vibration.cancel();
                assetsAudioPlayer.stop();
              }
              );
                    },
                  child : Image.asset('assets/donaldtrump.gif'))),
            ): Container(),
          ],
        ),
      ),
    );;
  }
}