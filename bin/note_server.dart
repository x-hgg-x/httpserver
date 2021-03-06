// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:async';
import 'dart:io';
import 'dart:convert' show utf8, json;
import 'package:http_server/http_server.dart';

int count = 0;
VirtualDirectory staticFiles = VirtualDirectory('.build/web');

Future main() async {
  staticFiles
    ..allowDirectoryListing = true
    ..jailRoot = false
    ..directoryHandler = (dir, request) {
      var indexUri = Uri.file(dir.path).resolve('index.html');
      staticFiles.serveFile(File(indexUri.toFilePath()), request);
    };

  try {
    // One note per line.
    List<String> lines = File('notes.txt').readAsLinesSync();
    count = lines.length;
  } on FileSystemException {
    print('Could not open notes.txt.');
    return;
  }

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Listening for requests on http://localhost:8080.');
  await listenForRequests(server);
}

Future listenForRequests(HttpServer requests) async {
  await for (HttpRequest request in requests) {
    addCorsHeaders(request.response);
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      case 'OPTION':
        handleOptions(request);
        break;
      default:
        defaultHandler(request);
        break;
    }
  }
  print('No more requests.');
}

Future handleGet(HttpRequest request) async {
  if (request.uri.path == '/note' && request.uri.queryParameters['q'] != null) {
    getNote(request);
  } else {
    staticFiles.serveRequest(request);
  }
}

Future handlePost(HttpRequest request) async {
  Map decoded;

  try {
    decoded = await request.transform(utf8.decoder.fuse(json.decoder)).first as Map;
  } catch (e) {
    print('Request listen error: $e');
    return;
  }
  if (decoded.containsKey('myNote')) {
    saveNote(request, "${decoded['myNote']}\n");
  }
}

void saveNote(HttpRequest request, String myNote) {
  try {
    File('notes.txt').writeAsStringSync(myNote, mode: FileMode.append);
  } catch (e) {
    print('Couldn\'t open notes.txt: $e');
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..writeln('Couldn\'t save note.')
      ..close();
    return;
  }

  count++;
  request.response
    ..statusCode = HttpStatus.ok
    ..writeln('You have $count notes.')
    ..close();
}

void getNote(HttpRequest request) {
  final requestedNote = int.tryParse(request.uri.queryParameters['q']) ?? 0;

  if (requestedNote >= 1 && requestedNote <= count) {
    try {
      List<String> lines = File('notes.txt').readAsLinesSync();
      request.response
        ..statusCode = HttpStatus.ok
        ..writeln(lines[requestedNote - 1])
        ..close();
    } catch (e) {
      print('Couldn\'t open notes.txt at line ${requestedNote}: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..writeln('Couldn\'t open note.')
        ..close();
    }
  } else {
    request.response
      ..statusCode = HttpStatus.notFound
      ..writeln('Note not found.')
      ..close();
  }
}

void defaultHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..write('Not found: ${request.method}, ${request.uri.path}')
    ..close();
}

void handleOptions(HttpRequest request) {
  print('${request.method}: ${request.uri.path}');
  request.response
    ..statusCode = HttpStatus.noContent
    ..close();
}

void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}
