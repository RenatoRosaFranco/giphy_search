// frozen_string_literal: true

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiHost      = 'api.giphy.com';
  final apiNamespace = 'v1/gifs/search';
  final apiKey       = 'kL0szuzHnMiMJ9VzJTqQs46xarkNeuJA';

  String? _search;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
        Uri(
          scheme: 'https',
          host: apiHost,
          path: apiNamespace,
          queryParameters: {
            'lang': 'en',
            'api_key': apiKey,
            'offset': '0',
            'rating': 'g'
          }
        )
      );
    }
    else {
      response = await http.get(
        Uri(
          scheme: 'https',
          host: apiHost,
          path: apiNamespace,
          queryParameters: {
            'q': _search,
            'api_key': apiKey,
            'offset': '0',
            'rating': 'g'
          }
        )
      );
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) => {
      print(map)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise Aqui!',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white
                  )
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
