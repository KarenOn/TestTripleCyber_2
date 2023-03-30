import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_app/screens/detail_movie_screen.dart';
import 'package:movies_app/services/movies_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiMovies _apiMovie = ApiMovies();

  List _movies = [];
  List _moviesAll = [];
  int _selectedIndex = 0;
  List<String> favoriteMovies = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future get() async {
    var result = await _apiMovie.getMovies();

    setState(() {
      _moviesAll = result;
      getValueFav();
    });
  }

  Future getValueFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMovieIds = prefs.getStringList('movieFavs') ?? [];
    _movies = _moviesAll.where((movie) => favoriteMovieIds.contains(movie['id'].toString())).toList();

    setState(() {
      favoriteMovies = favoriteMovieIds;
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Scaffold(
        body: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (ctx, index) => const SizedBox(height: 15),
          itemCount: _moviesAll.length,
          itemBuilder: (ctx, index) {
            var movie = _moviesAll[index];
            return PhysicalModel(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.local_movies_outlined),
                trailing: Column(
                  children: [
                    (favoriteMovies.contains(movie['id'].toString()) ? Icon(Icons.star) : Icon(Icons.star_border)),
                    Text('${movie['vote_average']}/10'),
                  ],
                ),
                title: Text(movie['title']),
                onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => DetailMovie(movie: _moviesAll[index]))),
              ),
            );
          },
        )
      ),
      Scaffold(
        backgroundColor: Colors.white,
        body: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (ctx, index) => const SizedBox(height: 15),
          itemCount: _movies.length,
          itemBuilder: (ctx, index) {
            var movie = _movies[index];
            return PhysicalModel(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.local_movies_outlined),
                trailing: Column(
                  children: [
                    const Icon(Icons.star),
                    Text('${movie['vote_average']}/10'),
                  ],
                ),
                title: Text(movie['title']),
                onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => DetailMovie(movie: _movies[index]))),
              ),
            );
          },
        )
      )
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: const Text('Bienvenido'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: widgetOptions.elementAt(_selectedIndex),
        )
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.amber,
              blurRadius: 10
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50)
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30)
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem> [
              BottomNavigationBarItem (
                icon: Icon(Icons.home_rounded,
                  size: 28
                ),
                label: "Todos",
              ),
              BottomNavigationBarItem (
                icon: Icon(Icons.star),
                label: "Favoritos"
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.amber,
            backgroundColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      )
    );
  }
}
