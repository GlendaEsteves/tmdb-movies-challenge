import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/controller/shared_preferences.dart';
import 'package:tmdb_movies/model/movies.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movies/view/movies_builder.dart';

void main() {
  runApp(const TmdbMoviesApp());
}

class TmdbMoviesApp extends StatelessWidget {
  const TmdbMoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Movies',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'TMDB Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SharedPrefs sharedPrefs = SharedPrefs();

  late Future<List<Movies>> futureMoviesList;
  late Future<bool> isConnected;
  late Movies movieRead;
  late Future<List<Movies>> futureOfflineMoviesList;

  @override
  void initState() {
    super.initState();
    isConnected = checkInternetConnection();
    futureMoviesList = fetchMoviesList();
    futureOfflineMoviesList = loadOfflineData();
  }

  Future<List<Movies>> loadOfflineData() async {
    List<Movies> offlineMoviesList = [];
    List offlineMovies = await sharedPrefs.read('offlineMovies');
    for (var i in offlineMovies) {
      offlineMoviesList.add(Movies.fromJson(i));
    }
    return offlineMoviesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: isConnected,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data! == true) {
                return MoviesBuilder(
                  futureMoviesList: futureMoviesList,
                );
              } else if (snapshot.data! == false) {
                return MoviesBuilder(futureMoviesList: futureOfflineMoviesList);
              }
            } else if (snapshot.hasError) {
              return Text('Ocorreu o seguinte erro: ${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<Movies>> fetchMoviesList() async {
  try {
    List<Movies> moviesList = [];
    final response = await http.get(
        Uri.parse('https://desafio-mobile.nyc3.digitaloceanspaces.com/movies'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      for (var movie in list) {
        moviesList.add(Movies.fromJson(movie));
      }
      return moviesList;
    } else {
      throw Exception('Erro ao carregar filmes');
    }
  } on SocketException {
    throw Exception('Sem internet');
  }
}

Future<bool> checkInternetConnection() async {
  try {
    final response = await InternetAddress.lookup('www.google.com');
    if (response.isNotEmpty) {
      return true;
    }
    return true;
  } on SocketException {
    return false;
  }
}
