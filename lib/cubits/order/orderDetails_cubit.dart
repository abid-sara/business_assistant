import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import '../../models/order.dart';
import './order_state.dart';
import './order_repository.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderDetailsCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderDetailsCubit({required this.repository}) : super(OrderInitial());

  Future<void> loadOrderDetails(int orderId) async {
    try {
      emit(OrderLoading());
      final products = await repository.getProductsForOrderRepo(orderId);
      final totalWithDelivery =
          await repository.getTotalWithDeliveryRepo(orderId);

      final formattedProducts = products.map((entry) {
        final name = entry["name"]?.toString() ?? "Unknown Product";
        final unitPrice = (entry["unit_price"] as num?)?.toDouble() ?? 0.0;
        final quantity = (entry["quantity"] as num?)?.toInt() ?? 0;
        final total = double.parse((unitPrice * quantity).toStringAsFixed(1));
        return {
          'name': name,
          'unitPrice': unitPrice,
          'quantity': quantity,
          'total': total,
        };
      }).toList();

      emit(OrderDetailsLoaded(
        products: formattedProducts,
        totalWithDelivery: totalWithDelivery,
      ));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<Uint8List> generateOrderPdf(Order order) async {
    try {
      final pdf = pw.Document();
      final totalPriceOfProduct =
          await repository.getTotalWithDeliveryRepo(order.id!);
      final products = await repository.getProductsForOrderRepo(order.id!);

      final productData = products.map((entry) {
        final name = entry["name"]?.toString() ?? "Unknown Product";
        final unitPrice = (entry["unit_price"] as num?)?.toDouble() ?? 0.0;
        final quantity = (entry["quantity"] as num?)?.toInt() ?? 0;
        final total = unitPrice * quantity;

        return [
          name,
          unitPrice.toStringAsFixed(2), // Format to 2 decimal places
          quantity.toString(),
          total.toStringAsFixed(2), // Format to 2 decimal places
        ];
      }).toList();

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Order Details',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Order Code: ${order.id}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Customer: ${order.customer.name}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Order Date: ${order.orderDate}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Delivery Date: ${order.deliveryDate}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Delivery Address: ${order.deliveryAddress}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text(
                    'Delivery Price: ${order.deliveryPrice.toStringAsFixed(2)}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 20),
                pw.Text('Items:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Item', 'Unit Price', 'Quantity', 'Total'],
                  data: productData,
                ),
                pw.SizedBox(height: 20),
                pw.Text('Total Price: ${order.totalPrice.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    'Total Price with Delivery: ${totalPriceOfProduct.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                pw.Text("Generated on: ${DateTime.now()}"),
                pw.Text("Thank you for the order"),
                pw.Text(
                  "Business Assistant",
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green),
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}
