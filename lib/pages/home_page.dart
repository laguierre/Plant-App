import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/data/data.dart';
import '../utils/constants.dart';
import '../widgets/plant_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollControllerV = ScrollController();
  final _scrollControllerH = ScrollController();
  double _opacityLabelAndButton_1 = 0.0;
  double _opacityLabelAndButton_2 = 0.0;
  double _opacityRecommended = 0.0;
  double _positionH = 0.0;
  double widthScreen = 1;
  double heightRecommended = 1;
  double heightListRecommended = 1;

  @override
  void initState() {
    _scrollControllerV.addListener(_listenScrollingV);
    _scrollControllerH.addListener(_listenScrollingH);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerV.dispose();
    super.dispose();
  }

  void _listenScrollingV() {
    setState(() {
      _opacityLabelAndButton_1 =
          _scrollControllerV.position.pixels.clamp(0, heightRecommended) /
              heightRecommended;
      _opacityRecommended =
      (_scrollControllerV.position.pixels - heightRecommended).clamp(0, heightListRecommended) /
              heightListRecommended;

      _opacityLabelAndButton_2 = (_scrollControllerV.position.pixels - heightRecommended).clamp(0, heightListRecommended) /
          heightListRecommended;
      print(_scrollControllerV.position.pixels);
      print("Opacity List: $_opacityRecommended");
      //print(_scrollControllerV.position.pixels - heightRecommended);
    });
  }

  void _listenScrollingH() {
    setState(() {
      _positionH = _scrollControllerH.position.pixels;
      if (_positionH < 0) {
        _positionH = 0;
      }
      print("Position Horizontal: $_positionH");
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sizeCustomAppBar = size.height * 0.2;
    double sizeSearchBar = size.height * 0.07;
    double topMarginSearchBar = sizeCustomAppBar - sizeSearchBar / 2;

    setState(() {
      widthScreen = size.width;
      heightRecommended = sizeSearchBar;
      heightListRecommended = size.height * heightListCard;
      print(heightListRecommended);
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
          scrollControllerH: _scrollControllerH,
          opacityLabelAndButton_1: _opacityLabelAndButton_1,
          opacityLabelAndButton_2: _opacityLabelAndButton_2,
          opacityRecommended: _opacityRecommended,
          positionH: _positionH,
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
    required this.scrollControllerH,
    required this.positionH,
    required this.opacityLabelAndButton_1,
    required this.opacityRecommended,
    required this.opacityLabelAndButton_2,
  }) : super(key: key);

  final double topMarginSearchBar;
  final Size size;
  final ScrollController scrollControllerV;
  final double opacityLabelAndButton_1;
  final double opacityLabelAndButton_2;
  final double opacityRecommended;
  final ScrollController scrollControllerH;
  final double positionH;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMarginSearchBar),
      child: SingleChildScrollView(
        controller: scrollControllerV,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Opacity(
                opacity: 1 - opacityLabelAndButton_1,
                child: const _LabelAndButton(
                    textLabel: 'Recommended', textButton: 'More')),
            Opacity(
                opacity: 1 - opacityRecommended,
                child: _RecommendedPlant(
                  size: size,
                  scrollController: scrollControllerH,
                  position: positionH,
                )),
            Opacity(
                opacity: 1 - opacityLabelAndButton_2,
                child: const _LabelAndButton(
                    textLabel: 'Featured Plants', textButton: 'More')),
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
      height: size.height * heightListCard,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kPrimaryColor,
              Colors.transparent,
              Colors.transparent,
              kPrimaryColor
            ],
            stops: [
              0.0,
              0.03,
              0.97,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
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
      ),
    );
  }
}

class _RecommendedPlant extends StatelessWidget {
  const _RecommendedPlant({
    Key? key,
    required this.size,
    required this.scrollController,
    required this.position,
  }) : super(key: key);

  final Size size;
  final ScrollController scrollController;
  final double position;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.34,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kPrimaryColor,
              Colors.transparent,
              Colors.transparent,
              kPrimaryColor
            ],
            stops: [
              0.0,
              0.05,
              0.95,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
          controller: scrollController,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
      ]),
    );
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
