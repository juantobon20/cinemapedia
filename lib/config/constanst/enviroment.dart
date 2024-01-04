import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {

  static String theMovieDbApiKey = dotenv.env['THE_MOVIE_DB_API_KEY']  ?? 'No hay Api Key';
}