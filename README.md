# Small HttpServer app in Dart

## Instructions

* The server app is ```bin/note_server.dart```, and the client app is ```web/note_client.dart```, which is used in ```web/index.html``` via the head tag ```<script defer src="note_client.dart.js"></script>```.

* Start development server with ```webdev serve``` (long) or ```pub run build_runner serve``` (shorter), which create JS file ```note_client.dart.js``` and serve ```index.html``` on http://localhost:8080.

* Start ```bin/note_server.dart``` in an IDE to launch server app on http://localhost:4040.

* Open client app on http://localhost:8080 (which communicate to server app on http://localhost:4040).

* Enjoy !
