import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('My App'),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('My Page'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text('Закреплено'),
                  children: <Widget>[
                    CupertinoListTile(
                      title: Text('Item 1'),
                    ),
                    CupertinoListTile(
                      title: Text('Item 2'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text('Октябрь'),
                  children: <Widget>[
                    CupertinoListTile(
                      title: Text('Item 3'),
                    ),
                    CupertinoListTile(
                      title: Text('Item 4'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
