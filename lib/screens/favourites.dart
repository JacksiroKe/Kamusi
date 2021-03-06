import 'package:flutter/material.dart';
import 'package:kamusi/helpers/sqlite_helper.dart';
import 'package:kamusi/models/neno_model.dart';
import 'package:kamusi/views/neno_item.dart';
import 'package:kamusi/widgets/as_loader.dart';
import 'package:provider/provider.dart';
import 'package:kamusi/helpers/app_settings.dart';
import 'package:kamusi/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class Favourites extends StatefulWidget {
  @override
  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  AsLoader loader = AsLoader();
  SqliteHelper db = SqliteHelper();

  Future<Database> dbFuture;
  List<NenoModel> items = List<NenoModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateListView(context));
  }

  void updateListView(BuildContext context) async {
    loader.showWidget();

    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NenoModel>> itemListFuture = db.getFavorites();
      itemListFuture.then((resultList) {
        setState(() {
          items = resultList;
          loader.hideWidget();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LangStrings.favourited),
      ),
      body: mainBody(),
    );
  }

  Widget mainBody()
  {
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration()
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [ 0.1, 0.4, 0.6, 0.9 ],
                colors: [ Colors.black, Colors.blue[900],  Colors.blue, Colors.blue[200] ]),
            ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return NenoItem('ItemLiked_' + items[index].id.toString(), items[index], context);
              }
            ),
          ),
          Container(
            child: loader,
          ),
        ],
      ),
    );
  }
  
}
