import 'package:flutter/material.dart';
import 'package:tmdb_movies/controller/shared_preferences.dart';

import 'cards.dart';
import '../model/movies.dart';

/*
  Classe que constrói a lista de filmes através de um FutureBuilder, em caso
  do dispositivo estar online
*/
class MoviesBuilder extends StatefulWidget {
  const MoviesBuilder({required this.futureMoviesList, Key? key})
      : super(key: key);

  final Future<List<Movies>> futureMoviesList;

  @override
  State<MoviesBuilder> createState() => _MoviesBuilderState();
}

class _MoviesBuilderState extends State<MoviesBuilder> {
  SharedPrefs sharedPrefs = SharedPrefs();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movies>>(
      future: widget.futureMoviesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          sharedPrefs.save('offlineMovies', snapshot.data!);
          return MovieCards(list: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Ocorreu o seguinte erro: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
