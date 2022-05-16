import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/view/movie_details_screen.dart';
import '../model/movies.dart';

/*
  Classe que constrói as cards dos filmes, através da lista fornecida pela API
*/

class MovieCards extends StatelessWidget {
  const MovieCards({required this.list, Key? key}) : super(key: key);

  final List<Movies> list;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(children: [
              ListTile(
                leading: SizedBox(
                  height: 40,
                  width: 40,
                  child: CachedNetworkImage(
                    //Salva os posters dos filmes em cache
                    imageUrl: list[index].poster,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        /*
                      Caso haja um erro em recuperar o poster do filme, retorna
                      um icone de erro no local
                    */
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(list[index].title),
                trailing: IconButton(
                    /*
                      Botão que leva para a página de detalhes de cada filme,
                      usando a id como parâmetro para recuperar os detalhes do
                      filme selecionado
                    */
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetails(id: list[index].id)));
                    }),
              ),
            ]),
          );
        },
      ),
    );
  }
}
