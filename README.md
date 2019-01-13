# Small HttpServer app in Dart

## Instructions

* The server app is ```bin/note_server.dart```, and the client app is ```web/note_client.dart```, which is used in ```web/index.html``` via the head tag ```<script defer src="note_client.dart.js"></script>```.

* Start ```bin/note_server.dart``` to launch server app on http://localhost:8080.

* For debug, compile client app with ```pub run build_runner watch --output=.build``` to build JS file ```note_client.dart.js``` and watch any modifications. Debugging is done via Chrome Dev Tools thanks to sourcemaps.

* For release, do one-time compilation with ```pub run build_runner build --output=.build --release```.
