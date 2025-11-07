import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';

class OrderDetailsCard extends StatelessWidget {
  final String image;
  final String name;
  final String orderId;
  final String hospital;
  final String referredBy;
  final String submittedOn;
  final String? orderStatus;
  final VoidCallback? onAssign;
  final VoidCallback? onReport;
  final VoidCallback? onUnderProgress;
  final VoidCallback? onFinalized;

  const OrderDetailsCard({
    super.key,
    required this.image,
    required this.name,
    required this.orderId,
    required this.hospital,
    required this.referredBy,
    required this.submittedOn,
    this.orderStatus,
    this.onAssign,
    this.onReport,
    this.onUnderProgress,
    this.onFinalized,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildStatusAction() {
      switch (orderStatus?.toUpperCase()) {
        case 'SUBMITTED':
          return Row(
            children: [
              GradientButton(
                height: 30,
                width: 90,
                text: 'Assign',
                isOutlined: true,
                onPressed: onAssign,
              ),
              const SizedBox(width: 8),
              GradientButton(
                height: 30,
                width: 90,
                text: 'Report',
                onPressed: onReport,
              ),
            ],
          );

        case 'IN_REVIEW':
          return GradientButton(
            height: 30,
            width: 120,
            text: 'Under Progress',
            onPressed: onUnderProgress,
          );

        case 'FINALIZED':
          return GradientButton(
            height: 30,
            width: 100,
            text: 'Finalized',
            onPressed: onFinalized,
          );

        default:
          return const SizedBox();
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 26, backgroundImage: AssetImage(image)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/user.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Order Id : $orderId",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/stethoscope.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Referred By $referredBy",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/hospital.svg'),
                        const SizedBox(width: 4),
                        Text(
                          hospital,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),

                    // Row(
                    //   children: [
                    //     SvgPicture.asset('assets/icon/hospital.svg'),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       hospital,
                    //       style: TextStyle(color: Colors.grey.shade700),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Submitted on : $submittedOn",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              buildStatusAction(),
            ],
          ),
        ],
      ),
    );
  }
}
