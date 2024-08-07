import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const HomeScreen(),
    },
  ));
}
