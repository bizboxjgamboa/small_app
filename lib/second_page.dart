import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? _dogImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDogImage();
  }

  Future<void> fetchDogImage() async {
    try {
      final response =
          await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _dogImageUrl = data['message'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load dog image');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: fetchDogImage,
                child: const Text('Fetch Another Dog'),
              ),
            ],
          ),
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _dogImageUrl != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child:
                                Image.network(_dogImageUrl!, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const Text('Failed to load image. Please try again.'),
          ),
        ],
      ),
    );
  }
}
