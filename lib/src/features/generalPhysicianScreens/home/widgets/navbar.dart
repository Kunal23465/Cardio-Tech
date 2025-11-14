import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/allPatient.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/home.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/newOrder.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;
  const Navbar({super.key, this.initialIndex = 2});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _currentIndex;
  static const double navBarHeight = 90;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  ///  Lazy load pages instead of building all at once
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const NewOrder();
      case 1:
        return const AllPatient();
      case 2:
        return const HomePage();
      // case 3:
      //   return const Trackorder();
      case 4:
        return const Setting();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: true,

      ///  Only build currently selected page
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(child: _getPage(_currentIndex)),
            ),
          ),
        ),
      ),

      // Floating Action Button (Home)
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2596BE),
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () => _onTabSelected(2),
          child: _currentIndex == 2
              ? SvgPicture.asset(
                  'assets/images/navbar/home.svg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                )
              : SvgPicture.asset(
                  'assets/images/navbar/home-2.svg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
        ),
      ),
      floatingActionButtonLocation: const CustomCenterDockedFABLocation(),

      bottomNavigationBar: SizedBox(
        height: navBarHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: CustomPaint(painter: NavBarPainter())),
            SafeArea(
              top: false,
              bottom: true,
              child: SizedBox(
                height: navBarHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: _navButton(
                        _currentIndex == 0
                            ? SvgPicture.asset(
                                "assets/images/navbar/add.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                "assets/images/navbar/add-2.svg",
                                width: 24,
                                height: 24,
                              ),
                        "New Order",
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
                        "All Patients",
                        1,
                      ),
                    ),
                    const SizedBox(width: 80), // space for FAB
                    Expanded(
                      child: _navButton(
                        _currentIndex == 3
                            ? SvgPicture.asset(
                                "assets/images/navbar/order-2.svg",
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                // "assets/images/navbar/order-2.svg",
                                "assets/images/navbar/order-2.svg",

                                width: 24,
                                height: 24,
                              ),
                        "Track Order",
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(Widget icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 80,
        height: 60,
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

class CustomCenterDockedFABLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const CustomCenterDockedFABLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset baseOffset = super.getOffset(scaffoldGeometry);
    return baseOffset.translate(0, -20);
  }
}

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
