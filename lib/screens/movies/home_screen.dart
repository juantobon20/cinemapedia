import 'package:cinemapedia/config/constanst/enviroment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const name = "HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Enviroment.theMovieDbApiKey),
      ),
    );
  }
}