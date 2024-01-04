import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasoruce {

  Future<List<Movie>> getNowPlaying({ int page = 1 });
}