import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MySwipeScreen(),
    );
  }
}

class MyAppButton {
  final int index;
  final Rect bounds;

  MyAppButton(this.index, this.bounds);
}

class MySwipeScreen extends StatefulWidget {
  @override
  _MySwipeScreenState createState() => _MySwipeScreenState();
}

class _MySwipeScreenState extends State<MySwipeScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  int startIndexPage1 = -1;
  int startIndexPage2 = -1;
  int resultIndex = -1;
  List<MyAppButton> buttons = [];

  @override
  void initState() {
    super.initState();
    // Добавляем кнопки с координатами и индексами
    for (int i = 0; i < 24; i++) {
      buttons.add(MyAppButton(i, Rect.zero));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Задний фон с изображением
          Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Экраны
          Swipe(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                  updateResultIndex();
                });
              },
              children: <Widget>[
                buildGridScreen(0, "Экран 1", Colors.blue, (startIndex) {
                  startIndexPage1 = startIndex;
                  updateResultIndex();
                }),
                buildGridScreen(1, "Экран 2", Colors.green, (startIndex) {
                  startIndexPage2 = startIndex;
                  updateResultIndex();
                }),
                buildTextScreen(2),
              ],
            ),
            onSwipeLeft: () {
              if (currentPage < 2) {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
            onSwipeRight: () {
              if (currentPage > 0) {
                _pageController.previousPage(
                    duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
          ),
        ],
      ),
    );
  }

  void updateResultIndex() {
    if (currentPage == 2) {
      if (startIndexPage1 > 0 && startIndexPage2 > 0) {
        resultIndex = startIndexPage1*10 + startIndexPage2;
      } else if (startIndexPage1 > 0 && startIndexPage2 == 0) {
        resultIndex = startIndexPage1*10;
      } else if (startIndexPage1 >0 && startIndexPage2 < 0) {
        resultIndex = startIndexPage1;
      } else {
        resultIndex = 88888; // Другие случаи
      }
    }
  }

  Widget buildScreen(int index, String title, Color color) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildGridScreen(int index, String title, Color color, Function(int) onStartSwipe) {
    return Container(
      color: Colors.transparent,
      child: Listener(
        onPointerMove: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.position);
          final cellWidth = renderBox.size.width / 4;
          final cellHeight = renderBox.size.height / 6;
          final columnIndex = (localPosition.dx / cellWidth).floor();
          final rowIndex = (localPosition.dy / cellHeight).floor();
          final offsetX = localPosition.dx % cellWidth;
          final offsetY = localPosition.dy % cellHeight;
          int gridIndex = columnIndex + (rowIndex * 4);

          // Определение индекса с учетом положения пальца относительно центра ячейки
          if (offsetX >= cellWidth / 2) {
            gridIndex += 1; // Переходим к следующей ячейке
          }

          if (offsetY >= cellHeight / 2) {
            gridIndex += 4; // Переходим к ячейке ниже
          }

          // Учитываем только указанные индексы
          int adjustedIndex = -1;
          if (gridIndex == 9) {
            adjustedIndex = 0;
          } else if (gridIndex >= 13 && gridIndex <= 15) {
            adjustedIndex = gridIndex - 12;
          } else if (gridIndex >= 17 && gridIndex <= 19) {
            adjustedIndex = gridIndex - 13;
          } else if (gridIndex >= 21 && gridIndex <= 23) {
            adjustedIndex = gridIndex - 14;
          } else {
            adjustedIndex = -100;
          }

          if (adjustedIndex != -1) {
            onStartSwipe(adjustedIndex);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: 64, bottom: 64), // Отступы сверху и снизу
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100, // Ширина ячейки
                  crossAxisSpacing: 4,      // Отступы между ячейками по горизонтали
                  mainAxisSpacing: 4,       // Отступы между ячейками по вертикали
                  childAspectRatio: 1,      // Соотношение сторон (квадратные ячейки)
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, itemIndex) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        itemIndex.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  },
                  childCount: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextScreen(int index) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Text(
          "Индексы начала свайпа:\nЭкран 1: $startIndexPage1\nЭкран 2: $startIndexPage2\nРезультат: $resultIndex",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
