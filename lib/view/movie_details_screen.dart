import 'dart:convert';
import 'dart:io';
import 'package:tmdb_movies/model/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movies/view/details_builder.dart';
import 'package:tmdb_movies/view/offline_details_builder.dart';
import '../controller/shared_preferences.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({required this.id, Key? key}) : super(key: key);

  final int id;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieDetailsModel> futureMovieDetails;
  late Future<MovieDetailsModel> futureOfflineDetails;
  SharedPrefs sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails();
    futureOfflineDetails = loadOfflineData();
  }

  Future<MovieDetailsModel> loadOfflineData() async {
    bool save = await sharedPrefs.exists('offlineMoviesDetails');
    if (save == true) {
      var offlineDetails = MovieDetailsModel.fromJson(
          await sharedPrefs.read('offlineMoviesDetails'));
      return offlineDetails;
    } else {
      throw Exception('Não há dados salvos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<MovieDetailsModel>(
          future: futureMovieDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              sharedPrefs.save('offlineMoviesDetails', snapshot.data!);
              return DetailsBuilder(details: snapshot.data!);
            } else if (!snapshot.hasData) {
              return OfflineDetailsBuilder(
                  offlineDetails: futureOfflineDetails);
            } else if (snapshot.hasError) {
              return Text('Ocorreu o seguinte erro: ${snapshot.error}');
            }
            const Text('Carregando dados');
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

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
