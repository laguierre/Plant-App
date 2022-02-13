import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/data/data.dart';
import '../utils/constants.dart';
import '../widgets/plant_card.dart';
import 'buy_plant_page.dart';
import 'package:flutter/services.dart';

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
  double heightFeaturedPlant = 1;
  late bool _blockList;

  @override
  void initState() {
    _scrollControllerV.addListener(_listenScrollingV);
    _scrollControllerH.addListener(_listenScrollingH);
    super.initState();
    _blockList = true;
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
          (_scrollControllerV.position.pixels - heightRecommended)
                  .clamp(0, heightListRecommended) /
              heightListRecommended;

      //20 = altura que le quiero dar para que sea efectiva la opacidad
      _opacityLabelAndButton_2 =
          ((_scrollControllerV.position.pixels - heightFeaturedPlant) / (15))
              .clamp(0, 1);

      ///If the Vertical Scroll Position is > 0.1 Size Screen => Block the InkWell
      ///of the image
      setState(() {
        MediaQuery.of(context).size.height * 0.1 >
                _scrollControllerV.position.pixels
            ? _blockList = true
            : _blockList = false;
      });
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
      heightFeaturedPlant = heightListRecommended + heightRecommended;
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
          topMarginSearchBar: topMarginSearchBar + size.height * 0.08,
          size: size,
          scrollControllerV: _scrollControllerV,
          scrollControllerH: _scrollControllerH,
          opacityLabelAndButton_1: _opacityLabelAndButton_1,
          opacityLabelAndButton_2: _opacityLabelAndButton_2,
          opacityRecommended: _opacityRecommended,
          positionH: _positionH,
          blockList: _blockList,
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
    required this.blockList,
  }) : super(key: key);

  final double topMarginSearchBar;
  final Size size;
  final ScrollController scrollControllerV;
  final double opacityLabelAndButton_1;
  final double opacityLabelAndButton_2;
  final double opacityRecommended;
  final ScrollController scrollControllerH;
  final double positionH;
  final bool blockList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMarginSearchBar),
      child: SingleChildScrollView(
        controller: scrollControllerV,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Transform.scale(
              scale: 1 - 0.35 * opacityLabelAndButton_1,
              child: Opacity(
                  opacity: 1 - opacityLabelAndButton_1,
                  child: const _LabelAndButton(
                      textLabel: 'Recommended', textButton: 'More')),
            ),
            Transform.scale(
              scale: 1 - 0.35 * opacityRecommended,
              child: Opacity(
                  opacity: 1 - opacityRecommended,
                  child: _RecommendedPlant(
                    size: size,
                    scrollController: scrollControllerH,
                    position: positionH,
                    blockList: blockList,
                  )),
            ),
            Transform.scale(
              scale: 1 - 0.35 * opacityLabelAndButton_2,
              child: Opacity(
                  opacity: 1 - opacityLabelAndButton_2,
                  child: const _LabelAndButton(
                      textLabel: 'Featured Plants', textButton: 'More')),
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
      height: size.height * heightListCard,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: colors,
            stops: stops, // 10% purple, 80% transparent, 10% purple
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
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.width * 0.05),
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
    required this.blockList,
  }) : super(key: key);

  final Size size;
  final ScrollController scrollController;
  final double position;
  final bool blockList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.34,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: colors,
            stops: stops, // 10% purple, 80% transparent, 10% purple
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
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.width * 0.05),
              child: InkWell(
                child: RecommendedPlantCard(
                  widthCardSize: size.width * 0.38,
                  plant: plant,
                ),
                onTap: blockList
                    ? () {
                        SystemChrome.setSystemUIOverlayStyle(
                            const SystemUiOverlayStyle(
                          systemNavigationBarColor: Colors.transparent,
                          // navigation bar color
                          statusBarColor: kBackgroundColor,
                          // status bar color
                          statusBarIconBrightness: Brightness.dark,
                          // status bar icon color
                          systemNavigationBarIconBrightness:
                              Brightness.dark, // color of navigation controls
                        ));

                        Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (context, animation, _) {
                              return FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOut)),
                                  child: BuyPlantPage(
                                    plant: plant,
                                  ));
                            }));
                      }
                    : null,
              ),
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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
              borderRadius: BorderRadius.circular(size.height * 0.03)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: size.width - 4 * size.height * 0.025,
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: kPrimaryColor),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(search,
                            color: kPrimaryColor, height: 20),
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
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(size * 0.2),
              bottomRight: Radius.circular(size * 0.2))),
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
