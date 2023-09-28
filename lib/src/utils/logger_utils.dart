import 'dart:developer';

import 'package:api_for_dart/src/env.dart';
import 'package:logging/logging.dart';

final logger = Logger.root
  ..level = Env.instance.isDebug ? Level.WARNING : Level.ALL
  ..onRecord.listen((record) {
    log(
      record.message,
      time: record.time,
      level: record.level.value,
      error: record.error,
      stackTrace: record.stackTrace,
      sequenceNumber: record.sequenceNumber,
    );
  });
