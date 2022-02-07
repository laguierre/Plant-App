import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/data/data.dart';
import 'package:plant_app/utils/constants.dart';

import '../widgets/plant_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollControllerV = ScrollController();
  bool _atEdge = false;
  double _positionV = 0.0;
  double _finalPos = 1.0;

  @override
  void initState() {
    _scrollControllerV.addListener(_listenScrolling);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerV.dispose();
    super.dispose();
  }

  void _listenScrolling() {
    setState(() {
      if (_scrollControllerV.position.atEdge) {
        _positionV = 0;
      } else {
        _positionV = (_scrollControllerV.position.pixels / _finalPos);
        if (_positionV < 0) {
          _positionV = 0;
        }
        if (_positionV >= 1) {
          _positionV = 1.0;
        }
        print("$_positionV = $_finalPos");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sizeCustomAppBar = size.height * 0.2;
    double sizeSearchBar = size.height * 0.07;
    double topMarginSearchBar = sizeCustomAppBar - sizeSearchBar / 2;
    setState(() {
      _finalPos = size.height * 0.2;
    });

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(menu, color: Colors.white),
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: const _CustomBottomNavBar(),
      body: Stack(children: [
        _CustomBody(
          topMarginSearchBar: topMarginSearchBar + 66,
          size: size,
          scrollControllerV: _scrollControllerV,
          opacityV: _positionV,
        ),
        _CustomAppBar(size: sizeCustomAppBar),
        _CustomSearchTextField(
            topMarginSearchBar: topMarginSearchBar,
            sizeSearchBar: sizeSearchBar,
            size: size),
      ]),
    ));
  }
}

class _CustomBody extends StatelessWidget {
  const _CustomBody({
    Key? key,
    required this.topMarginSearchBar,
    required this.size,
    required this.scrollControllerV,
    required this.opacityV,
  }) : super(key: key);

  final double topMarginSearchBar;
  final Size size;
  final ScrollController scrollControllerV;
  final double opacityV;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMarginSearchBar),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SingleChildScrollView(
        controller: scrollControllerV,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Opacity(
                opacity: (1 - 7 * opacityV) < 0 ? 0.0 : 1 - 7 * opacityV,
                child: _LabelAndButton(
                    textLabel: 'Recommended', textButton: 'More')),
            Opacity(
                opacity: (1 - 0.8 * opacityV) < 0 ? 0.0 : 1 - 0.8 * opacityV,
                child: _RecommendedPlant(size: size)),
            Opacity(
              opacity: (1 - 0.5 * opacityV) < 0 ? 0.0 : 1 - 0.5 * opacityV,
              child: _LabelAndButton(
                  textLabel: 'Featured Plants', textButton: 'More'),
            ),
            _FeaturedPlant(size: size),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class _FeaturedPlant extends StatelessWidget {
  const _FeaturedPlant({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.34,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: listPlant.length,
        itemBuilder: (BuildContext context, int index) {
          final plant = featuredPlant[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: FeaturedPlantCard(recommendedPlant: plant.image),
          );
        },
      ),
    );
  }
}

class _RecommendedPlant extends StatelessWidget {
  const _RecommendedPlant({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.34,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: listPlant.length,
        itemBuilder: (BuildContext context, int index) {
          final plant = listPlant[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: RecommendedPlantCard(
                widthCardSize: size.width * 0.38,
                picture: plant.image,
                plantName: plant.title,
                countryName: plant.country,
                price: plant.price),
          );
        },
      ),
    );
  }
}

class _LabelAndButton extends StatelessWidget {
  const _LabelAndButton({
    Key? key,
    required this.textLabel,
    required this.textButton,
  }) : super(key: key);

  final String textLabel, textButton;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(textLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        color: kPrimaryColor,
        child: Text(textButton,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onPressed: () {},
      )
    ]);
  }
}

class _CustomSearchTextField extends StatelessWidget {
  const _CustomSearchTextField({
    Key? key,
    required this.topMarginSearchBar,
    required this.sizeSearchBar,
    required this.size,
  }) : super(key: key);

  final double topMarginSearchBar;
  final double sizeSearchBar;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
          margin: EdgeInsets.only(top: topMarginSearchBar),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: sizeSearchBar,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(kDefaultPadding)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: size.width - 4 * kDefaultPadding,
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: kPrimaryColor),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(search,
                            color: kPrimaryColor, height: 25),
                        onPressed: () {},
                      ),
                      hintText: 'Search',
                    ),
                  )),
            ],
          )),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      height: size,
      decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hi Uishopy!',
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Image.asset(logo),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.1,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              flowers,
              color: kPrimaryColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              heart_icon,
              color: Colors.black12,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              user_icon,
              color: Colors.black12,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
