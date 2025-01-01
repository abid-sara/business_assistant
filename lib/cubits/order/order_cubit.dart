import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/models/order.dart';
import '../../models/customer.dart';
import './order_state.dart';
import './order_repository.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;
  List<Order> orders = [];
  String currentStatus = 'All';
  String currentSearchQuery = '';
  OrderCubit({required this.repository}) : super(OrderInitial());

  Future<void> loadOrders() async {
    try {
      emit(OrderLoading());
      orders = await repository.fetchOrders();
      emit(OrderLoaded(
        orders: orders,
        filteredOrders: orders,
      ));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> addOrder(Map<String, dynamic> orderData,
      List<Map<String, dynamic>> products) async {
    try {
      emit(OrderLoading());
      final orderId =
          await repository.addOrderRepo(order: orderData, products: products);

      if (orderId > 0) {
        orders = await repository.fetchOrders();

        String currentStatus = 'All';
        String currentSearch = '';

        if (state is OrderLoaded) {
          final loadedState = state as OrderLoaded;
          currentStatus = loadedState.filterStatus;
          currentSearch = loadedState.searchQuery;
        }

        emit(OrderLoaded(
          orders: orders,
          filteredOrders: orders,
          filterStatus: currentStatus,
          searchQuery: currentSearch,
        ));

        // Reapply any active filters
        await filterOrders(
          status: currentStatus != 'All' ? currentStatus : null,
          searchQuery: currentSearch.isNotEmpty ? currentSearch : null,
        );
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> markOrderAsDelivered(Order order) async {
    try {
      if (state is OrderLoaded) {
        final loadedState = state as OrderLoaded;
        currentStatus = loadedState.filterStatus;
        currentSearchQuery = loadedState.searchQuery;
      }

      emit(OrderLoading());

      final success = await repository.updateOrderStatusRepo(order.id!);
      if (success) {
        orders = await repository.fetchOrders();

        List<Order> filtered = orders;

        if (currentStatus != 'All') {
          filtered = filtered
              .where((order) =>
                  order.status.toLowerCase() == currentStatus.toLowerCase())
              .toList();
        }

        if (currentSearchQuery.isNotEmpty) {
          filtered = filtered.where((order) {
            final customerName = order.customer.name.toLowerCase();
            return order.id.toString().contains(currentSearchQuery) ||
                customerName.contains(currentSearchQuery.toLowerCase());
          }).toList();
        }

        emit(OrderLoaded(
          orders: orders,
          filteredOrders: filtered,
          filterStatus: currentStatus,
          searchQuery: currentSearchQuery,
        ));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> filterOrders({String? status, String? searchQuery}) async {
    try {
      if (state is OrderLoaded) {
        final currentState = state as OrderLoaded;
        List<Order> filtered = currentState.orders;

        currentStatus = status ?? currentState.filterStatus;
        currentSearchQuery = searchQuery ?? currentState.searchQuery;

        if (currentStatus != 'All') {
          filtered = filtered
              .where((order) =>
                  order.status.toLowerCase() == currentStatus.toLowerCase())
              .toList();
        }

        if (currentSearchQuery.isNotEmpty) {
          filtered = filtered.where((order) {
            final customerName = order.customer.name.toLowerCase();
            return order.id.toString().contains(currentSearchQuery) ||
                customerName.contains(currentSearchQuery.toLowerCase());
          }).toList();
        }

        emit(OrderLoaded(
          orders: currentState.orders,
          filteredOrders: filtered,
          filterStatus: currentStatus,
          searchQuery: currentSearchQuery,
        ));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> deleteOrder(Order order) async {
    try {
      // Store current status and search query before changing state
      String? currentStatus;
      String? currentSearchQuery;

      // Only get current filters if we're in a loaded state
      if (state is OrderLoaded) {
        final loadedState = state as OrderLoaded;
        currentStatus = loadedState.filterStatus;
        currentSearchQuery = loadedState.searchQuery;
      }

      emit(OrderLoading());

      final success =
          await repository.deleteOrderRepo(order.id!, order.customer.id!);
      if (success) {
        orders = await repository.fetchOrders();

        emit(OrderLoaded(
          orders: orders,
          filteredOrders: orders,
          filterStatus: currentStatus!,
          searchQuery: currentSearchQuery!,
        ));
        // Use the stored values instead of trying to access state
        await filterOrders(
          status: currentStatus,
          searchQuery: currentSearchQuery,
        );
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void resetOrders() {
    emit(OrderInitial());
  }

  Customer? _currentCustomer;

  void setCurrentCustomer(Customer customer) {
    _currentCustomer = customer;
  }

  Future<void> loadCustomerOrders() async {
    try {
      emit(OrderLoading());
      final customerOrders =
          await repository.fetchCustomerOrders(_currentCustomer?.id);
      orders = customerOrders;
      emit(OrderLoaded(orders: orders, filteredOrders: orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  int customerOrdersCount(int? customerId) {
    if (state is OrderLoaded) {
      final orderState = state as OrderLoaded;

      return orderState.orders
          .where(
              (order) => order.customer.id == customerId && order.deleted == 0)
          .length;
    }
    return 0; // Default to 0 if orders are not loaded
  }
}
