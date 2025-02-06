import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/order/order_cubit.dart';
import '../cubits/order/order_state.dart';
import '../style/text.dart';
import '../style/colors.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/models/order.dart';

class Orderline extends StatelessWidget {
  final Order order;
  final Function(Order) markOrderAsDelivered;
  final Function(Order, Customer) deleteOrder;

  const Orderline({
    super.key,
    required this.order,
    required this.markOrderAsDelivered,
    required this.deleteOrder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: order,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.lightGreen,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section with delete button and order info
            Row(
              children: [
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoaded) {
                      return IconButton(
                        onPressed: () => deleteOrder(order, order.customer),
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.grey,
                        ),
                      );
                    }
                    return const SizedBox(width: 40);
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${order.id}",
                      style: title_style,
                    ),
                    Text(
                      order.customer.name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 70, 66, 66),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Text(order.deliveryDate),

            // Delivery status icon
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () => markOrderAsDelivered(order),
                icon: Icon(
                  order.status == "delivered"
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color:
                      order.status == "delivered" ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
