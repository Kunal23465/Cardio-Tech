import 'package:cardio_tech/src/data/generalPhysician/models/home/statusCountGpModel.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/DashboardCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/home/StatusCountGpProvider.dart';
import 'package:cardio_tech/src/provider/notificationProvider/notificationProvider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cardio_tech/src/provider/user/loggedInUserDetailsProvider.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> getDashboardCards(StatusCountGpModel data) {
    return [
      {
        'title': data.inProgress.toString(),
        'subtitle': 'In Progress',
        'iconPath': 'assets/images/homePage/dashboard/icon1.svg',
      },
      {
        'title': data.highPriorityOrders.toString(),
        'subtitle': 'High Priority Queue',
        'iconPath': 'assets/images/homePage/dashboard/icon2.svg',
      },
      {
        'title': data.totalOrdersCreated.toString(),
        'subtitle': 'Total Orders Created',
        'iconPath': 'assets/images/homePage/dashboard/icon3.svg',
      },
      {
        'title': data.inReview.toString(),
        'subtitle': 'In Review',
        'iconPath': 'assets/images/homePage/dashboard/icon4.svg',
      },
      {
        'title': data.finalizedOrders.toString(),
        'subtitle': 'Reports Finalized',
        'iconPath': 'assets/images/homePage/dashboard/icon5.svg',
      },
      {
        'title': data.acknowledged.toString(),
        'subtitle': 'Acknowledged',
        'iconPath': 'assets/images/homePage/dashboard/icon6.svg',
      },
    ];
  }

  final List<String> banners = [
    'assets/images/homePage/banner.png',
    'assets/images/homePage/banner.png',
    'assets/images/homePage/banner.png',
  ];

  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      context.read<StatusCountGpProvider>().fetchStatusCounts();

      final userId = await StorageHelper.getUserId();
      final pocId = await StorageHelper.getPocId();

      if (userId != null) {
        // Fetch user details
        context.read<LoggedInUserDetailsProvider>().fetchLoggedInUserDetails(
          userId: userId,
        );
      } else {
        debugPrint("User ID not found in storage");
      }

      if (pocId != null) {
        context.read<NotificationProvider>().fetchNotifications(userId: pocId);
      } else {
        debugPrint("POC ID missing — notifications not loaded!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<LoggedInUserDetailsProvider>();
    final user = userProvider.userDetails;
    final notificationProvider = context.watch<NotificationProvider>();
    final notifications = notificationProvider.notifications;
    final bool hasUnread = notifications.any(
      (n) => n.status.toUpperCase() == "UNREAD",
    );
    final statusProvider = context.watch<StatusCountGpProvider>();
    final statusData = statusProvider.statusData;
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : userProvider.errorMessage != null
            ? Center(child: Text(userProvider.errorMessage!))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: Colors.black,
                                    insetPadding: EdgeInsets.zero,
                                    child: InteractiveViewer(
                                      child:
                                          user?.profilePic != null &&
                                              user!.profilePic!.isNotEmpty
                                          ? Image.network(
                                              user.profilePic!,
                                              fit: BoxFit.contain,
                                            )
                                          : Image.asset(
                                              'assets/images/people/avatar.png',
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    user?.profilePic != null &&
                                        user!.profilePic!.isNotEmpty
                                    ? NetworkImage(user.profilePic!)
                                    : const AssetImage(
                                            'assets/images/people/avatar.png',
                                          )
                                          as ImageProvider,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.CardioName ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    '${(user?.clinicName?.trim().isNotEmpty == true ? user!.clinicName!.trim() : "No Clinic")}, '
                                    '${(user?.userAddress?.trim().isNotEmpty == true ? user!.userAddress!.trim() : "No Address")}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.notification,
                          );

                          final pocId = await StorageHelper.getPocId();
                          if (pocId != null) {
                            await context
                                .read<NotificationProvider>()
                                .fetchNotifications(userId: pocId);
                          }
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEef7f5),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/homePage/notification1.svg',
                                fit: BoxFit.contain,
                              ),
                            ),

                            //  Badge
                            if (unreadCount > 0)
                              Positioned(
                                right: 5,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadCount > 9
                                        ? "9+"
                                        : unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.genSetting);
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEef7f5),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/navbar/new_setting.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //  Banner Carousel
                  Column(
                    children: [
                      FlutterCarousel(
                        items: banners.map((banner) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                banner,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        }).toList(),
                        options: FlutterCarouselOptions(
                          height: (MediaQuery.of(context).size.width * 0.35)
                              .clamp(150.0, double.infinity),
                          autoPlay: true,
                          viewportFraction: 1,
                          showIndicator: false,
                          onPageChanged: (index, reason) {
                            setState(() => _currentBanner = index);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banners.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentBanner == entry.key
                                  ? AppColors.primary
                                  : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  GradientButton(
                    text: "New Order",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.newOrder);
                    },
                  ),
                  const SizedBox(height: 20),

                  if (statusProvider.isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (statusData == null)
                    Text("No status data")
                  else
                    Column(
                      children: [
                        for (
                          var i = 0;
                          i < getDashboardCards(statusData).length;
                          i += 2
                        )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OrderCard(
                                      title: getDashboardCards(
                                        statusData,
                                      )[i]['title'],
                                      subtitle: getDashboardCards(
                                        statusData,
                                      )[i]['subtitle'],
                                      iconPath: getDashboardCards(
                                        statusData,
                                      )[i]['iconPath'],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (i + 1 <
                                      getDashboardCards(statusData).length)
                                    Expanded(
                                      child: OrderCard(
                                        title: getDashboardCards(
                                          statusData,
                                        )[i + 1]['title'],
                                        subtitle: getDashboardCards(
                                          statusData,
                                        )[i + 1]['subtitle'],
                                        iconPath: getDashboardCards(
                                          statusData,
                                        )[i + 1]['iconPath'],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
