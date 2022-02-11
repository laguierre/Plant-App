import 'package:flutter/material.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/utils/constants.dart';

class RecommendedPlantCard extends StatelessWidget {
  const RecommendedPlantCard(
      {Key? key, this.widthCardSize = 150, required this.plant})
      : super(key: key);

  final double widthCardSize;
  final PlantModel plant;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Hero(
                  tag: plant.id,
                  child: Image.asset(
                    plant.image,
                    fit: BoxFit.cover,
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: plant.title.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black, fontSize: size.height * 0.02)),
                    TextSpan(
                        text: "\n" + plant.country,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: size.height * 0.015)),
                  ]),
                ),
                const Spacer(),
                Text("\$" + plant.price.toString(),
                    style: TextStyle(
                        fontSize: size.height * 0.023,
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
  const FeaturedPlantCard({Key? key, required this.recommendedPlant})
      : super(key: key);

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
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset(recommendedPlant, fit: BoxFit.cover),
      ),
    );
  }
}
