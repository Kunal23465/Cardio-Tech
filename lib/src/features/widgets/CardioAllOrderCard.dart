import 'package:cardio_tech/src/data/cardioLogists/model/allOrders/cardioAllOrderModel.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';

class CardioAllOrderCard extends StatelessWidget {
  final CardioAllOrderModel orderModel;

  const CardioAllOrderCard({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    Widget buildStatusButton() {
      String buttonText = orderModel.orderStatus == "FINALIZED_VIEW"
          // ? "Order Close"
          ? " Close"
          : orderModel.orderStatus;

      return GradientButton(
        height: 30,
        width: 110,
        text: buttonText,
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.allOrderOrderDetails,
            arguments: orderModel,
          );
        },
      );
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
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage("assets/images/people/user.png"),
              ),
              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  orderModel.patientName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text("| ${orderModel.age}yr"),
                              SizedBox(width: 6),
                              Text("| ${orderModel.genderValue}"),
                            ],
                          ),
                        ),

                        if (orderModel.priorityName == 'High Priority')
                          const Icon(Icons.circle, color: Colors.red, size: 10),
                      ],
                    ),

                    SizedBox(height: 5),

                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/user.svg'),
                        SizedBox(width: 4),
                        Text(
                          "Order ID : ${orderModel.orderDetailsId}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/stethoscope.svg',
                          height: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Referred By ${orderModel.createdByGpName}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/hospital.svg'),
                        SizedBox(width: 4),
                        Text(
                          orderModel.clinicName,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/status.svg'),
                        SizedBox(width: 4),
                        Text(
                          orderModel.orderStatus,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Submitted on : ${orderModel.createdAt}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ),
              buildStatusButton(),
            ],
          ),
        ],
      ),
    );
  }
}
