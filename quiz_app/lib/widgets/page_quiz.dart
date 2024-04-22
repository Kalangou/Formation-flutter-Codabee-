import 'package:flutter/material.dart';
import 'custom_text.dart';
import 'package:quiz_app/modeles/question.dart';

class PageQuiz extends StatefulWidget {
  @override
  _PageQuizState createState() => _PageQuizState();
}

class _PageQuizState extends State<PageQuiz> {
  late Question question;
  List<Question> listeQuestion = [
    Question("La devise de la belgique est l'union fait la force.", true, '',
        'belgique.jpg'),
    Question("La lune va finir par tomber sur terre à cause de la gravité.",
        false, '', 'lune.jpg'),
    Question("La Russie est plus grande en superficie que Pluton.", true, '',
        'russie.jpg'),
    Question("Nyctalope est une race naine d'antilope.", false,
        'Faites des recherches sur internet', 'nyctalope.png'),
    Question("Le module lunaire Eagle de possédait de 4Ko de RAM.", true, '',
        'eagle.jpg'),
    Question("Le nom du bateau de pirate s'appelle black skull.", false,
        'Black perle', 'pirate.jpg'),
    Question("Le Commodore est l'ordinateur le plus vendu.", true, '',
        'commodore.jpg'),
    Question("La barbe de Pharaon etait fausse.", true, '', 'pharaon.jpg'),
  ];
  late int index = 0;
  late int score = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    question = listeQuestion[index];
  }

  @override
  Widget build(BuildContext context) {
    double taille = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: AppBar(
        title: CustomText("Le Quizz"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomText("Question N°: ${index + 1}", color: Colors.grey[900]),
            CustomText("Score: ${score / 1}", color: Colors.grey[900]),
            Card(
              elevation: 10.0,
              child: Container(
                height: taille,
                width: taille,
                child: Image.asset(
                  "quiz asset/${question.imagePath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CustomText(
              question.question,
              color: Colors.grey[900],
              factor: 1.3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [boutonBool(true), boutonBool(false)],
            )
          ],
        ),
      ),
    );
  }

  OutlinedButton boutonBool(bool b) {
    return OutlinedButton(
        onPressed: (() => dialogue(b)),
        style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blue),
            elevation: MaterialStateProperty.resolveWith((states) => 10.0)),
        child: CustomText(
          (b) ? 'Vrai' : 'Faux',
          factor: 1.25,
        ));
  }

  Future<Null> dialogue(bool b) async {
    bool bonneReponse = (b == question.reponse);
    late String vrai = 'quiz asset/vrai.png';
    late String faux = 'quiz asset/faux.jpg';
    if (bonneReponse) {
      score++;
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: CustomText(
              (bonneReponse) ? "C'est gagné" : "Oups! perdu...",
              factor: 1.4,
              color: (bonneReponse) ? Colors.green : Colors.red,
            ),
            contentPadding: EdgeInsets.all(20.0),
            children: [
              Image.asset(
                (bonneReponse) ? vrai : faux,
                fit: BoxFit.cover,
              ),
              Container(
                height: 20.0,
              ),
              CustomText(
                question.explication,
                factor: 1.25,
                color: Colors.grey[900],
              ),
              Container(
                height: 25.0,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    questionSuivante();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue)),
                  child: CustomText(
                    "Au suivant",
                    factor: 1.25,
                    color: Colors.white,
                  ))
            ],
          );
        });
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: CustomText(
              "C'est fini...",
              color: Colors.blue,
              factor: 1.25,
            ),
            contentPadding: EdgeInsets.all(10.0),
            content: CustomText(
              "Votre score : $score / $index}",
              color: Colors.black,
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    "Ok",
                    color: Colors.blue,
                    factor: 1.5,
                  ))
            ],
          );
        });
  }

  void questionSuivante() {
    if (index < listeQuestion.length - 1) {
      index++;
      setState(() {
        question = listeQuestion[index];
      });
    } else {
      alerte();
    }
  }
}
