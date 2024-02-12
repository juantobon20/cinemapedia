import 'package:cinemapedia/config/constanst/enviroment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
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

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('movie/popular',
      queryParameters: {
        'page' : page
      }
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('movie/upcoming',
      queryParameters: {
        'page' : page
      }
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('movie/top_rated',
      queryParameters: {
        'page' : page
      }
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final movieDetails = MovieDetails.fromJson(response.data);
    return MovieMapper.movieDetailToEntity(movieDetails);
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
     final response = await dio.get('search/movie',
      queryParameters: {
        'query' : query,
        'page' : page
      }
    );

    return _jsonToMovies(response.data);
  }

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDbResponse.results
      .where((movieDb) => movieDb.posterPath != 'no-poster')
      .map(
        (movieDb) => MovieMapper.movieDbToEntity(movieDb)
      ).toList();

    return movies;
  }
}