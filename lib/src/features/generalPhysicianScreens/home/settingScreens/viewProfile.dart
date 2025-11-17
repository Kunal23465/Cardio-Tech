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
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Stack(
                alignment: Alignment.bottomCenter,

                children: [
                  Container(
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
                                    "assets/images/setting/profile_pic.png",
                                  )
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
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

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            user?.cardioValue ?? "Unknown",

                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoBox(
                    'assets/images/setting/myProfile/license.svg',
                    user?.licenseNo ?? "Unknown",
                    "Lic No.",
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.shade500),
                  _infoBox(
                    'assets/images/setting/myProfile/task-done.svg',
                    user?.totalExperience ?? "Unknown",
                    "",
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.shade500),
                  _infoBox(
                    'assets/images/setting/myProfile/profile-fill.svg',

                    user?.totalOrders != null
                        ? user!.totalOrders.toString()
                        : "Unknown",

                    "Patients",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "About Me",

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  SizedBox(height: 8),

                  Text(
                    user?.about ?? "No Data",

                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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

  Widget _infoBox(String svgPath, String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circle background with SVG icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFEef7f5),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(svgPath),
        ),
        const SizedBox(width: 8),

        // Text (value + label)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

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
