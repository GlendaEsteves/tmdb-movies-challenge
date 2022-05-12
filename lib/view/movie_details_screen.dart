import 'dart:convert';
import 'package:tmdb_movies/model/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movies/view/details_builder.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({required this.id, Key? key}) : super(key: key);

  int id;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieDetailsModel> futureMovieDetails;

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails();
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
              return DetailsBuilder(details: snapshot.data!);
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
    final url =
        'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies/${widget.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao carregar mais informações');
    }
  }
}
