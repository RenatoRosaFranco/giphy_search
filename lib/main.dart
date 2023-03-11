// frozen_string_literal: true

import 'package:flutter/material.dart';
import 'package:giphy_search/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(hintColor: Colors.white),
  ));
}