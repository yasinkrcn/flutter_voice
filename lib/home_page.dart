import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice/home_page_body.dart';
import 'package:flutter_voice/ss.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  int? numberText =
      Numbers.getNumber[Numbers.stringNumber[Random().nextInt(10)]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('voice recognasing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.yellow,
                ),
                child: Center(
                  child: Text(
                    numberText.toString(),
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 200,
            width: 200,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(
              _text,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      floatingActionButton: AvatarGlow(
        endRadius: 30,
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(
          onResult: (val) => setState(
            () {
              _text = val.recognizedWords;
              try {
                if (numberText == Numbers.getNumber[_text]) {
                  numberText = Numbers
                      .getNumber[Numbers.stringNumber[Random().nextInt(10)]];
                  print("correct");
                }
              } catch (e) {
                print("Error");
              }
              if (val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
              }
            },
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
    }
  }
}
