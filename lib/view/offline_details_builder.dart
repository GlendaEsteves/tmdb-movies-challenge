import 'package:flutter/material.dart';
import 'package:tmdb_movies/model/movie_details.dart';
import 'details_builder.dart';

/*
  Classe que constrói os detalhes dos filmes através de um FutureBuilder, 
  em caso do dispositivo estar offline
*/

class OfflineDetailsBuilder extends StatefulWidget {
  const OfflineDetailsBuilder(
      {required this.id, required this.offlineDetails, Key? key})
      : super(key: key);

  final Future<List<MovieDetailsModel>> offlineDetails;
  final int id;

  @override
  State<OfflineDetailsBuilder> createState() => _MovieDetailsBuilderState();
}

class _MovieDetailsBuilderState extends State<OfflineDetailsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<MovieDetailsModel>>(
        future: widget.offlineDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data![i].id == widget.id) {
                /*
                  Checa se a id do filme selecionado bate com alguma id da lista
                  de ids salvas em cache
                */
                return DetailsBuilder(details: snapshot.data![i]);
              } else {
                return const Text('Ocorreu algum erro ao salvar os dados');
              }
            }
          } else if (snapshot.hasError) {
            return Text('Ocorreu o seguinte erro: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
