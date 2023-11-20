import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
      ),
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(null),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil),
            label: '',
          ),
        ],
        iconSize: 30,
      ),//нижняя панель
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                trailing: Icon(CupertinoIcons.ellipsis_circle, size: 25.0, color: Color(0xFFE5BE20)),
                leading: Icon(CupertinoIcons.back),
                padding: EdgeInsetsDirectional.only(start: 5.0, end: 20.0),
                backgroundColor: CupertinoColors.secondarySystemBackground,
                stretch: true,
                border: null,
                largeTitle: Text('Заметки'),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
// Обработка обновления списка
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoSearchTextField(
                    placeholder: 'Поиск',
                    onSubmitted: (query) {
// Обработка запроса поиска
                    },
                  ),
                ),
              ),//Поиск
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Закреплено'),
                      ),
                      children: <Widget>[
                        CupertinoListTile.notched(
                          title: Text('100 продуктов'),
                          subtitle: Text('01:49 Нет дополнительного текста'),
                          onTap: () {
// При нажатии на заметку открываем детали заметки
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => NoteDetailsPage('100 продуктов', '01:49 Нет дополнительного текста'),
                            ));
                          },
                        ),
                        CupertinoListTile.notched(
                          title: Text('100 актеров'),
                          subtitle: Text('20.10.2023 Нет дополнительного текста'),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Сентябрь'),
                      ),
                      children: <Widget>[
                        CupertinoListTile.notched(
                          title: Text('крем сыр+'),
                          subtitle: Text('20.10.2023 огурец+'),
                        ),
                        CupertinoListTile.notched(
                          title: Text('кстати хлопчик зайди тебя это'),
                          subtitle: Text('20.10.2023 Нет дополнительного текста'),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Сентябрь'),
                      ),
                      children: <Widget>[
                        CupertinoListTile.notched(
                          title: Text('крем сыр+'),
                          subtitle: Text('20.10.2023 огурец+'),
                        ),
                        CupertinoListTile.notched(
                          title: Text('кстати хлопчик зайди тебя это'),
                          subtitle: Text('20.10.2023 Нет дополнительного текста'),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Сентябрь'),
                      ),
                      children: <Widget>[
                        CupertinoListTile.notched(
                          title: Text('крем сыр+'),
                          subtitle: Text('20.10.2023 огурец+'),
                        ),
                        CupertinoListTile.notched(
                          title: Text('кстати хлопчик зайди тебя это'),
                          subtitle: Text('20.10.2023 Нет дополнительного текста'),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Сентябрь'),
                      ),
                      children: <Widget>[
                        CupertinoListTile.notched(
                          title: Text('крем сыр+'),
                          subtitle: Text('20.10.2023 огурец+'),
                        ),
                        CupertinoListTile.notched(
                          title: Text('кстати хлопчик зайди тебя это'),
                          subtitle: Text('20.10.2023 Нет дополнительного текста'),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        );      },
    );
  }
}
class NoteDetailsPage extends StatelessWidget {
  final String title;
  final String details;

  NoteDetailsPage(this.title, this.details);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemBackground,
          previousPageTitle: "Заметки",
          border: null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Это для выравнивания элементов по центру по вертикали
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(CupertinoIcons.share, size: 25.0, color: Color(0xFFE5BE20)),
                onPressed: () {
                  // Действие при нажатии на иконку share
                },
              ),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(CupertinoIcons.ellipsis_circle, size: 25.0, color: Color(0xFFE5BE20)),
                onPressed: () {
                  // Действие при нажатии на иконку ellipsis_circle
                },
              ),
            ],
          )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              details,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}