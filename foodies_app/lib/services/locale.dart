import 'package:intl/intl.dart';

String formatTimestamp(DateTime dt) {
  return DateFormat("EEE, MMMM d, yyyy h:mm a").format(dt);
}
