import 'package:flutter/material.dart';
import 'package:plant_app/utils/constants.dart';

class RecommendedPlantCard extends StatelessWidget {
  const RecommendedPlantCard(
      {Key? key,
      required this.picture,
      required this.plantName,
      required this.countryName,
      required this.price, this.widthCardSize = 150})
      : super(key: key);
  final String picture, plantName, countryName;
  final int price;
  final double widthCardSize;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      width: widthCardSize,
      //width: size.width * 0.38,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(3, 5), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.asset(picture)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: plantName.toUpperCase(),
                        style: TextStyle(color: Colors.black, fontSize: size.height*0.02)),
                    TextSpan(
                        text: "\n$countryName",
                        style: TextStyle(color: Colors.black, fontSize: size.height*0.015)),
                  ]),
                ),
                const Spacer(),
                Text('\$$price',
                    style: TextStyle(
                        fontSize: size.height*0.023,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FeaturedPlantCard extends StatelessWidget {
  const FeaturedPlantCard({Key? key, required this.recommendedPlant}) : super(key: key);

  final String recommendedPlant;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      height: 200,
      width: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image.asset(recommendedPlant, fit: BoxFit.cover),
      ),
    );
  }
}

