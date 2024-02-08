import 'package:cinemapedia/config/constanst/enviroment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDatasoruceImpl extends MovieDatasoruce {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key' : Enviroment.theMovieDbApiKey,
        'language' : 'es-CO'
      }
    )
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('movie/now_playing',
      queryParameters: {
        'page' : page
      }
    );

    final movieDbResponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDbResponse.results
      .where((movieDb) => movieDb.posterPath != 'no-poster')
      .map(
        (movieDb) => MovieMapper.movieDbToEntity(movieDb)
      ).toList();
    return movies;
  }
}