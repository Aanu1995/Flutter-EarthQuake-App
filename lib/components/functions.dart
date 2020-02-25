import 'package:intl/intl.dart';

class Functions {
  static String secondValue = '';
  static String polish(String snapshot) {
    String value = snapshot.toLowerCase();
    var correct = value.indexOf("of");
    if (correct != -1) {
      String firstvalue = (snapshot.substring(0, (correct + 2))).toUpperCase();
      secondValue = snapshot.substring((correct + 3), value.length);
      return "$firstvalue";
    } else {
      secondValue = snapshot;
      return "";
    }
  }

  static String getTime(String value) {
    int timestamp = int.parse(value);
    var milli = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var date = DateFormat.yMMMd("en_US").format(milli).toString();
    var time = new DateFormat.jm().format(milli).toString();
    return "$date \n $time";
  }

  static String magValue(String value) {
    String _correct;
    if (value.length > 3) {
      _correct = value.substring(0, 3);
    } else {
      _correct = value;
    }
    return _correct;
  }
}
