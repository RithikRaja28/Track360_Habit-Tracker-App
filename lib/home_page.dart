import 'dart:async';

import 'package:candy_ai/feature_box.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechtotext = SpeechToText();
  String lastWords = '';
  @override

  //speech initialization
  void initState() {
    super.initState();
    initSpeechtoText();
  }

  Future<void> initSpeechtoText() async {
    await speechtotext.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechtotext.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechtotext.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void dispose() {
    super.dispose();
    speechtotext.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('candy.ai'),
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 20.0,
          ),
          Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/virtualassistant.jpg'),
                    )),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin:
                const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
              ),
              borderRadius:
                  BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: 'Hey there, how can I help you?',
                          hintMaxLines: 5,
                          prefixIcon: Icon(Icons.help_rounded),
                          hintStyle:
                              TextStyle(fontSize: 20, fontFamily: 'Cera Pro')),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    if (await speechtotext.hasPermission &&
                        speechtotext.isNotListening) {
                      startListening();
                    } else if (speechtotext.isListening) {
                      stopListening();
                    } else {
                      initSpeechtoText();
                    }
                  },
                  mini: true,
                  child: const Icon(Icons.mic),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(top: 10, left: 22),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Candy.ai has access to the following tools:",
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )),
          ),
          //features
          const Column(
            children: <Widget>[
              FeatureBox(
                  color: Color.fromARGB(255, 180, 245, 229) as Color,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'Write better, faster, and smarter, with ChatGPT.'),
              FeatureBox(
                  color: Color.fromARGB(255, 210, 180, 245) as Color,
                  headerText: 'DALL-E',
                  descriptionText:
                      'Generate images with DALL-E and share them with the community.'),
              FeatureBox(
                  color: Color.fromARGB(255, 239, 245, 180) as Color,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get smarter with voice commands from your voice assistant.'),
            ],
          ),
        ]),
      ),
    );
  }
}
