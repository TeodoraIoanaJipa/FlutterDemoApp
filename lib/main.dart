import 'package:flutter/material.dart';
import 'package:foodzzz/database_helper.dart';
import 'package:foodzzz/model/dog.dart';
import 'package:foodzzz/model/reservation.dart';
import 'package:foodzzz/model/restaurant.dart';
import 'package:foodzzz/restaurant_detail_page.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as Path;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Avoid errors caused by flutter upgrade
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FoodZzz',
      home: new ListWords(),
    );
  }
}

class ListWords extends StatefulWidget {
  @override
  _RestaurntsListState createState() => _RestaurntsListState();
}

class _RestaurntsListState extends State<ListWords> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var restaurantsList = <Restaurant>[];
  var count;
  var favoriteRestaurants = <Restaurant>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

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
      body: _buildList(),
    );
  }

  Widget _iconsRow(bool favorite, Restaurant restaurant) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: favorite ? Colors.red.shade900 : null,
          size: 30,
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

  Widget _buildRow(Restaurant restaurant) {
    final alreadyFavorite = favoriteRestaurants.contains(restaurant);

    return ListTile(
        title: Text(
          restaurant.name,
          style: _biggerFont,
        ),
        leading: Image.network(restaurant.imageLink),
        trailing: _iconsRow(alreadyFavorite, restaurant),
        onTap: () {
          setState(() {
            if (alreadyFavorite) {
              favoriteRestaurants.remove(restaurant);
            } else {
              favoriteRestaurants.add(restaurant);
            }
          });
        },
        minLeadingWidth: 80);
  }

  Widget _buildList() {
    return ListView.separated(
        itemCount: restaurantsList.length,
        itemBuilder: (context, index) {
          return _buildRow(restaurantsList[index]);
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
