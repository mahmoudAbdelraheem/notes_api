import 'package:notes_api/constant/massage.dart';

validInput(String val, int min, int max) {
  if (val.length > max) {
    return "$massageInputMax $max";
  } else if (val.isEmpty) {
    return massageInputEmpty;
  } else if (val.length < min) {
    return "$massageInputMin $min";
  }
}
