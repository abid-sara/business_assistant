import 'package:business_assistant/models/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  final List<Order> filteredOrders;
  final String filterStatus;
  final String searchQuery;

  const OrderLoaded({
    required this.orders,
    required this.filteredOrders,
    this.filterStatus = 'All',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        orders,
        filteredOrders,
        filterStatus,
        searchQuery,
      ];

  OrderLoaded copyWith({
    List<Order>? orders,
    List<Order>? filteredOrders,
    String? filterStatus,
    String? searchQuery,
    // int? hoveredOrderId,
  }) {
    return OrderLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderDetailsLoaded extends OrderState {
  final List<Map<String, dynamic>> products;
  final double totalWithDelivery;

  const OrderDetailsLoaded({
    required this.products,
    required this.totalWithDelivery,
  });

  @override
  List<Object> get props => [products, totalWithDelivery];
}

class OrdersCountLoaded extends OrderState {
  final int count;
  const OrdersCountLoaded({
    required this.count,
  });
  @override
  List<Object> get props => [count];
}
