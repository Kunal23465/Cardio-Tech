import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/provider/common/clinicDetailsProvider/clinicDetailsProvider.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ClinicDetails extends StatefulWidget {
  const ClinicDetails({super.key});

  @override
  State<ClinicDetails> createState() => _ClinicDetailsState();
}

class _ClinicDetailsState extends State<ClinicDetails> {
  @override
  void initState() {
    super.initState();
    _loadClinicDetails();
  }

  Future<void> _loadClinicDetails() async {
    final userId = await StorageHelper.getUserId();
    if (userId != null && mounted) {
      Provider.of<ClinicDetailsProvider>(
        context,
        listen: false,
      ).fetchClinicDetails(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClinicDetailsProvider>(context);
    final clinic = provider.clinicDetails;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Clinic Details",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // About Clinic
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "About Clinic",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          clinic?.aboutClinic ?? "No Data",
                          style: const TextStyle(
                            // fontSize: 14,
                            // color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Clinic Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _clinicDetailsCard(
                          icon: "assets/images/setting/myProfile/hospital.svg",
                          text: clinic?.clinicName ?? "No Clinic",
                        ),
                        _clinicDetailsCard(
                          icon: "assets/images/setting/myProfile/lic.svg",
                          text: clinic?.licenseNo ?? "No License No",
                        ),
                        _clinicDetailsCard(
                          icon: "assets/images/setting/myProfile/msg.svg",
                          text: clinic?.email ?? "No Email",
                        ),
                        _clinicDetailsCard(
                          icon: "assets/images/setting/myProfile/call.svg",
                          text: clinic?.phone ?? "No Phone",
                        ),
                        _clinicDetailsCard(
                          icon: "assets/images/setting/myProfile/location.svg",
                          text: clinic?.address ?? "No Address",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _clinicDetailsCard({required String icon, required String text}) {
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
          child: Center(child: SvgPicture.asset(icon, fit: BoxFit.scaleDown)),
        ),
        title: Text(text),
      ),
    );
  }
}
