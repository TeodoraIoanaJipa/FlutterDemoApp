import 'package:foodzzz/model/dog.dart';
import 'package:foodzzz/model/reservation.dart';
import 'package:foodzzz/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String restaurantsTableName = 'restaurants';
  String reservationsTableName = 'reservations';

  String colId = 'id';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = 'food.db';

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE OR REPLACE TABLE $restaurantsTableName(id INTEGER PRIMARY KEY, name TEXT, ' +
          'description TEXT, opening_time TEXT, closing_time TEXT, price_category TEXT, image_link TEXT, address TEXT)',
    );

    await db.execute(
        'CREATE OR REPLACE TABLE $reservationsTableName(id INTEGER PRIMARY KEY, number_of_persons INTEGER, reservation_date TEXT, reservation_hour TEXT, requested_date TEXT, restaurant_id INTEGER, user_id INTEGER);');

    await db.execute(
      'INSERT INTO restaurants(id, name, description, opening_time, closing_time, price_category, image_link, address) ' +
          ' VALUES( 0, "Restaurant Pescăruș", "Restaurantul Pescăruș s-a primenit cu o amenajare interioară nouă, ' +
          'cu un Chef nou și evident cu un nou meniu. Celebrul arhitect și designer, Mihai Popescu, a acceptat provocarea' +
          ' de a regândi spațiul interior al restaurantului.", ' +
          ' "10:00", "22:00", "Moderat", "https://d2fdt3nym3n14p.cloudfront.net/venue/449/gallery/12289/conversions/817C0399-1-big.jpg", " Aleea Pescăruș , Herãstrãu"), ' +
          '(1, "Osteria Zucca", " Pe terasă sunt de 38 de locuri. Materia prima este importata din Italia, inclusiv făină pentru pizza. Noi gătim exclusiv cu ulei de masline extravirgin de o calitate superioară.", ' +
          ' "11:30", "22:00", "Moderat", "https://d2fdt3nym3n14p.cloudfront.net/venue/1649/gallery/3695/conversions/15-big.jpg", " Strada Jean Louis Calderon 41, Universitate"),' +
          '(2, "Hanul lui Manuc", "Hanul lui Manuc este o clădire veche din București, important obiectiv turistic și monument istoric.", ' +
          '"08:00", "20:00", "Moderat", "https://www.hanumanucrestaurant.ro/storage/app/media/despre-noi-listare.jpg", " Franceză 62-64, Centrul Vechi"),' +
          '(3, "Aria TNB", "O poveste culturală teatrală care se prelungește pe terasa Teatrului Național cu o bucătărie internațională' +
          ' aleasă și un bar impresionat, Aria TNB oferă una dintre cele mai spectaculoase priveliști asupra capitalei",' +
          '"12:00", "00:00", "Moderat", ' +
          '"https://www.aria-tnb.ro/gallery_new/aria_13.jpg", "Bulevardul Nicolae Bălcescu 2, Universitate"),' +
          '(4, "Primus Pub", "Primus Pub împacă atmosfera de bar cu cea de restaurant, oferindu-ți o gamă largă de opțiuni pentru băuturi alcoolice și non-alcoolice, dar și o varietate de preparate culinare de la breakfast și sandwichuri până la specialități din bucătăria românească și internațională.",' +
          '"09:00", "00:00", "Accesibil", ' +
          '"https://d2fdt3nym3n14p.cloudfront.net/venue/69/gallery/711/conversions/primus_food_more-big.jpg", "Strada George Enescu 3, Piața Romană");',
    );
  }

  Future<List<Map<String, dynamic>>> getRestaurantsList() async {
    Database db = await this.database;

    var result = await db.query(restaurantsTableName, orderBy: 'name ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getReservationsList() async {
    Database db = await this.database;
    return await db.query(reservationsTableName, orderBy: 'id ASC');
  }

  Future<int> insertReservation(Reservation reservation) async {
    Database db = await this.database;
    var result = await db.insert(reservationsTableName, reservation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateReservation(Reservation reservation) async {
    var db = await this.database;
    var result = await db.update(reservationsTableName, reservation.toMap(),
        where: '$colId = ?', whereArgs: [reservation.id]);
    return result;
  }

  Future<int> deleteReservation(int id) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $reservationsTableName WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $reservationsTableName');
    int result = Sqflite.firstIntValue(x)!;
    return 0;
  }

  Future<List<Restaurant>> getRestaurants() async {
    var restaurants = await getRestaurantsList();
    int count = restaurants.length;

    var reservations = await getReservationsList();
    print(reservations);

    return List.generate(count, (i) {
      return Restaurant.fromMapObject(restaurants[i]);
    });
  }
}
