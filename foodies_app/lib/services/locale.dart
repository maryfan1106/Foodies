import 'package:intl/intl.dart' show DateFormat;

DateFormat dtf = DateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");

String formatTimestamp(DateTime dt) {
  return dtf.format(dt);
}
