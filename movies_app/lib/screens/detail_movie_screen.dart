import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailMovie extends StatefulWidget {
  final Map<String, dynamic> movie;

  const DetailMovie({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailMovie> createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {

  List<String> favoriteMovies = [];

  getFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('movieFavs') ?? [];

    setState(() {
      favoriteMovies = favoriteIds;
    });
  }

  @override void initState() {
    super.initState();
    getFavoriteMovies();
  }


  @override
  Widget build(BuildContext context) {

    void mostrarAlerta(String titulo, icon) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: icon,
            title: Text(titulo),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: Text(widget.movie['title']),
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: 500,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w500/${widget.movie['poster_path']}')
                )
              )
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.movie['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<String> favoriteIds = prefs.getStringList('movieFavs') ?? [];

                        if(favoriteIds.contains(widget.movie['id'].toString())){
                          mostrarAlerta('Película removida de favoritos', Icon(Icons.star_border));
                          favoriteIds.removeWhere((id) => id == widget.movie['id'].toString());
                          prefs.setStringList('movieFavs', favoriteIds);

                          setState(() {
                            favoriteMovies = favoriteIds;
                          });
                        } else {
                          mostrarAlerta('Película añadida a favoritos', Icon(Icons.star));
                          favoriteIds.add(widget.movie['id'].toString());

                          prefs.setStringList('movieFavs', favoriteIds);
                          setState(() {
                            favoriteMovies = favoriteIds;
                          });
                        }
                      },
                      child: (favoriteMovies.contains(widget.movie['id'].toString()) ? Icon(Icons.star) : Icon(Icons.star_border)),
                    ),
                    Text('${widget.movie['vote_average']}/10')
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Text(widget.movie['overview'],
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
