import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/iqran_app.dart';

void main() async {
  // Initialize intl locale data for Indonesian (skip for web)
  if (!kIsWeb) {
    await initializeDateFormatting('id_ID', null);
  }
  Intl.defaultLocale = 'id_ID';
  runApp(const IqranApp());
}
