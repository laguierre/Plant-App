import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/utils/constants.dart';

class BuyPlantPage extends StatefulWidget {
  const BuyPlantPage({Key? key}) : super(key: key);

  @override
  _BuyPlantPageState createState() => _BuyPlantPageState();
}

class _BuyPlantPageState extends State<BuyPlantPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sizePicture = 0.7;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                child: Stack(
                  children: [
                    const _ButtonsSide(),
                    Container(
                      height: double.infinity,
                      margin:
                          EdgeInsets.only(left: size.width * (1 - sizePicture)),
                      width: size.width * sizePicture,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.1),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: const Offset(
                                3, 8), // changes position of shadow
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3 * kDefaultPadding),
                            bottomLeft: Radius.circular(3 * kDefaultPadding)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(3*kDefaultPadding), bottomLeft: Radius.circular(3*kDefaultPadding)),
                          child: Hero(
                            tag: 'prueba',
                            child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                          )),
                    ),
                    const _ButtonsTop(),
                  ],
                ),
              ),
            ),
            _DetailsData(size: size),
            _BtnBuyAndDescription(size: size),
          ],
        ),
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
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, bottom: 10, left: kDefaultPadding),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset(back_arrow, color: Colors.black),
            onPressed: () {
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
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Angelica', //plantName.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black, fontSize: size.height * 0.05)),
                TextSpan(
                    text: '\nRusia', //"\n$countryName",
                    style: TextStyle(
                        color: kPrimaryColor, fontSize: size.height * 0.03)),
              ]),
            ),
            Spacer(),
            Text('440', //'\$$price',
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
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height * 0.1,
          width: size.width / 2,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          ),
          child: Text('Buy Now',
              style:
                  TextStyle(fontSize: size.height * 0.03, color: Colors.white)),
        ),
        Container(
          alignment: Alignment.center,
          height: size.height * 0.15,
          width: size.width / 2,
          child: Text('Description',
              style: TextStyle(
                  fontSize: size.height * 0.03, color: kPrimaryColor)),
        )
      ],
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
    return InkWell(
      child: Container(
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
        child:
            SvgPicture.asset(nameIcon, fit: BoxFit.none, color: kPrimaryColor),
      ),
      onTap: onTap,
    );
  }
}
