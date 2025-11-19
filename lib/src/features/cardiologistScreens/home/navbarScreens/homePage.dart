import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/assignCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/DashboardCard.dart';
import 'package:cardio_tech/src/features/widgets/orderDetailsCard.dart';
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
  final List<Map<String, dynamic>> _dashboardCards = [
    {
      'title': '100',
      'subtitle': 'High Priority ',
      'iconPath': 'assets/images/homePage/dashboard/icon2.svg',
    },
    {
      'title': '75',
      'subtitle': 'Sign Off',
      'iconPath': 'assets/cardiologistsIcon/icon/other/icon1.svg',
    },
    {
      'title': '240',
      'subtitle': 'Total Orders Assigned',
      'iconPath': 'assets/images/homePage/dashboard/icon3.svg',
    },
    {
      'title': '180',
      'subtitle': 'Finalized Orders',
      'iconPath': 'assets/cardiologistsIcon/icon/other/icon2.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

    /// 🔥 Load notifications using POC ID (correct)
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
    final bool hasUnread = notifications.any(
      (n) => n.status.toUpperCase() == "UNREAD",
    );

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
                                  child: Image.network(
                                    user?.profilePic ?? "",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: user?.profilePic != null
                                ? NetworkImage(user!.profilePic!)
                                : const AssetImage(
                                        'assets/images/homePage/clinic.png',
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
                                "${user?.clinicName ?? ''}, ${user?.userAddress ?? ''}",
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
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEef7f5),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        hasUnread
                            ? 'assets/images/homePage/notification.svg'
                            : 'assets/images/homePage/notification1.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ---- Dashboard Cards ----
              Column(
                children: [
                  for (var i = 0; i < _dashboardCards.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OrderCard(
                              title: _dashboardCards[i]['title'] ?? '',
                              subtitle: _dashboardCards[i]['subtitle'] ?? '',
                              iconPath: _dashboardCards[i]['iconPath'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (i + 1 < _dashboardCards.length)
                            Expanded(
                              child: OrderCard(
                                title: _dashboardCards[i + 1]['title'] ?? '',
                                subtitle:
                                    _dashboardCards[i + 1]['subtitle'] ?? '',
                                iconPath:
                                    _dashboardCards[i + 1]['iconPath'] ?? '',
                              ),
                            ),
                        ],
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
                        padding: EdgeInsets.only(
                          bottom:
                              kBottomNavigationBarHeight +
                              MediaQuery.of(context).padding.bottom +
                              40,
                          top: 0,
                          left: 0,
                          right: 0,
                        ),
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
