import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class BuyPlantPage extends StatefulWidget {
  const BuyPlantPage({Key? key}) : super(key: key);

  @override
  _BuyPlantPageState createState() => _BuyPlantPageState();
}

class _BuyPlantPageState extends State<BuyPlantPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.red,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(back_arrow,
                            color: Colors.black),
                        SvgPicture.asset(more,
                            color: Colors.black)
                      ],
                    ),

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
