import 'dart:async';
import 'package:candy_ai/feature_box.dart';
import 'package:candy_ai/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      _initSpeech();
    } else {
      print("Microphone permission not granted.");
    }
  }

  Future<void> _initSpeech() async {
    bool available = await _speechToText.initialize(
      onError: (val) => print('Error: $val'),
      onStatus: (val) => print('Status: $val'),
    );
    if (available) {
      setState(() => _speechEnabled = true);
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  Future<void> _startListening() async {
    if (_speechEnabled && !_speechToText.isListening) {
      await _speechToText.listen(onResult: _onSpeechResult).catchError((error) {
        print("Error starting to listen: $error");
      });
      setState(() {});
    }
  }

  Future<void> _stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
      setState(() {});
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('candy.ai'),
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
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
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualassistant.jpg'),
                    ),
                  ),
                ),
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
                  const SizedBox(
                    width: 20,
                    child: Icon(
                      Icons.help_outlined,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _lastWords.isEmpty
                            ? 'Hey there, how can I help you?'
                            : _lastWords,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Cera Pro',
                          color: Colors.grey,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (await Permission.microphone.request().isGranted) {
                        if (_speechToText.isListening) {
                          await  openAIService.isArtPromptAPI(_lastWords);
                          await _stopListening();
                        } else {
                          await _startListening();
                        }
                      } else {
                        print("Microphone permission not granted.");
                      }
                    },
                    mini: true,
                    child: Icon(
                        _speechToText.isListening ? Icons.mic : Icons.mic_none),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.only(top: 10, left: 22),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Candy.ai has access to the following tools :",
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Features
            const Column(
              children: <Widget>[
                FeatureBox(
                  color: Color.fromARGB(255, 180, 245, 229),
                  headerText: 'ChatGPT',
                  descriptionText:
                      'Write better, faster, and smarter, with ChatGPT.',
                ),
                FeatureBox(
                  color: Color.fromARGB(255, 210, 180, 245),
                  headerText: 'DALL-E',
                  descriptionText:
                      'Generate images with DALL-E and share them with the community.',
                ),
                FeatureBox(
                  color: Color.fromARGB(255, 239, 245, 180),
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get smarter with voice commands from your voice assistant.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
