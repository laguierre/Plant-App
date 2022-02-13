import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/utils/constants.dart';
import 'package:flutter/services.dart';

class BuyPlantPage extends StatelessWidget {
  const BuyPlantPage({Key? key, required this.plant}) : super(key: key);

  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sizePicture = 0.6;
    double borderPicture = 3 * size.height * 0.028;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
                width: double.infinity,
                child: Stack(
                  children: [
                    const _ButtonsSide(),
                    _PlantImage(
                        size: size,
                        sizePicture: sizePicture,
                        borderPicture: borderPicture,
                        plant: plant),
                    const _ButtonsTop(),
                  ],
                ),
              ),
            ),
            _DetailsData(size: size, plant: plant),
            SizedBox(height: size.height * 0.03),
            _BtnBuyAndDescription(size: size),
          ],
        ),
      ),
    );
  }
}

class _PlantImage extends StatelessWidget {
  const _PlantImage({
    Key? key,
    required this.size,
    required this.sizePicture,
    required this.borderPicture,
    required this.plant,
  }) : super(key: key);

  final Size size;
  final double sizePicture;
  final double borderPicture;
  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(left: size.width * (1 - sizePicture)),
      width: size.width * sizePicture,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            spreadRadius: 10,
            blurRadius: 10,
            offset: const Offset(3, 8), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderPicture),
            bottomLeft: Radius.circular(borderPicture)),
      ),
      child: Hero(
        tag: plant.id,
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderPicture),
                bottomLeft: Radius.circular(borderPicture)),
            child: Image.asset(
              plant.image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}

class _ButtonsSide extends StatelessWidget {
  const _ButtonsSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          top: size.height * 0.01,
          bottom: size.height * 0.01,
          left: size.height * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BtnSide(nameIcon: sun, onTap: () {}),
          BtnSide(nameIcon: icon_2, onTap: () {}),
          BtnSide(nameIcon: icon_3, onTap: () {}),
          BtnSide(nameIcon: icon_4, onTap: () {}),
        ],
      ),
    );
  }
}

class _ButtonsTop extends StatelessWidget {
  const _ButtonsTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset(back_arrow, color: Colors.black),
            onPressed: () {
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: kPrimaryColor, // status color bar
                statusBarIconBrightness:
                    Brightness.light, // status bar icon color
              ));
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: SvgPicture.asset(more, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DetailsData extends StatelessWidget {
  const _DetailsData({
    Key? key,
    required this.size,
    required this.plant,
  }) : super(key: key);

  final Size size;
  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.1,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FittedBox(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: plant.title, //plantName.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black, fontSize: size.height * 0.05)),
                  TextSpan(
                      text: '\n' + plant.country,
                      style: TextStyle(
                          color: kPrimaryColor, fontSize: size.height * 0.03)),
                ]),
              ),
            ),
            const Spacer(),
            Text('\$' + plant.price.toString(), //'\$$price',
                style: TextStyle(
                    fontSize: size.height * 0.05,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _BtnBuyAndDescription extends StatelessWidget {
  const _BtnBuyAndDescription({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.1,
      child: Row(
        children: [
          InkWell(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(size.width * 0.1)),
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: size.width / 2,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * 0.1)),
              ),
              child: Text('Buy Now',
                  style: TextStyle(
                      fontSize: size.height * 0.03, color: Colors.white)),
            ),
          ),
          InkWell(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(size.width * 0.1)),
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: size.width / 2,
              child: Text('Description',
                  style: TextStyle(
                      fontSize: size.height * 0.03, color: kPrimaryColor)),
            ),
          )
        ],
      ),
    );
  }
}

class BtnSide extends StatelessWidget {
  const BtnSide(
      {Key? key,
      required this.nameIcon,
      required this.onTap,
      this.sizeBtn = 70})
      : super(key: key);
  final String nameIcon;
  final VoidCallback onTap;
  final double sizeBtn;

  @override
  Widget build(BuildContext context) {
    double sizeBtn = MediaQuery.of(context).size.height * 0.08;
    return Container(
      height: sizeBtn,
      width: sizeBtn,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child:
            SvgPicture.asset(nameIcon, fit: BoxFit.none, color: kPrimaryColor),
      ),
    );
  }
}
