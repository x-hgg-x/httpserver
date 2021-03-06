// Client to note_server.dart.
// Use note_taker.html to run this script.

import 'dart:html';

String note;

TextInputElement noteTextInput;
ParagraphElement howManyNotes;
TextInputElement chooseNote;
ParagraphElement displayNote;
HttpRequest request;

void main() {
  noteTextInput = querySelector('#note_entry') as TextInputElement;
  howManyNotes = querySelector('#display_how_many_notes') as ParagraphElement;
  chooseNote = querySelector('#choose_note') as TextInputElement;
  displayNote = querySelector('#display_note') as ParagraphElement;

  querySelector('#save_note').onClick.listen(saveNote);
  querySelector('#get_note').onClick.listen(requestNote);
}

void saveNote(Event e) {
  if (noteTextInput.value.isNotEmpty) {
    request = HttpRequest();
    request.onReadyStateChange.listen(onData);
    request.open('POST', '/');
    request.send('{"myNote":"${noteTextInput.value}"}');
  }
}

void requestNote(Event e) {
  if (chooseNote.value.isNotEmpty) {
    request = HttpRequest();
    request.onReadyStateChange.listen(onData);
    request.open('GET', '/note?q=${chooseNote.value}');
    request.send();
  }
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    if (request.responseText.startsWith('You')) {
      howManyNotes.text = request.responseText;
    } else {
      displayNote.text = request.responseText;
    }
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    // Status is 0; most likely the server isn't running.
    howManyNotes.text = 'No server connection';
  }
}
