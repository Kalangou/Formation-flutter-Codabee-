import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Les widgets intéractifs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String changed = '';
  late String submitted = '';
  late bool interrupteur = false;
  late int itemSelection = 0;
  List<Widget> radios() {
    List<Widget> l = [];
    for (var i = 1; i <= 5; i++) {
      Row row = Row(
        children: [
          Text("Votre choix N° ${i}"),
          Radio(
              value: i,
              groupValue: itemSelection,
              onChanged: (int? i) {
                setState(() {
                  itemSelection = i ?? 0;
                });
              })
        ],
      );
      l.add(row);
    }

    return l;
  }

  Map<String, bool> checker = {
    'Carottes': false,
    'Banane': false,
    'Yaour': false,
    'Pain': false
  };

  List<Widget> checkList() {
    List<Widget> l = []; // Initialisation de la liste
    checker.forEach((key, value) {
      Row row =
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          key,
          style: TextStyle(
              color: (value) ? Colors.green : Colors.red, fontSize: 18),
        ),
        Checkbox(
          value: (value),
          onChanged: (bool? newValue) {
            // Accepte un paramètre bool? au lieu de bool
            setState(() {
              checker[key] = newValue ??
                  false; // Utilisez newValue ?? false pour gérer le cas où newValue est null
            });
          },
        )
      ]);
      l.add(row);
    });

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Aimez-vous coder en mobile?"),
          Switch(
              value: interrupteur,
              inactiveThumbColor: Colors.red,
              activeColor: Colors.green,
              onChanged: (bool b) {
                setState(() {
                  interrupteur = b;
                });
              })
        ]
            // [
            //   TextField(
            //     keyboardType: TextInputType.number,
            //     onChanged: (String string) {
            //       setState(() {
            //         changed = string;
            //       });
            //     },
            //     onSubmitted: (String string) {
            //       setState(() {
            //         submitted = string;
            //       });
            //     },
            //     decoration: InputDecoration(labelText: "Entrer votre nom"),
            //   ),
            //   Text(changed ?? ''),
            //   Text(submitted ?? ''),
            // ],
            ),
      ),
    );
  }
}
