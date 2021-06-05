import 'package:flutter/material.dart';
import 'package:foodzzz/maps-location.dart';
import 'package:foodzzz/model/restaurant.dart';
import 'package:foodzzz/reservation_page.dart';


class RestaurantDetailsPage extends StatelessWidget {
  final Restaurant restaurant;

  final String buttonText = "Rezervă o masă";
  final String hexaDarkRed = "#b41700";
  Color darkRedColor = Color(int.parse("#b41700".replaceAll('#', '0xff')));

  RestaurantDetailsPage({Key? key, required this.restaurant}) : super(key: key);

  Widget _getAddress(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: new Row(
        children: <Widget>[
          new Icon(Icons.location_on, color: darkRedColor),
          new Text(restaurant.address, style: TextStyle(color: darkRedColor))
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapsRestaurantLocation()));
      },
    ));
  }

  Widget getDetailsText(BuildContext context) {
    String color = hexaDarkRed.replaceAll('#', '0xff');
    Color darkRedColor = Color(int.parse(color));

    var restaurantName = Text(
      restaurant.name,
      style: TextStyle(
          color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
    );

    return Column(
      children: <Widget>[
        Row(
          children: [
            Icon(
              Icons.fastfood_rounded,
              color: Colors.black,
              size: 40.0,
            ),
            restaurantName
          ],
        ),
        Container(
          width: 200.0,
          child: new Divider(
            color: darkRedColor,
            thickness: 2,
          ),
        ),
        Row(
          children: [_getAddress(context)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: darkRedColor),
                        Text(
                          restaurant.openingTime + "-" + restaurant.closingTime,
                          style: TextStyle(color: darkRedColor),
                        )
                      ],
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.red.shade100),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: new Text(
                    "\$" + restaurant.priceCategory,
                    style: TextStyle(color: darkRedColor),
                  ),
                ))
          ],
        ),
      ],
    );
  }

  Widget _restaurantImage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(restaurant.imageLink),
            ))),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _infoContent(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: getDetailsText(context),
      ),
    );
  }

  Widget _descriptionContent(BuildContext context) {
    String darkRed = hexaDarkRed.replaceAll('#', '0xff');

    final descriptionText = Padding(
      child: Text(
        restaurant.description,
        style: TextStyle(fontSize: 18.0),
      ),
      padding: EdgeInsets.all(20.0),
    );

    final reservationButton = Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReservationPage(
                        selectedRestaurant: restaurant,
                      )));
        },
        color: Color(int.parse(darkRed)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          children: <Widget>[descriptionText, reservationButton],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(0),
          child: new SingleChildScrollView(
              child: new Column(
            children: <Widget>[
              _restaurantImage(context),
              _infoContent(context),
              _descriptionContent(context),
              // _mapsLocation(context)
            ],
          ))),
    );
  }
}
