import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/model/movie_details.dart';

/*
  Classe que constrói as informações detalhadas dos filmes
*/
class DetailsBuilder extends StatelessWidget {
  const DetailsBuilder({required this.details, Key? key}) : super(key: key);

  final MovieDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        SizedBox(
          height: 200,
          width: 100,
          child: CachedNetworkImage(
            //Salva o poster do filme em cache
            imageUrl: details.poster,
            placeholder: (context, url) => const CircularProgressIndicator(),
            //Caso haja erro em recuperar a imagem, exibe um ícone de erro
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        //Organiza o SizedBox formatado dos detalhes
        SizedBox(
          height: 350,
          width: 350,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    details.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Divider(),
                  Text(
                    details.overview,
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(),
                  Text('Genres: ${details.genres.toString()}'),
                  const Divider(),
                  Text('Release Date: ${details.releaseDate}'),
                  const Divider(),
                  Text('Rating: ${details.rating}')
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
