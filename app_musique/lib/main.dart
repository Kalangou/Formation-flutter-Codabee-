import 'dart:async';
import 'package:flutter/material.dart';
import 'musique.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de musique',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(title: 'Lecteur MP3'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Musique> maListeDeMusiques = [
    Musique("Sourate Fathia", "A. Soudais", 'assets/coran.jpg',
        "https://www.codabee.com/wp-content/uploads/2018/06/un.mp3"),
    Musique("Sourate Nass", "A. Soudais", 'assets/coran.jpg',
        "https://www.codabee.com/wp-content/uploads/2018/06/deux.mp3"),
  ];

  late StreamSubscription positionSub;
  late StreamSubscription stateSub;
  late AudioPlayer audioPlayer;
  late Musique maMusiqueActuelle;
  Duration position = Duration(seconds: 0);
  Duration duree = Duration(seconds: 0);
  PlayerState statut = PlayerState.stopped;

  // Au demarrage, le state par defaut à relancer
  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListeDeMusiques[0];
    configurationAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(widget.title),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              elevation: 10.0,
              child: Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset(
                  maMusiqueActuelle.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            textStyliser(maMusiqueActuelle.titre, 1.5),
            textStyliser(maMusiqueActuelle.artiste, 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bouton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                bouton(
                    (statut == PlayerState.playing)
                        ? Icons.pause
                        : Icons.play_arrow,
                    45.0,
                    (statut == PlayerState.playing)
                        ? ActionMusic.pause
                        : ActionMusic.play),
                bouton(Icons.fast_forward, 30.0, ActionMusic.forward),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textStyliser('0:0', 0.8),
                textStyliser('0:22', 0.8),
              ],
            ),
            Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: 30.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d) {
                  setState(() {
                    Duration newDuration = Duration(seconds: d.toInt());
                    position = newDuration;
                  });
                })
          ],
        ),
      ),
    );
  }

  // Fonction pour les boutons
  IconButton bouton(IconData icone, double taille, ActionMusic action) {
    return IconButton(
        icon: Icon(icone),
        color: Colors.white,
        onPressed: () {
          switch (action) {
            case ActionMusic.play:
              play();
              break;
            case ActionMusic.pause:
              pause();
              break;
            case ActionMusic.rewind:
              print("Rewind");
              break;
            case ActionMusic.forward:
              print("Forward");
              break;
          }
        });
  }

  // Fonction pour les textes
  Text textStyliser(String data, double scale) {
    return Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 20.0, fontStyle: FontStyle.italic),
    );
  }

  // Configuration de la lecture
  void configurationAudioPlayer() {
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onPositionChanged
        .listen((pos) => setState(() => position = pos));
    print(position);
    stateSub = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() {
          duree = audioPlayer.getDuration() as Duration;
        });
      } else if (state == PlayerState.stopped) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    }, onError: (message) {
      print("Erreur : $message");
      setState(() {
        statut = PlayerState.stopped;
        duree = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future<void> play() async {
    try {
      // Charger la source audio à partir de l'URL de la chanson actuelle
      await audioPlayer.setSource(AssetSource('001.mp3'));
      await audioPlayer.resume();

      // Mettre à jour l'état du lecteur pour indiquer qu'il est en train de jouer
      setState(() {
        statut = PlayerState.playing;
      });
    } catch (e) {
      // Gérer les erreurs éventuelles lors de la lecture
      print("Erreur lors de la lecture de la musique: $e");
    }
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }
}

enum ActionMusic { play, pause, rewind, forward }

enum PlayerStateStatut { playing, stopped, paused }
