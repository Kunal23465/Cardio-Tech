import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/widgets/orderDetailsCard.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/finalizedProvider/finalizedProvider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Finalized extends StatefulWidget {
  const Finalized({super.key});

  @override
  State<Finalized> createState() => _FinalizedState();
}

class _FinalizedState extends State<Finalized> {
  String searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinalizedOrderProvider>().getFinalizedOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Finalized Orders",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1, color: AppColors.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Consumer<FinalizedOrderProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() => searchText = value);

                        if (value.isEmpty) {
                          provider.getFinalizedOrders();
                          return;
                        }

                        final isNumeric = int.tryParse(value) != null;
                        if (isNumeric) {
                          provider.getFinalizedOrders(
                            orderId: int.parse(value),
                          );
                        } else {
                          provider.getFinalizedOrders(patientName: value);
                        }
                      },

                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        ),
                        hintText: "Search by patient name, order id",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                if (provider.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (!provider.isLoading && provider.finalizedOrders.isEmpty)
                  const Expanded(
                    child: Center(child: Text("No finalized orders found")),
                  ),

                if (!provider.isLoading && provider.finalizedOrders.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.finalizedOrders.length,
                      itemBuilder: (context, index) {
                        final order = provider.finalizedOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderDetailsCard(
                            image: "assets/images/people/user.png",
                            name: order.patientName,
                            age: order.age?.toString() ?? "",
                            gender: order.genderValue ?? "",
                            orderId: order.orderDetailsId.toString(),
                            referredBy: order.referredByGpName ?? '',
                            hospital: order.clinicName,
                            priorityName: order.priorityName ?? '',
                            orderStatus: order.orderStatus ?? '',
                            submittedOn: order.createdAt ?? '',
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
