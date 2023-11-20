import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //сохранение и загрузка настроек

class SettingsTemplate {
  String item;
  String title;
  List<String> list;
  bool selected;

  SettingsTemplate(this.item, this.title, this.list, {this.selected = false});
}

class AppSettings {
  List<SettingsTemplate> templates = [];
  List<SettingsTemplate> selectedTemplates = [];

  static final AppSettings _singleton = AppSettings._internal();

  factory AppSettings() {
    return _singleton;
  }

  AppSettings._internal() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? templatesData = prefs.getStringList('templates');

    if (templatesData != null) {
      templates = templatesData
          .map((data) {
        final List<String> parts = data.split(',');
        final bool selected = false;
        return SettingsTemplate(parts[0], parts[1], parts.sublist(2), selected: selected);
      })
          .toList();
    }
  }

  Future<void> saveSettings(BuildContext context,String FromWhat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> templatesData = templates
        .map((template) =>
    '${template.item},${template.title},${template.list.join(',')}')
        .toList();

    await prefs.setStringList('templates', templatesData);

    selectedTemplates = templates.where((template) => template.selected).toList();

    // Проверка на разную длину списков выбранных шаблонов
    if (FromWhat == "main"){
      if (selectedTemplates.isNotEmpty) {
        final int firstListLength = selectedTemplates[0].list.length;
        final String firstListTitle = selectedTemplates[0].title;

        for (final template in selectedTemplates) {
          if (template.list.length != firstListLength) {
            // Выводим диалоговое окно с предупреждением, используя переданный context
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Предупреждение'),
                  content: Text('Длина списка ${template.item}"${template.title}" отличается от $firstListTitle. Выберите шаблоны с одинаковой длинной списков что бы избежать ошибок'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            break;
          }
        }
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Предупреждение'),
              content: Text('Вы не выбрали ни 1 шаблона. Будут показаны только фейковые заметки'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      };
    }



  }}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppSettings appSettings = AppSettings();

  @override
  void initState() {
    super.initState();
    appSettings.loadSettings().then((_) {
      setState(() {}); // Обновите состояние текущего виджета после загрузки настроек
    });

    // Загрузка настроек при инициализации
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (int i = 0; i < appSettings.templates.length; i++)
                Card(
                  color: appSettings.templates[i].selected ? Colors.green : null,
                  child: ListTile(
                    title: Text(appSettings.templates[i].item),
                    subtitle: Text(appSettings.templates[i].title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editTemplate(i);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTemplate(i);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        appSettings.templates[i].selected = !appSettings.templates[i].selected;
                      });
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  addTemplate();
                },
                child: Text("Добавить шаблон"),
              ),
              ElevatedButton(
                onPressed: () {
                  appSettings.saveSettings(context,"main");
                  setState(() {
                    appSettings.selectedTemplates.forEach((template) {
                      print('Selected Template: ${template.item}, ${template.title}, ${template.list}');
                    });

                  });
                },
                child: Text("Сохранить"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTemplate() async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TemplateAddScreen(appSettings),
      ),
    );

    if (updated == true) {
      setState(() {
      });
    }
  }

  void editTemplate(int index) async {
    final itemController = TextEditingController(text: appSettings.templates[index].item);
    final titleController = TextEditingController(text: appSettings.templates[index].title);
    final listController = TextEditingController(text: appSettings.templates[index].list.join('\n'));

    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TemplateEditScreen(appSettings, index, itemController, titleController, listController),
      ),
    );

    if (updated == true) {
      setState(() {
        appSettings.selectedTemplates.forEach((template) {
          print('Selected Template: ${template.item}, ${template.title}, ${template.list}');
        });
      });
    }
  }

  void deleteTemplate(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Удалить шаблон"),
          content: Text("Вы уверены, что хотите удалить ${appSettings.templates[index].title}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                appSettings.templates.removeAt(index);
                appSettings.saveSettings(context,"delete");
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text("Удалить"),
            ),
          ],
        );
      },
    );
  }
}

class TemplateAddScreen extends StatefulWidget {
  final AppSettings appSettings;

  TemplateAddScreen(this.appSettings);

  @override
  _TemplateAddScreenState createState() => _TemplateAddScreenState();
}

class _TemplateAddScreenState extends State<TemplateAddScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController listController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить шаблон"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Название заметки"),
            ),//Название
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: "Предмет"),
            ),//Предмет
            TextField(
              controller: listController,
              decoration: InputDecoration(
                labelText: "Список (введите значения, разделяя символом переноса строки)",
              ),
              maxLines: null,
            ),//Список
            ElevatedButton(
              onPressed: () {
                saveTemplate();
              },
              child: Text("Сохранить"),
            ),//Кнопка сохранить
          ],
        ),
      ),
    );
  }

  void saveTemplate() {
    final newTemplate = SettingsTemplate(
      itemController.text,
      titleController.text,
      listController.text.split('\n'),
    );
    widget.appSettings.templates.add(newTemplate);
    widget.appSettings.saveSettings(context,"add");
    Navigator.of(context).pop(true);
  }
}

class TemplateEditScreen extends StatefulWidget {
  final AppSettings appSettings;
  final int templateIndex;
  final TextEditingController itemController;
  final TextEditingController titleController;
  final TextEditingController listController;

  TemplateEditScreen(this.appSettings, this.templateIndex, this.itemController, this.titleController, this.listController);

  @override
  _TemplateEditScreenState createState() => _TemplateEditScreenState();
}

class _TemplateEditScreenState extends State<TemplateEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Редактировать шаблон"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteTemplate();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: widget.titleController,
              decoration: InputDecoration(labelText: "Название заметки"),
            ),
            TextField(
              controller: widget.itemController,
              decoration: InputDecoration(labelText: "Предмет"),
            ),
            TextField(
              controller: widget.listController,
              decoration: InputDecoration(
                labelText: "Список (введите значения, разделяя символом переноса строки)",
              ),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {
                saveTemplate();
              },
              child: Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }

  void saveTemplate() {
    final updatedTemplate = SettingsTemplate(
      widget.itemController.text,
      widget.titleController.text,
      widget.listController.text.split('\n'),
      selected: widget.appSettings.templates[widget.templateIndex].selected,
    );
    widget.appSettings.templates[widget.templateIndex] = updatedTemplate;
    widget.appSettings.saveSettings(context,"edit");
    Navigator.of(context).pop(true);
  }

  void deleteTemplate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Удалить шаблон"),
          content: Text("Вы уверены, что хотите удалить этот шаблон?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                widget.appSettings.templates.removeAt(widget.templateIndex);
                widget.appSettings.saveSettings(context,"delete");
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
              child: Text("Удалить"),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
  ));
}
