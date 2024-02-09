import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorMapNotifier, Map<String,List<Actor>>>((ref) {
  final actorRepository = ref.watch(actorRepositoryProvider);
  
  return ActorMapNotifier(
    getActorsCallback: actorRepository.getActorsByMovie
  );
});


typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorMapNotifier extends StateNotifier<Map<String,List<Actor>>> {

  final GetActorsCallback getActorsCallback;

  ActorMapNotifier({
    required this.getActorsCallback
  }): super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) {
      return;
    }

    final actors = await getActorsCallback(movieId);

    state = { ...state, movieId: actors};
  }
}