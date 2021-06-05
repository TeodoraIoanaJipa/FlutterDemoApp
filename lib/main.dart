import 'package:flutter/material.dart';
import 'package:foodzzz/database_helper.dart';
import 'package:foodzzz/model/reservation.dart';
import 'package:foodzzz/model/restaurant.dart';
import 'package:foodzzz/restaurant_detail_page.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Avoid errors caused by flutter upgrade
  runApp(FoodZApp());
}

class FoodZApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FoodZzz',
      home: new RestaurantsList(),
    );
  }
}

class RestaurantsList extends StatefulWidget {
  @override
  _RestaurntsListState createState() => _RestaurntsListState();
}

class _RestaurntsListState extends State<RestaurantsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var restaurantsList = <Restaurant>[];
  var count;
  var favoriteRestaurants = <Restaurant>[];
  final _biggerFont = TextStyle(fontSize: 26.0);

  @override
  Widget build(BuildContext context) {
    if (restaurantsList.isEmpty) {
      restaurantsList = [];
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurants',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        actions: [
          new IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildList(context),
    );
  }

  Widget _iconsRow(bool favorite, Restaurant restaurant) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red.shade900 : null,
            size: 26,
          ),
          onTap: () {
            setState(() {
              if (favorite) {
                favoriteRestaurants.remove(restaurant);
              } else {
                favoriteRestaurants.add(restaurant);
              }
            });
          },
        ),
        GestureDetector(
          child:
              Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 31),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RestaurantDetailsPage(restaurant: restaurant)));
          },
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, Restaurant restaurant) {
    final alreadyFavorite = favoriteRestaurants.contains(restaurant);

    return Card(
        child: new Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 15.0),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: new BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(restaurant.imageLink),
            ))),
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: <Widget>[
                Text(
                  restaurant.name,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 26.0,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                _iconsRow(alreadyFavorite, restaurant)
              ],
            )),
        Container(
            margin: EdgeInsets.all(10),
            child: RestaurantDetailsPage.getAddress(context, restaurant))
      ],
    ));
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
        itemCount: restaurantsList.length,
        itemBuilder: (context, index) {
          return _buildRow(context, restaurantsList[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  void _pushSaved() async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = favoriteRestaurants.map(
            (Restaurant pair) {
              return ListTile(
                title: Text(
                  pair.name,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Favorites'),
              backgroundColor: Colors.orange,
            ),
            body: ListView(
              children: divided,
              padding: EdgeInsets.only(top: 15),
            ),
          );
        }, // ...to here.
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Restaurant>> restaurantsFuture =
          databaseHelper.getRestaurants();
      restaurantsFuture.then((restaurants) {
        setState(() {
          this.restaurantsList = restaurants;
          this.count = restaurants.length;
        });
      });
    });
  }

  void insertReservation(Reservation reservation) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      databaseHelper.insertReservation(reservation);
    });
  }
}
