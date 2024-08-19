// For Google Cloud Run, set _hostname to '0.0.0.0'.
import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

  final ip = InternetAddress.anyIPv4;

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  final path = args.isNotEmpty ? args[0] : 'specs/swagger.yaml';
  final handler = SwaggerUI(
    path,
    title: 'Dart Swagger Test',
  );

  final server = await io.serve(handler.call, ip, port);

  log('Serving at http://${server.address.host}:${server.port}');

  // setTimer();
}

// Timer? timer;

// void setTimer() {
//   timer?.cancel();
//   timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     log(DateTime.now().millisecondsSinceEpoch.toString());

//     // timer.cancel();
//   });
// }
