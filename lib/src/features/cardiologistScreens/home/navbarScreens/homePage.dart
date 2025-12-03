import 'package:cardio_tech/src/data/cardioLogists/model/home/statusCountCardioModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/assignCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/DashboardCard.dart';
import 'package:cardio_tech/src/features/widgets/orderDetailsCard.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/home/StatusCountCardioProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/myOrderProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/orderStatusProvider.dart';
import 'package:cardio_tech/src/provider/notificationProvider/notificationProvider.dart';
import 'package:cardio_tech/src/provider/user/loggedInUserDetailsProvider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> getCardioDashboardCards(
    StatusCountCardioModel data,
  ) {
    return [
      {
        'title': data.highPriorityOrders.toString(),
        'subtitle': 'High Priority Orders',
        'iconPath': 'assets/images/homePage/dashboard/icon2.svg',
      },
      {
        'title': data.signOff.toString(),
        'subtitle': 'Sign off',
        'iconPath': 'assets/cardiologistsIcon/icon/other/icon1.svg',
      },
      {
        'title': data.submittedOrders.toString(),
        'subtitle': 'Total Orders Assigned',
        'iconPath': 'assets/images/homePage/dashboard/icon3.svg',
      },
      {
        'title': data.finalizedOrders.toString(),
        'subtitle': 'Finalized Orders',
        'iconPath': 'assets/cardiologistsIcon/icon/other/icon2.svg',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatusCountCardioProvider>().fetchCardioStatusCounts();
    });

    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final userId = await StorageHelper.getUserId();
    if (userId != null) {
      await context
          .read<LoggedInUserDetailsProvider>()
          .fetchLoggedInUserDetails(userId: userId);
    }

    await context.read<MyOrderProvider>().fetchAllOrders();

    ///  Load notifications using POC ID (correct)
    final pocId = await StorageHelper.getPocId();
    if (pocId != null) {
      context.read<NotificationProvider>().fetchNotifications(userId: pocId);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final pocId = await StorageHelper.getPocId();
      if (pocId != null) {
        context.read<NotificationProvider>().fetchNotifications(userId: pocId);
      }

      /// Refresh orders
      context.read<MyOrderProvider>().fetchAllOrders();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleReport(BuildContext context, MyOrderModel order) async {
    final orderStatusProvider = context.read<OrderStatusProvider>();
    final myOrderProvider = context.read<MyOrderProvider>();

    if (order.orderStatus?.toUpperCase() == 'SUBMITTED') {
      final success = await orderStatusProvider.updateStatusToInReview(
        orderDetailsId: order.orderDetailsId,
        cardioPocId: order.approvalLevels?.first.approverPocId ?? 0,
      );

      if (success) {
        myOrderProvider.updateOrderStatus(order.orderDetailsId, 'IN_REVIEW');
      } else {
        SnackBarHelper.show(
          context,
          message: "Failed to update order status",
          type: SnackBarType.warning,
        );
        return;
      }
    }

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.reportOrder,
      arguments: {
        'orderId': order.orderDetailsId,
        'patientName': order.patientName,
        'clinicalNote': order.clinicalNote,
        'ekgReport': order.ekgReport,
        'approvalLevels': order.approvalLevels?.map((e) => e.toJson()).toList(),
      },
    );

    if (result == true) {
      await myOrderProvider.fetchAllOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<LoggedInUserDetailsProvider>();
    final user = userProvider.userDetails;
    final orderProvider = context.watch<MyOrderProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final notifications = notificationProvider.notifications;
    // final bool hasUnread = notifications.any(
    //   (n) => n.status.toUpperCase() == "UNREAD",
    // );

    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    final cardioStatusProvider = context.watch<StatusCountCardioProvider>();
    final cardioStatusData = cardioStatusProvider.cardioStatusData;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                // "${user?.clinicName ?? 'No Clinic'}, ${user?.userAddress ?? 'No Address'}",
                                '${(user?.clinicName.trim().isNotEmpty == true ? user!.clinicName.trim() : "No Clinic")}, '
                                '${(user?.userAddress.trim().isNotEmpty == true ? user!.userAddress.trim() : "No Address")}',
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
                                unreadCount > 9 ? "9+" : unreadCount.toString(),
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
                ],
              ),

              const SizedBox(height: 20),

              /// Dashboard Cards
              if (cardioStatusProvider.isLoading)
                Center(child: CircularProgressIndicator())
              else if (cardioStatusData == null)
                Text("No status data")
              else
                Column(
                  children: [
                    for (
                      var i = 0;
                      i < getCardioDashboardCards(cardioStatusData).length;
                      i += 2
                    )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: OrderCard(
                                  title: getCardioDashboardCards(
                                    cardioStatusData,
                                  )[i]['title'],
                                  subtitle: getCardioDashboardCards(
                                    cardioStatusData,
                                  )[i]['subtitle'],
                                  iconPath: getCardioDashboardCards(
                                    cardioStatusData,
                                  )[i]['iconPath'],
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (i + 1 <
                                  getCardioDashboardCards(
                                    cardioStatusData,
                                  ).length)
                                Expanded(
                                  child: OrderCard(
                                    title: getCardioDashboardCards(
                                      cardioStatusData,
                                    )[i + 1]['title'],
                                    subtitle: getCardioDashboardCards(
                                      cardioStatusData,
                                    )[i + 1]['subtitle'],
                                    iconPath: getCardioDashboardCards(
                                      cardioStatusData,
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

              const Text(
                "Urgent Orders",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              /// ---- Orders List ----
              Expanded(
                child: orderProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : orderProvider.orders.isEmpty
                    ? const Center(child: Text("No orders found"))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        // padding: EdgeInsets.only(
                        //   bottom:
                        //       kBottomNavigationBarHeight +
                        //       MediaQuery.of(context).padding.bottom +
                        //       40,
                        //   top: 0,
                        //   left: 0,
                        //   right: 0,
                        // ),
                        itemCount: orderProvider.orders.length,
                        itemBuilder: (context, index) {
                          final order = orderProvider.orders[index];

                          if (order.priorityName == "High Priority" &&
                              order.orderStatus?.toUpperCase() == "SUBMITTED") {
                          } else {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OrderDetailsCard(
                              image: "assets/images/people/user.png",
                              name: order.patientName ?? "",
                              age: order.age?.toString() ?? "",
                              gender: order.genderValue,
                              orderId: order.orderDetailsId.toString(),
                              referredBy: order.createdByGpName ?? "N/A",
                              hospital: order.clinicName ?? "N/A",
                              priorityName: order.priorityName,
                              orderStatus: order.orderStatus,
                              submittedOn: order.createdAt ?? '',
                              onAssign: () async {
                                final result = await showModalBottomSheet<bool>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) =>
                                      AssignCard(order: order),
                                );

                                if (result == true) {
                                  await context
                                      .read<MyOrderProvider>()
                                      .fetchAllOrders();
                                }
                              },
                              onReport: () => _handleReport(context, order),
                              onUnderProgress: () =>
                                  _handleReport(context, order),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
