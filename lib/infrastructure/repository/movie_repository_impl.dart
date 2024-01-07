import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {

  final MovieDatasoruce movieDatasoruce;
  MovieRepositoryImpl(this.movieDatasoruce);
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return movieDatasoruce.getNowPlaying(page: page);
  }
}