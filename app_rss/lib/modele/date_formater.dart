import 'package:intl/intl.dart';

class DateConvertisseur {
  String convertirDate(String string) {
    try {
      String il = "Il y a";
      String format = "yyyy-MM-dd HH:mm:ss.SSS";
      var formatter = DateFormat(format);
      DateTime dateTime = formatter.parse(string);

      var difference = DateTime.now().difference(dateTime);
      var days = difference.inDays;
      var hours = difference.inHours;
      var minutes = difference.inMinutes;

      if (days > 1) {
        return "$il ${Intl.plural(days, one: '$days jour', other: '$days jours')}";
      } else if (days == 1) {
        return "$il 1 jour";
      } else if (hours > 1) {
        return "$il ${Intl.plural(hours, one: '$hours heure', other: '$hours heures')}";
      } else if (hours == 1) {
        return "$il 1 heure";
      } else if (minutes > 1) {
        return "$il ${Intl.plural(minutes, one: '$minutes minute', other: '$minutes minutes')}";
      } else if (minutes == 1) {
        return "$il 1 minute";
      } else {
        return "A l'instant";
      }
    } catch (e) {
      return "Date inconnue";
    }
  }
}
