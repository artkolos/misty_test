import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:misty_test/injection.dart';
import 'package:misty_test/presentation/application/application.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();
      runApp(const Application());
    },
    (err, st) {
      Logger().e(err, stackTrace: st);
    },
  );
}
