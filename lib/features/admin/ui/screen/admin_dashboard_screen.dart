import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text(
          l10n.adminDashboard,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, productSnapshot) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
            builder: (context, orderSnapshot) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder: (context, userSnapshot) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .snapshots(),
                    builder: (context, categorySnapshot) {
                      if (productSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          orderSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          userSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          categorySnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (productSnapshot.hasError ||
                          orderSnapshot.hasError ||
                          userSnapshot.hasError ||
                          categorySnapshot.hasError) {
                        return Center(
                          child: Text(l10n.adminDashboardLoadError),
                        );
                      }

                      final products = (productSnapshot.data?.docs ?? [])
                          .map(
                            (doc) =>
                                ProductModel.fromFirestore(doc.data(), doc.id),
                          )
                          .toList();
                      final orders =
                          (orderSnapshot.data?.docs ?? [])
                              .map(
                                (doc) => OrderModel.fromFirestore(
                                  doc.data(),
                                  doc.id,
                                ),
                              )
                              .toList()
                            ..sort(
                              (a, b) => b.createdAt.compareTo(a.createdAt),
                            );
                      final users = userSnapshot.data?.docs ?? [];
                      final categories = (categorySnapshot.data?.docs ?? [])
                          .map(
                            (doc) =>
                                CategoryModel.fromFirestore(doc.data(), doc.id),
                          )
                          .toList();

                      final totalRevenue = orders.fold<double>(
                        0,
                        (sum, order) => sum + order.totalPrice,
                      );
                      final pendingOrders = orders
                          .where((order) => order.status == 'Pending')
                          .length;

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _MetricsGrid(
                            metrics: [
                              _MetricData(
                                title: l10n.totalProducts,
                                value: products.length.toString(),
                                icon: Icons.inventory_2_outlined,
                              ),
                              _MetricData(
                                title: l10n.totalCategories,
                                value: categories.length.toString(),
                                icon: Icons.category_outlined,
                              ),
                              _MetricData(
                                title: l10n.totalOrders,
                                value: orders.length.toString(),
                                icon: Icons.receipt_long_outlined,
                              ),
                              _MetricData(
                                title: l10n.totalUsers,
                                value: users.length.toString(),
                                icon: Icons.people_alt_outlined,
                              ),
                              _MetricData(
                                title: l10n.pendingOrdersLabel,
                                value: pendingOrders.toString(),
                                icon: Icons.schedule_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _RevenueCard(totalRevenue: totalRevenue),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: l10n.quickActions,
                            child: _QuickActions(
                              onAddProduct: () =>
                                  _showAddProductDialog(context, categories),
                              onAddCategory: () =>
                                  _showAddCategoryDialog(context),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _SectionCard(
                            title: l10n.recentOrders,
                            child: orders.isEmpty
                                ? _EmptyState(message: l10n.noOrdersFound)
                                : Column(
                                    children: orders.take(5).map((order) {
                                      return _OrderRow(order: order);
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: l10n.productCatalog,
                            child: products.isEmpty
                                ? _EmptyState(message: l10n.adminNoProducts)
                                : Column(
                                    children: products.take(6).map((product) {
                                      return _ProductRow(product: product);
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: l10n.categoryCatalog,
                            child: categories.isEmpty
                                ? _EmptyState(message: l10n.adminNoCategories)
                                : Column(
                                    children: categories.take(6).map((
                                      category,
                                    ) {
                                      return _CategoryRow(category: category);
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: l10n.customerAccounts,
                            child: users.isEmpty
                                ? _EmptyState(message: l10n.adminNoUsers)
                                : Column(
                                    children: users.take(8).map((doc) {
                                      return _UserRow(
                                        userId: doc.id,
                                        data: doc.data(),
                                        isCurrentUser: doc.id == currentUserId,
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final imageController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.addCategory),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.categoryName),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.requiredField
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: l10n.imageUrl),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.requiredField
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                await FirebaseFirestore.instance.collection('category').add({
                  'name': nameController.text.trim(),
                  'imageUrl': imageController.text.trim(),
                });

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.categoryAdded)));
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddProductDialog(
    BuildContext context,
    List<CategoryModel> categories,
  ) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();
    var selectedCategory = categories.isNotEmpty
        ? categories.first.name
        : 'General';
    var isAvailable = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.addProduct),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: l10n.productName,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? l10n.requiredField
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? l10n.requiredField
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(labelText: l10n.price),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.requiredField;
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return l10n.price;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(labelText: l10n.imageUrl),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? l10n.requiredField
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(
                          labelText: l10n.categoryName,
                        ),
                        items:
                            (categories.isEmpty
                                    ? [
                                        CategoryModel(
                                          id: 'general',
                                          name: 'General',
                                          imageUrl: '',
                                        ),
                                      ]
                                    : categories)
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category.name,
                                    child: Text(category.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.availability),
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    await FirebaseFirestore.instance
                        .collection('products')
                        .add({
                          'name': nameController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'price': double.parse(priceController.text.trim()),
                          'imageUrl': imageController.text.trim(),
                          'category': selectedCategory,
                          'isAvailable': isAvailable,
                        });

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.productAdded)));
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<_MetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(metric.icon, color: AppTheme.primaryColor),
              Text(
                metric.value,
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                metric.title,
                style: GoogleFonts.manrope(
                  color: AppTheme.tertiaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.totalRevenue});

  final double totalRevenue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.tertiaryColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalRevenue,
            style: GoogleFonts.manrope(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "${totalRevenue.toStringAsFixed(2)} EGP",
            style: GoogleFonts.notoSerif(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onAddProduct,
    required this.onAddCategory,
  });

  final VoidCallback onAddProduct;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddProduct,
            icon: const Icon(Icons.add_box_outlined),
            label: Text(l10n.addProduct),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddCategory,
            icon: const Icon(Icons.add_circle_outline),
            label: Text(l10n.addCategory),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final OrderModel order;

  void _showOrderDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).languageCode;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.orderDetails,
                    style: GoogleFonts.notoSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    label: l10n.createdAtLabel,
                    value: DateFormat(
                      'dd MMM yyyy, hh:mm a',
                      localeName,
                    ).format(order.createdAt),
                  ),
                  _DetailRow(
                    label: l10n.customerName,
                    value: order.customerName,
                  ),
                  _DetailRow(
                    label: l10n.customerPhone,
                    value: order.customerPhone,
                  ),
                  _DetailRow(
                    label: l10n.customerAddress,
                    value: order.customerAddress,
                  ),
                  _DetailRow(
                    label: l10n.statusLabel,
                    value: l10n.localizedOrderStatus(order.status),
                  ),
                  _DetailRow(
                    label: l10n.totalPriceLabel,
                    value: "${order.totalPrice.toStringAsFixed(2)} EGP",
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.orderItems,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...order.items.map((item) {
                    final itemMap = Map<String, dynamic>.from(item as Map);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.neutralColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow(
                            label: l10n.itemName,
                            value: itemMap['name']?.toString() ?? '-',
                          ),
                          _DetailRow(
                            label: l10n.itemPrice,
                            value: "${itemMap['price'] ?? 0} EGP",
                          ),
                          _DetailRow(
                            label: l10n.quantity,
                            value: "${itemMap['quantity'] ?? 0}",
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).languageCode;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.18),
        child: const Icon(Icons.receipt_long, color: AppTheme.primaryColor),
      ),
      title: Text(
        l10n.orderNumber(order.id.substring(0, 8)),
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        DateFormat('dd MMM yyyy, hh:mm a', localeName).format(order.createdAt),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${order.totalPrice.toStringAsFixed(2)} EGP",
            style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          ),
          Text(
            l10n.localizedOrderStatus(order.status),
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
      onTap: () => _showOrderDetails(context),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.manrope(color: AppTheme.tertiaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppTheme.neutralColor,
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(
        product.name,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(product.category),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${product.price.toStringAsFixed(2)} EGP",
            style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          ),
          Text(
            product.isAvailable ? l10n.available : l10n.outOfStock,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: product.isAvailable ? AppTheme.success : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppTheme.neutralColor,
        backgroundImage: NetworkImage(category.imageUrl),
      ),
      title: Text(
        category.name,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(category.id),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.userId,
    required this.data,
    required this.isCurrentUser,
  });

  final String userId;
  final Map<String, dynamic> data;
  final bool isCurrentUser;

  Future<void> _updateRole(BuildContext context, String role) async {
    final l10n = AppLocalizations.of(context);

    if (isCurrentUser) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cannotUpdateOwnRole)));
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'role': role,
      'isAdmin': role == 'admin',
    });

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.roleUpdated)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role =
        (data['role'] as String?) ??
        ((data['isAdmin'] == true) ? 'admin' : 'user');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppTheme.neutralColor,
        child: const Icon(Icons.person_outline, color: AppTheme.primaryColor),
      ),
      title: Text(
        data['name'] ?? '-',
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(data['email'] ?? '-'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _updateRole(context, value),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'admin', child: Text(l10n.makeAdmin)),
          PopupMenuItem(value: 'user', child: Text(l10n.makeUser)),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              data['phoneNumber'] ?? '-',
              style: GoogleFonts.manrope(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: role == 'admin'
                    ? AppTheme.secondaryColor.withValues(alpha: 0.18)
                    : AppTheme.neutralColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                role == 'admin' ? l10n.adminRole : l10n.userRole,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: role == 'admin'
                      ? AppTheme.primaryColor
                      : AppTheme.tertiaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: Text(message)),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;
}
