class Question {
  late String question;
  late bool reponse;
  late String explication;
  late String imagePath;

  Question(
      String question, bool reponse, String explication, String imagePath) {
    this.question = question;
    this.reponse = reponse;
    this.explication = explication;
    this.imagePath = imagePath;
  }
}
