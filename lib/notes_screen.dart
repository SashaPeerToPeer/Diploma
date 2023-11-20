import 'package:flutter/material.dart';
import 'app_settings.dart'; //страница настроек


class NotesScreen extends StatelessWidget {
  final List<List<String>> myList;
  final AppSettings appSettings = AppSettings();

  NotesScreen({required this.myList});

  bool isDigit(String char) {
    // Проверка, является ли символ числом
    return int.tryParse(char) != null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfTiles = [];

    for (int index = 0; index < appSettings.selectedTemplates.length; index++) {
      final template = appSettings.selectedTemplates[index];
      List<String> ZametkiList = myList[index];
      ListTile newTile = ListTile(
        title: Text(template.title),
        subtitle: Text("08.10.23 ${ZametkiList[0]}"),
        onTap: () {
          openNoteDetailScreen(context, template.title, ZametkiList);
        },
      );

      listOfTiles.add(newTile);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("Заметки"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("Фейк1"),
            subtitle: Text("08.10.23 Фейк1"),
            onTap: () {
              // Действие для Фейк1
            },
          ),
          ListTile(
            title: Text("Фейк2"),
            subtitle: Text("02.08.23 1.Фейк2"),
            onTap: () {
              // Действие для Фейк2
            },
          ),
          ...listOfTiles,
          ListTile(
            title: Text("Фейк3"),
            subtitle: Text("02.08.23 1.Фейк2"),
            onTap: () {
              // Действие для Фейк2
            },
          ),
// Добавляем уже сгенерированные ListTile
        ],
      ),
    );
  }

  void openNoteDetailScreen(BuildContext context, String noteTitle, List<String> myList) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(noteTitle: noteTitle, myList: myList),
      ),
    );
  }

}

class NoteDetailScreen extends StatelessWidget {
  final String noteTitle;
  final List<String> myList;

  NoteDetailScreen({required this.noteTitle, required this.myList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(""),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              noteTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: myList.length,
                separatorBuilder: (context, index) => SizedBox(), // Убираем разделитель
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${myList[index]}'), // Добавляем номер перед элементом
                    // Другие свойства элемента списка, если нужно
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}