import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieFromMovieDb movieDb) => Movie(
      adult: movieDb.adult,
      backdropPath: (movieDb.backdropPath != '') ? "$_imageURL${movieDb.backdropPath}" 
        : _imageNotFound,
      genreIds: movieDb.genreIds.map((e) => e.toString()).toList(),
      id: movieDb.id,
      originalLanguage: movieDb.originalLanguage,
      originalTitle: movieDb.originalTitle,
      overview: movieDb.overview,
      popularity: movieDb.popularity,
      posterPath: (movieDb.posterPath != '') ? '$_imageURL${movieDb.posterPath}'
        : _imageNotFound,
      releaseDate: movieDb.releaseDate,
      title: movieDb.title,
      video: movieDb.video,
      voteAverage: movieDb.voteAverage,
      voteCount: movieDb.voteCount
  );

  static Movie movieDetailToEntity(MovieDetails movieDetails) => Movie(
     adult: movieDetails.adult,
      backdropPath: (movieDetails.backdropPath != '') ? "$_imageURL${movieDetails.backdropPath}" 
        : _imageNotFound,
      genreIds: movieDetails.genres.map((e) => e.name).toList(),
      id: movieDetails.id,
      originalLanguage: movieDetails.originalLanguage,
        originalTitle: movieDetails.originalTitle,
        overview: movieDetails.overview,
      popularity: movieDetails.popularity,
      posterPath: (movieDetails.posterPath != '') ? '$_imageURL${movieDetails.posterPath}'
        : _imageNotFound,
      releaseDate: movieDetails.releaseDate,
      title: movieDetails.title,
      video: movieDetails.video,
      voteAverage: movieDetails.voteAverage,
      voteCount: movieDetails.voteCount
    );
}

const _imageURL = 'https://image.tmdb.org/t/p/w500';
const _imageNotFound = 'https://static.displate.com/280x392/displate/2023-11-05/14fc8d14565a3a2134f4ad62c0ef212d_52bca31461a67d5b987a3a06224b8c0b.jpg';