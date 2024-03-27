part of 'http.dart';

void _printLogs(
  Map<String, dynamic> logs,
  StackTrace? stackTrace,
) {
  try {
    if (kDebugMode) {
      log(
        '''
✅ -----------------------------------
        ${const JsonEncoder.withIndent('  ').convert(logs)}
          ''',
        stackTrace: stackTrace,
      );
    }
  } on Exception catch (e) {
    log(e.toString());
  }
}
