import 'package:cardio_tech/src/provider/user/loggedInUserDetailsProvider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:provider/provider.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userId = await StorageHelper.getUserId();
      if (userId != null) {
        context.read<LoggedInUserDetailsProvider>().fetchLoggedInUserDetails(
          userId: userId,
        );
      } else {
        debugPrint(" User ID not found in storage");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<LoggedInUserDetailsProvider>();
    final user = userProvider.userDetails;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
        ),

        title: Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
            icon: SvgPicture.asset('assets/images/setting/editbutton.svg'),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: AppColors.primary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ---------------- Profile Header ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Image with Zoom
                  GestureDetector(
                    onTap: () {
                      if (user?.profilePic != null &&
                          user!.profilePic!.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.black,
                            child: InteractiveViewer(
                              child: Image.network(
                                user.profilePic!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image:
                              (user?.profilePic != null &&
                                  user!.profilePic!.isNotEmpty)
                              ? NetworkImage(user.profilePic!)
                              : const AssetImage(
                                      "assets/images/people/avatar.png",
                                    )
                                    as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Gradient + Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.CardioName ?? "Unknown",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.cardioValue ?? "Unknown",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Info Boxes ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _infoBox(
                      'assets/images/setting/myProfile/license.svg',
                      user?.licenseNo ?? "Unknown",
                      "Lic No.",
                    ),
                  ),

                  _divider(),

                  Expanded(
                    child: _infoBox(
                      'assets/images/setting/myProfile/task-done.svg',
                      user?.totalExperience ?? "Unknown",
                      "Experience",
                    ),
                  ),

                  _divider(),

                  Expanded(
                    child: _infoBox(
                      'assets/images/setting/myProfile/profile-fill.svg',
                      user?.totalOrders.toString() ?? "Unknown",
                      "Patients",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- About Section ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About Me",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user?.about ?? "No Data",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Contact Cards ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _contactCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/msg.svg',
                    ),
                    text: user?.email ?? "No Data",
                  ),

                  _contactCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/call.svg',
                    ),
                    text: user?.mobile ?? "No Data",
                  ),

                  _contactCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/hospital.svg',
                    ),
                    text: user?.clinicName ?? "No Data",
                  ),

                  _contactCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/location.svg',
                    ),
                    text: user?.userAddress ?? "No Data",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Divider ----------------
  Widget _divider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade400);
  }

  // ---------------- Info Box (Responsive + Fixed) ----------------
  Widget _infoBox(String svgPath, String value, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFEef7f5),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(svgPath),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Contact Card ----------------
  Widget _contactCard({required SvgPicture icon, required String text}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 14),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),

      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEef7f5),
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),

        title: Text(text),
      ),
    );
  }
}
