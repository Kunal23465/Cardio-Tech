import 'package:cardio_tech/src/features/cardiologistScreens/home/navbarScreens/allOrder.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/navbarScreens/finalized.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/navbarScreens/homePage.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/navbarScreens/myOrder.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/navbarScreens/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Cardiologistnavbar extends StatefulWidget {
  final int initialIndex;
  const Cardiologistnavbar({super.key, this.initialIndex = 2});

  @override
  State<Cardiologistnavbar> createState() => _CardiologistnavbarState();
}

class _CardiologistnavbarState extends State<Cardiologistnavbar> {
  int _currentIndex = 2; // default tab

  static const double navBarHeight = 70;

  // --- PRELOADED SVG ICONS (NO BLINK) ---
  Widget homeActiveIcon = const SizedBox();
  Widget homeInactiveIcon = const SizedBox();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    homeActiveIcon = SvgPicture.asset(
      'assets/images/navbar/home.svg',
      width: 30,
      height: 30,
    );

    homeInactiveIcon = SvgPicture.asset(
      'assets/images/navbar/home-2.svg',
      width: 30,
      height: 30,
    );
  }

  List<Widget?> _pages = [null, null, null, null, null];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;

      if (_pages[index] == null) {
        if (index == 0)
          _pages[index] = const MyOrder();
        else if (index == 1)
          _pages[index] = const AllOrder();
        else if (index == 2)
          _pages[index] = const HomePage();
        else if (index == 3)
          _pages[index] = const Finalized();
        else if (index == 4)
          _pages[index] = const Setting();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = 2;
    _pages[2] = const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final bool isThreeButtonNav = bottomInset >= 40;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: true,

      body: IndexedStack(
        index: _currentIndex,
        children: _pages.map((page) => page ?? const SizedBox()).toList(),
      ),

      // ---------------- FAB (NO BLINK) ----------------
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2596BE),
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () => _onTabSelected(2),
          child: _currentIndex == 2 ? homeActiveIcon : homeInactiveIcon,
        ),
      ),

      floatingActionButtonLocation: const CustomCenterDockedFABLocation(),

      // ---------------- BOTTOM NAVIGATION ----------------
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: isThreeButtonNav, // only for 3-button nav
        child: SizedBox(
          height: navBarHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: CustomPaint(painter: NavBarPainter())),
              SizedBox(
                height: navBarHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: _navButton(
                        _currentIndex == 0
                            ? SvgPicture.asset(
                                "assets/cardiologistsIcon/icon/navbar/myOrder1.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                "assets/cardiologistsIcon/icon/navbar/myOrder.svg",
                                width: 24,
                                height: 24,
                              ),
                        "My Order",
                        0,
                      ),
                    ),
                    Expanded(
                      child: _navButton(
                        _currentIndex == 1
                            ? SvgPicture.asset(
                                "assets/images/navbar/patients.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                "assets/images/navbar/patients-2.svg",
                                width: 24,
                                height: 24,
                              ),
                        "All Order",
                        1,
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: _navButton(
                        _currentIndex == 3
                            ? SvgPicture.asset(
                                "assets/cardiologistsIcon/icon/navbar/Finalized1.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                "assets/cardiologistsIcon/icon/navbar/Finalized.svg",
                                width: 24,
                                height: 24,
                              ),
                        "Finalized",
                        3,
                      ),
                    ),
                    Expanded(
                      child: _navButton(
                        _currentIndex == 4
                            ? SvgPicture.asset(
                                "assets/images/navbar/setting.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                "assets/images/navbar/setting-2.svg",
                                width: 24,
                                height: 24,
                              ),
                        "Settings",
                        4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(Widget icon, String label, int index) {
    return InkWell(
      onTap: () => _onTabSelected(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity, //FULL WIDTH TAP AREA
        height: 70, // LARGE TAP HEIGHT
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- FAB ADJUST ONLY FOR 3-BUTTON NAVIGATION ---------- //

class CustomCenterDockedFABLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const CustomCenterDockedFABLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final base = super.getOffset(geometry);
    double bottomInset = geometry.minInsets.bottom;

    bool isThreeButton = bottomInset >= 40;
    double lift = isThreeButton ? bottomInset * 0.40 : 0;

    return base.translate(0, -20 - lift);
  }
}

// ---------------- NAV BAR PAINTER ---------------- //

class NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2596BE), Color(0xFF64C7A6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()..moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);
    path.cubicTo(
      size.width * 0.40,
      0,
      size.width * 0.45,
      25,
      size.width * 0.50,
      25,
    );
    path.cubicTo(
      size.width * 0.55,
      25,
      size.width * 0.60,
      0,
      size.width * 0.65,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
