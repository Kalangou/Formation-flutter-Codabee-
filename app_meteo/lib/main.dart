import 'dart:async';
import 'dart:convert';
import 'package:app_meteo/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'temps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Position? position = null;
  try {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } on PlatformException catch (e) {
    print("Erreur : ${e}");
  }

  if (position != null) {
    final latitude = position.latitude;
    final longitude = position.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark? ville = placemarks[0];
    if (ville != null) {
      runApp(MyApp(ville.locality.toString()));
    }
  }
}

class MyApp extends StatelessWidget {
  late String? ville;
  MyApp(String ville, {super.key}) {
    this.ville = ville;
  }
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(ville!, title: 'Météo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(String ville, {super.key, required this.title}) {
    this.villeUser = ville;
  }

  final String title;
  late String? villeUser;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String key = "villes";
  List<String> villes = [];
  late String? villeChoisie = null;

  late Temps? tempActuel = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenir();
    appelApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        drawer: Drawer(
            elevation: 5.0,
            child: Container(
              child: ListView.builder(
                  itemCount: villes.length,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return DrawerHeader(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          texteStyle("Mes villes", fontSize: 22.0),
                          OutlinedButton(
                              onPressed: () {
                                ajoutVille();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.white),
                                  elevation: MaterialStateProperty.resolveWith(
                                      (states) => 8)),
                              child: texteStyle("Ajouter une ville",
                                  color: Colors.blue))
                        ],
                      ));
                    } else if (i == 1) {
                      return ListTile(
                        title: texteStyle(widget.villeUser!),
                        onTap: () {
                          setState(() {
                            villeChoisie = null;
                            appelApi();
                            Navigator.pop(context);
                          });
                        },
                      );
                    } else {
                      String ville = villes[i - 2];
                      return ListTile(
                        title: texteStyle(ville),
                        trailing: IconButton(
                            onPressed: (() => supprimer(ville)),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                        onTap: () {
                          setState(() {
                            villeChoisie = ville;
                            appelApi();
                            Navigator.pop(context);
                          });
                        },
                      );
                    }
                  }),
              color: Colors.lightBlueAccent,
            )),
        body: (tempActuel == null)
            ? Center(
                child: Text(villeChoisie ?? widget.villeUser!),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(assetName()), fit: BoxFit.cover),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    texteStyle(tempActuel!.name!, fontSize: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        texteStyle("${tempActuel?.temp.toInt()} °C",
                            fontSize: 60.0),
                        Image.asset(tempActuel!.icon.toString()),
                      ],
                    ),
                    texteStyle(tempActuel!.main.toString(), fontSize: 30.0),
                    texteStyle(tempActuel!.description.toString(),
                        fontSize: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              MyFlutterApp.temperatire,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            texteStyle("${tempActuel!.pressure}",
                                fontSize: 20.0)
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              MyFlutterApp.droplet,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            texteStyle("${tempActuel!.humidity}",
                                fontSize: 20.0)
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              MyFlutterApp.arrow_upward,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            texteStyle("${tempActuel!.tempMax}", fontSize: 20.0)
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              MyFlutterApp.arrow_downward,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            texteStyle("${tempActuel!.tempMin}", fontSize: 20.0)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ));
  }

  String assetName() {
    if (tempActuel!.icon!.contains('d')) {
      return "assets/n.jpg";
    } else if (tempActuel!.icon!.contains('01') ||
        tempActuel!.icon!.contains('02') ||
        tempActuel!.icon!.contains('03')) {
      return "assets/d1.jpg";
    } else {
      return "assets/d2.jpg";
    }
  }

  Text texteStyle(String data,
      {color = Colors.white,
      fontSize = 17.0,
      fontStyle = FontStyle.italic,
      textAlign = TextAlign.center}) {
    return Text(
      data,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: fontSize, fontStyle: fontStyle),
    );
  }

  Future<Null> ajoutVille() async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            title: texteStyle("Ajouter une ville",
                fontSize: 22.0, color: Colors.blue),
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Ville: "),
                onSubmitted: (String string) {
                  ajout(string);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void obtenir() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? liste = sharedPreferences.getStringList(key);
    if (liste != null) {
      setState(() {
        villes = liste;
      });
    }
  }

  void ajout(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.add(str);
    await sharedPreferences.setStringList(key, villes);
    obtenir();
  }

  void supprimer(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.remove(str);
    await sharedPreferences.setStringList(key, villes);
    obtenir();
  }

  void coordonnees() async {
    String? str;
    if (villeChoisie == null) {
      str = widget.villeUser;
    } else {
      str = villeChoisie;
    }

    try {
      List<Location> locations = await locationFromAddress(str!);
      if (locations != null) {
        locations.forEach((element) => print(element));
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void appelApi() async {
    String? str;
    if (villeChoisie == null) {
      str = widget.villeUser;
    } else {
      str = villeChoisie;
    }

    try {
      List<Location> locations = await locationFromAddress(str!);
      if (locations != null) {
        final lat = locations.first.latitude;
        final lon = locations.first.longitude;
        String lang = Localizations.localeOf(context).languageCode;
        final apiKey = "8cb5b961f06ebcd3642ed3aa38bc0cb2";
        String urlApi =
            "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&lang=${lang}&apiKey=${apiKey}";
        final reponse = await http.get(Uri.parse(urlApi));
        if (reponse.statusCode == 200) {
          Temps temps = Temps();
          Map map = jsonDecode(reponse.body);
          temps.fromJSON(map);
          setState(() {
            tempActuel = temps;
          });
          print(tempActuel!.icon!);
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
