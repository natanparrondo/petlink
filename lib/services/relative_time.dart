import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:timeago/timeago.dart' as timeago;

String formatFechaCustom(DateTime fecha) {
  final DateTime ahora = DateTime.now();
  final int diffDays = ahora.difference(fecha).inDays;
  final DateTime hoySinHora = DateTime(ahora.year, ahora.month, ahora.day);
  final DateTime fechaSinHora = DateTime(fecha.year, fecha.month, fecha.day);
  final DateTime ayerSinHora = hoySinHora.subtract(const Duration(days: 1));

  if (fechaSinHora == hoySinHora) return 'Hoy';
  if (fechaSinHora == ayerSinHora) return 'Ayer';
  if (diffDays < 7 && diffDays >= 0)
    return DateFormat('EEEE', 'es').format(fecha);
  return DateFormat('dd/MM', 'es').format(fecha);
}
