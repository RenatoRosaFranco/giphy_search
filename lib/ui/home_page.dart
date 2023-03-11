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
  final apiNamespace = '/v1/gifs/search';
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
            'q': 'dogs',
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

    print('Initializing...');
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
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
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                    if (snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return Container();
  }
}
