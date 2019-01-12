# Small HttpServer app in Dart

## Instructions

* The server app is ```bin/note_server.dart```, and the client app is ```web/note_client.dart```, which is used in ```web/index.html``` via the head tag ```<script defer src="note_client.dart.js"></script>```.

* Start ```bin/note_server.dart``` in an IDE to launch server app on http://localhost:4040.

* For debug, start development server with ```pub run build_runner serve --output=build```, which create JS file ```note_client.dart.js``` and serve ```index.html``` on http://localhost:8080. The client app communicate with the server app on http://localhost:4040.

* For release, compile client app with ```pub run build_runner build --output=build --release```, and open directly the html file ```build/web/index.html```.
