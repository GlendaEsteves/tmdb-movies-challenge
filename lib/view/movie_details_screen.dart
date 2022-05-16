import 'dart:convert';
import 'dart:io';
import 'package:tmdb_movies/model/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movies/view/details_builder.dart';
import 'package:tmdb_movies/view/offline_details_builder.dart';
import '../controller/shared_preferences.dart';

/*
  Tela dos detalhes dos filmes, que recupera um json com tais informações
  através da id fornecida pela tela principal, pelo método GET
*/
class MovieDetails extends StatefulWidget {
  const MovieDetails({required this.id, Key? key}) : super(key: key);

  final int id;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieDetailsModel> futureMovieDetails;
  late Future<List<MovieDetailsModel>> futureOfflineDetails;
  SharedPrefs sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    //Futures para o FutureBuilder
    futureMovieDetails = fetchMovieDetails();
    futureOfflineDetails = loadOfflineData();
  }

  /*
    Função que carrega os dados offline, caso eles existam, e gera uma lista da
    classe de MovieDetailsModel. Ainda não está corretamente implementada.
  */
  Future<List<MovieDetailsModel>> loadOfflineData() async {
    bool save = await sharedPrefs.exists('offlineMoviesDetails');
    MovieDetailsModel auxOfflineMovie;
    List<MovieDetailsModel> listOfflineMovies = [];
    if (save == true) {
      auxOfflineMovie = MovieDetailsModel.fromJson(
          await sharedPrefs.read('offlineMoviesDetails'));
      listOfflineMovies.add(auxOfflineMovie);
      if (auxOfflineMovie !=
          MovieDetailsModel.fromJson(
              await sharedPrefs.read('offlineMoviesDetails'))) {
        var aux2OfflineMovies = MovieDetailsModel.fromJson(
            await sharedPrefs.read('offlineMoviesDetails'));
        listOfflineMovies.add(aux2OfflineMovies);
      }
      return listOfflineMovies;
    } else {
      throw Exception('Não há dados salvos');
    }
  }

  //Construção do FutureBuilder para os casos de estar online ou offline
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<MovieDetailsModel>(
          future: futureMovieDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //Salva os dados no cache caso os dados existam
              sharedPrefs.save('offlineMoviesDetails', snapshot.data!);
              return DetailsBuilder(details: snapshot.data!);
            } else if (!snapshot.hasData) {
              return OfflineDetailsBuilder(
                offlineDetails: futureOfflineDetails,
                id: widget.id,
              );
            } else if (snapshot.hasError) {
              return Text('Ocorreu o seguinte erro: ${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  //Função que recupera os dados dos detalhes dos filmes através de um método GET
  Future<MovieDetailsModel> fetchMovieDetails() async {
    try {
      final url =
          'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies/${widget.id}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return MovieDetailsModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao carregar mais informações');
      }
    } on SocketException {
      throw Exception('Sem internet');
    }
  }
}
