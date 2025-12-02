import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/widgets/CardioAllOrderCard.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/allOrders/CardioAllOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  String searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardioAllOrderProvider>().getallCardioOrders();
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
          "All Orders",
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
        child: Consumer<CardioAllOrderProvider>(
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
                          provider.getallCardioOrders();
                          return;
                        }

                        final isNumeric = int.tryParse(value) != null;
                        if (isNumeric) {
                          provider.getallCardioOrders(
                            orderId: int.parse(value),
                          );
                        } else {
                          provider.getallCardioOrders(patientName: value);
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

                if (!provider.isLoading && provider.cardioAllOrders.isEmpty)
                  const Expanded(
                    child: Center(child: Text("No  orders found")),
                  ),

                if (!provider.isLoading && provider.cardioAllOrders.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.cardioAllOrders.length,
                      itemBuilder: (context, index) {
                        final order = provider.cardioAllOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CardioAllOrderCard(orderModel: order),
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
