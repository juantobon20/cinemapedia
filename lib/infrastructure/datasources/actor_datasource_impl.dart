import 'package:cinemapedia/config/constanst/enviroment.dart';
import 'package:cinemapedia/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorDatasourceImp implements ActorDatasource {

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
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('movie/$movieId/credits');

    final creditResponse = CreditsResponse.fromJson(response.data);
    return creditResponse.cast.map((cast) => ActorMapper.castToEntity(cast)).toList();
  }

}