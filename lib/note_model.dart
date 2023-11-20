
import 'package:flutter/material.dart';
import 'note_model.dart';

class NoteListScreen extends StatelessWidget {
  final List<Note> notes;

  NoteListScreen(this.notes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заметки'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // При нажатии на кнопку "Добавить" можно добавить новую заметку
          // Здесь нужно реализовать добавление заметки и обновление состояния
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class Note {
  final String title;
  final String content;

  Note(this.title, this.content);
}
