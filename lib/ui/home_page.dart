// frozen_string_literal: true

import 'package:flutter/material.dart';
import 'package:giphy_search/ui/gif_page.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageLimit    = '19';
  final apiHost      = 'api.giphy.com';
  final apiNamespace = '/v1/gifs/search';
  final apiKey       = 'kL0szuzHnMiMJ9VzJTqQs46xarkNeuJA';

  String? _search;
  int _offSet = 0;

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
            'limit': pageLimit,
            'offset': _offSet.toString(),
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
            'limit': pageLimit,
            'offset': _offSet.toString(),
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
           Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
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
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offSet = 0;
                });
              },
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
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: Image.network(
                snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                fit: BoxFit.cover,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GifPage(snapshot.data['data'][index]))
                );
              },
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text('Carregar mais...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offSet += 19;
                });
              },
            );
          }
        }
    );
  }
}
