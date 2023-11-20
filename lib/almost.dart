import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_settings.dart'; //страница настроек
import 'notes_screen.dart'; // панель закладок





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyPageView(),
                  ),
                );
              },
              child: Text("Начать показ"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              child: Text("Настройки"),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text("Выход"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPageView extends StatefulWidget {
  final GlobalKey<NavigatorState> page1NavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> page2NavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> page3NavigatorKey = GlobalKey<NavigatorState>();





  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  PageController _pageController = PageController(initialPage: 0);
  double _startX = 0;
  double _startY = 0;
  bool showBottomPanel = true; // Переменная для показа/скрытия нижней панели


  void _updateShowBottomPanel(bool show) {
    setState(() {
      showBottomPanel = show;
    });
  } //возможность скрыть нижнюю панель
  List<String> imagePaths = [
    'assets/lowbarimages/phone.png',
    'assets/lowbarimages/safari.png',
    'assets/lowbarimages/ios-message.png',
    'assets/lowbarimages/camera.png',
  ];


  @override
  void initState() {
    super.initState();
  }

  void nextPage() {
    _pageController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  void previousPage() {
    _pageController.previousPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onHorizontalDragStart: (details) {
            _startX = details.localPosition.dx;
            _startY = details.localPosition.dy;
          },
          onHorizontalDragUpdate: (details) {
            double dx = details.localPosition.dx - _startX;

            if (dx > 0) {
              previousPage();
            } else if (dx < 0) {
              nextPage();
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background/background2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (showBottomPanel) // Проверка, показывать или нет нижнюю панель
                Positioned(
                  left: 9,
                  right: 9,
                  bottom: 9,
                  child: Container(
                    height: 70.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {
                            print("Нажал кнопку с нижней панели $index");
                            // Обработчик нажатия на элемент нижней панели
                          },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  imagePaths[index],
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              PageView(
                controller: _pageController,
                children: <Widget>[
                  Navigator(
                    key: widget.page1NavigatorKey,
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (context) => Page1(
                          nextPage: nextPage,
                          previousPage: previousPage,
                          updateShowBottomPanel: _updateShowBottomPanel,
                        ),
                      );
                    },
                  ),
                  Navigator(
                    key: widget.page2NavigatorKey,
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (context) => Page2(
                          nextPage: nextPage,
                          previousPage: previousPage,
                          updateShowBottomPanel: _updateShowBottomPanel,
                        ),
                      );
                    },
                  ),
                  Navigator(
                    key: widget.page3NavigatorKey,
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (context) => Page3(
                          nextPage: nextPage,
                          previousPage: previousPage,
                          updateShowBottomPanel: _updateShowBottomPanel,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }



}

int first = 0;
int second = 0;

int calculateNoteNumber(int firstIndex, int secondIndex) {
  int? OneIndex;
  int? TwoIndex;
  int? finalIndex = 0;

  // Обработка первого индекса
  switch (firstIndex) {
    case 13:
    case 14:
    case 15:
      OneIndex = firstIndex - 12;
      break;
    case 17:
    case 18:
    case 19:
      OneIndex = firstIndex - 13;
      break;
    case 21:
    case 22:
    case 23:
      OneIndex = firstIndex - 14;
      break;
    default:
      OneIndex  = -1;
  }

  // Обработка второго индекса
  switch (secondIndex) {
    case 9:
      TwoIndex = 0;
      break;
    case 13:
    case 14:
    case 15:
      TwoIndex = secondIndex - 12;
      break;
    case 17:
    case 18:
    case 19:
      TwoIndex = secondIndex - 13;
      break;
    case 21:
    case 22:
    case 23:
      TwoIndex = secondIndex - 14;
      break;
    default:
      TwoIndex = -1;
  }

  String OneString = OneIndex.toString();
  String TwoString = TwoIndex.toString();

  if (OneIndex > 0 && TwoIndex >= 0 ){
    String resultString = OneString + TwoString;
    int? finalIndex = int.tryParse(resultString);
    if (finalIndex != null) {
      return(finalIndex);
    } else {
      finalIndex = 0;
    }

  } else if (OneIndex < 0 && TwoIndex> 0 ){
    return TwoIndex;

  }


  return finalIndex;
} //обрабатываем индексы иконок

List<List<String>> createListOfLists(int noteNumber) {
  List<List<String>> listOfLists = []; // Создаем пустой список для хранения других списков

  AppSettings appSettings = AppSettings();
  appSettings.selectedTemplates.forEach((template) {
    List<String> newList = [];
    newList.addAll(template.list);
    if (newList.length >= noteNumber) {
      newList[noteNumber - 1] = template.item; //Замена в списке предмета по индексу
      listOfLists.add(newList);
    } else {
      newList[newList.length - 1] = template.item; //Добавление в конец списка в случае превышения индекса
      listOfLists.add(newList);
    }
  });
  print(listOfLists);

  return listOfLists;
}



class Page1 extends StatelessWidget {
  final Function nextPage;
  final Function previousPage;
  final Function updateShowBottomPanel;

  Page1({required this.nextPage, required this.previousPage, required this.updateShowBottomPanel});



  List<List<String>> imagePaths1 = [
    ['assets/images1/weather.png', 'Погода'],
    ['assets/images1/find-my.png', 'Локатор'],
    ['assets/images1/my-shortcuts.png', 'Команды'],
    ['assets/images1/home.png', 'Дом'],
    ['assets/images1/contacts.png', 'Контакты'],
    ['assets/images1/files.png', 'Файлы'],
    ['assets/images1/translate.png', 'Перевод'],
    ['assets/images1/books.png', 'Книги'],
    ['assets/images1/facetime.png', 'FaceTime'],
    ['assets/images1/itunes.png', 'iTunes Store'],
    ['assets/images1/photo.png', 'Фото'],
    ['assets/images1/mail.png', 'Почта'],
    ['assets/images1/measure.png', 'Рулетка'],
    ['assets/images1/reminders.png', 'Напоминания'],
    ['assets/images1/clock.png', 'Часы'],
    ['assets/images1/apple-tv.png', 'TV'],
    ['assets/images1/podcasts.png', 'Подкасты'],
    ['assets/images1/app-store.png', 'App Store'],
    ['assets/images1/apple-map.png', 'Карты'],
    ['assets/images1/health.png', 'Здоровье'],
    ['assets/images1/wallet.png', 'Wallet'],
    ['assets/images1/settings.png', 'Настройки'],
    ['assets/images1/Gooogle_aut.png', 'Authenticator'],

  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = (screenWidth / 13)*2;
    double spacing = (screenWidth / 13) / 2;
    double labelSize = iconSize/4.5;
    double HeightSpace = screenHeight*0.045;
    double Razmer = iconSize+HeightSpace;



    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(right: spacing, left: spacing,top: HeightSpace),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: imagePaths1.length,
          itemBuilder: (context, index) {

            return Center(
              child: Container(
                width: (screenHeight-iconSize)/4,
                height: Razmer,
                child: Column(
                  children: [
                    GestureDetector(
                      onVerticalDragStart: (details) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                        );
                        // При свайпе вверх открывать WelcomeScreen
                      },
                      onHorizontalDragStart: (details) {
                        first = index;
                        // Добавьте здесь код для перехода на следующий экран
                        nextPage();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          imagePaths1[index][0],
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover, // или другой подходящий вам BoxFit
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: spacing, right: spacing),
                      child: FittedBox(
                        fit: BoxFit.none, // Это уменьшит размер текста, чтобы он вписывался в доступное пространство
                        child: Text(
                          imagePaths1[index][1],
                          style: TextStyle(
                              fontSize: 7,
                              color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class Page2 extends StatelessWidget {
  final Function nextPage;
  final Function previousPage;
  final Function updateShowBottomPanel;

  Page2({required this.nextPage, required this.previousPage, required this.updateShowBottomPanel});

  List<List<String>> imagePaths1 = [
    ['assets/images2/instagram.png', 'Instagram'],
    ['assets/images2/vodafone.png', 'My Vodafone'],
    ['assets/images2/binance.png', 'Binance'],
    ['assets/images2/tiktok-app-icon.png', 'TikTok'],
    ['assets/images2/zen.png', 'ZEN.COM'],
    ['assets/images2/Bolt.png', 'Bolt'],
    ['assets/images2/discord-square-color-icon.png', 'Discord'],
    ['assets/images2/oshad.png', 'Ощад'],
    ['assets/images2/GJamboard.png', 'Jamboard'],
    ['assets/images2/googlesheets.png', 'Таблицы'],
    ['assets/images2/reddit.png', 'Reddit'],
    ['assets/images2/snapchat.png', 'Snapchat'],
    ['assets/images2/telega.png', 'Telegram'],
    ['assets/images2/diya.png', 'Дiя'],
    ['assets/images2/word.png', 'Word'],
    ['assets/images2/mono.png', 'monobank'],
    ['assets/images2/privat24.png', 'Privat24'],
    ['assets/images2/steam.png', 'Steam'],
    ['assets/images2/GClassRoom.png', 'Classroom'],
    ['assets/images2/viber.png', 'Viber'],
    ['assets/images2/zoom (1).png', 'Zoom'],
    ['assets/images2/spotyfi.webp', 'Bolt'],
    ['assets/images2/1inch.png', '1inch'],
    ['assets/images2/novaposhta.png', 'Нова Пошта'],



  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = (screenWidth / 13)*2;
    double spacing = (screenWidth / 13) / 2;
    double labelSize = iconSize/4.5;
    double HeightSpace = screenHeight*0.045;
    double Razmer = iconSize+HeightSpace;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(right: spacing, left: spacing,top: HeightSpace),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: imagePaths1.length,
          itemBuilder: (context, index) {

            return Center(
              child: Container(
                width: (screenHeight-iconSize)/4,
                height: Razmer,
                child: Column(
                  children: [
                    GestureDetector(
                      onHorizontalDragStart: (details) {
                        second = index;
                        // Добавьте здесь код для перехода на следующий экран
                        nextPage();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Image.asset(
                          imagePaths1[index][0],
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover, // или другой подходящий вам BoxFit
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: spacing, right: spacing),
                      child: FittedBox(
                        fit: BoxFit.none, // Это уменьшит размер текста, чтобы он вписывался в доступное пространство
                        child: Text(
                          imagePaths1[index][1],
                          style: TextStyle(
                              fontSize: 7,
                              color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class Page3 extends StatelessWidget {
  final Function nextPage;
  final Function previousPage;
  final Function updateShowBottomPanel;

  Page3(
      {required this.nextPage, required this.previousPage, required this.updateShowBottomPanel});

  List<List<String>> imagePaths1 = [
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    ['assets/images3/notes.png', 'Заметки'],
    // Добавьте остальные иконки здесь
  ];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double iconSize = (screenWidth / 13) * 2;
    double spacing = (screenWidth / 13) / 2;
    double labelSize = iconSize / 4.5;
    double HeightSpace = screenHeight * 0.045;
    double Razmer = iconSize + HeightSpace;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(
            right: spacing, left: spacing, top: HeightSpace),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: imagePaths1.length,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                width: (screenHeight - iconSize) / 4,
                height: Razmer,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        int? noteNumber = calculateNoteNumber(first, second);
                        if (noteNumber != null && noteNumber >= 0) {
                          List<List<String>> listOfLists = createListOfLists(noteNumber);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NotesScreen(myList: listOfLists),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Image.asset(
                          imagePaths1[index][0],
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover, // или другой подходящий вам BoxFit
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: spacing, right: spacing),
                      child: FittedBox(
                        fit: BoxFit.none,
                        // Это уменьшит размер текста, чтобы он вписывался в доступное пространство
                        child: Text(
                          imagePaths1[index][1],
                          style: TextStyle(
                              fontSize: 7,
                              color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




