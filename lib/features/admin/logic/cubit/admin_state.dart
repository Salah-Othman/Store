part of 'admin_cubit.dart';

class AdminState {
  final bool isLoading;
  final bool isDarkMode;
  final Color scaffoldBg;
  final Color surfaceColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color primaryColor;
  final String? errorMessage;

  final List<ProductModel> products;
  final List<OrderModel> orders;
  final List<CategoryModel> categories;
  final List<DocumentSnapshot> users;
  final List<DocumentSnapshot> banners;

  final double totalRevenue;
  final int pendingOrders;
  final int successOrders;
  final bool isAdmin;

  AdminState({
    this.isLoading = true,
    this.isDarkMode = false,
    this.scaffoldBg = Colors.white,
    this.surfaceColor = Colors.white,
    this.textColor = Colors.black,
    this.textSecondaryColor = Colors.grey,
    this.primaryColor = const Color(0xFFFF6B00),
    this.errorMessage,
    this.products = const [],
    this.orders = const [],
    this.categories = const [],
    this.users = const [],
    this.banners = const [],
    this.totalRevenue = 0,
    this.pendingOrders = 0,
    this.successOrders = 0,
    this.isAdmin = false,
  });

  AdminState copyWith({
    bool? isLoading,
    bool? isDarkMode,
    Color? scaffoldBg,
    Color? surfaceColor,
    Color? textColor,
    Color? textSecondaryColor,
    Color? primaryColor,
    String? errorMessage,
    List<ProductModel>? products,
    List<OrderModel>? orders,
    List<CategoryModel>? categories,
    List<DocumentSnapshot>? users,
    List<DocumentSnapshot>? banners,
    double? totalRevenue,
    int? pendingOrders,
    int? successOrders,
    bool? isAdmin,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      primaryColor: primaryColor ?? this.primaryColor,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      categories: categories ?? this.categories,
      users: users ?? this.users,
      banners: banners ?? this.banners,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      successOrders: successOrders ?? this.successOrders,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}