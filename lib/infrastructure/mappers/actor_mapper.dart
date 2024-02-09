import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {

  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id, 
    name: cast.name, 
    profilePath: cast.profilePath != null 
      ? '$_imageURL${cast.profilePath}' 
      : 'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png', 
    character: cast.character
  );
}

const _imageURL = 'https://image.tmdb.org/t/p/w500';