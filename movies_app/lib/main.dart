import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(), // pantalla de Splash
      '/home': (context) => Home(), // pantalla de Home
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterSeconds: Home(),
      gradientBackground: const LinearGradient(colors: [Colors.amber, Colors.amberAccent],
        begin: Alignment(-1.0, -1),
        end: Alignment(-1.0, 1),
      ),
      seconds: 3,
      title: const Text('Movies App',
        style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
      ),
      useLoader: true,
      // loadingText: CircularProgressIndicator(),
      //   style: TextStyle(
      //       fontSize: 28,
      //       // color: Colors.white,
      //       fontWeight: FontWeight.bold
      //   ),
      // ),
      loaderColor: Colors.white,
    );

    //   Scaffold(
    //   body: Column(
    //     children: [
    //       ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context).push(
    //                 MaterialPageRoute(builder: (context) => const Home()));
    //           },
    //
    //           child: const Text('Ir a Home'))
    //     ],
    //   ),
    // );
  }
}
