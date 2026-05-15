import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/admin/logic/cubit/admin_cubit.dart';
import 'package:TR/features/home/model/category_model.dart';
import 'package:TR/features/home/model/product_model.dart';
import 'package:TR/features/orders_history/model/order_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminCubit>().init(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AdminCubit>().updateTheme(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AdminCubit>().state;
    final l10n = AppLocalizations.of(context);
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
       
        title: Text(
          l10n.adminDashboard,
          style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,         
            ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, state, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AdminState state, AppLocalizations l10n) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!state.isAdmin) {
      return Center(child: Text(l10n.adminOnly, style: TextStyle(color: state.textColor)));
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!, style: TextStyle(color: state.textColor)));
    }

    final products = state.products;
    final orders = state.orders;
    final categories = state.categories;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _MetricsGrid(
          metrics: [
            _MetricData(title: l10n.totalProducts, value: products.length.toString(), icon: Icons.inventory_2_outlined),
            _MetricData(title: l10n.totalCategories, value: categories.length.toString(), icon: Icons.category_outlined),
            _MetricData(title: l10n.totalOrders, value: orders.length.toString(), icon: Icons.receipt_long_outlined),
            _MetricData(title: l10n.totalUsers, value: state.users.length.toString(), icon: Icons.people_alt_outlined),
            _MetricData(title: l10n.pendingOrdersLabel, value: state.pendingOrders.toString(), icon: Icons.schedule_outlined),
            _MetricData(title: l10n.successOrdersLabel, value: state.successOrders.toString(), icon: Icons.check_circle_outline),
          ],
          state: state,
        ),
        const SizedBox(height: 16),
        _RevenueCard(totalRevenue: state.totalRevenue, state: state, l10n: l10n),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.quickActions,
          state: state,
          child: _QuickActions(
            onAddProduct: () => _showAddProductDialog(context, categories),
            onAddCategory: () => _showAddCategoryDialog(context),
            onAddBanner: () => _showAddBannerDialog(context),
            l10n: l10n,
          ),
        ),
        const SizedBox(height: 24),
        _SectionCard(
          title: l10n.pendingOrdersLabel,
          state: state,
          child: orders.where((o) => o.status == 'Pending').isEmpty
              ? _EmptyState(message: l10n.noOrdersFound, state: state)
              : Column(children: orders.where((o) => o.status == 'Pending').take(5).map((o) => _OrderRow(order: o, state: state, l10n: l10n)).toList()),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.successOrdersLabel,
          state: state,
          child: orders.where((o) => o.status == 'Success').isEmpty
              ? _EmptyState(message: l10n.noOrdersFound, state: state)
              : Column(children: orders.where((o) => o.status == 'Success').take(5).map((o) => _OrderRow(order: o, state: state, l10n: l10n)).toList()),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.productCatalog,
          state: state,
          child: products.isEmpty
              ? _EmptyState(message: l10n.adminNoProducts, state: state)
              : Column(children: products.take(6).map((p) => _ProductRow(product: p, allowAdminActions: true, state: state, l10n: l10n, onDelete: () => context.read<AdminCubit>().deleteProduct(p.id))).toList()),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.categoryCatalog,
          state: state,
          child: categories.isEmpty
              ? _EmptyState(message: l10n.adminNoCategories, state: state)
              : Column(children: categories.take(6).map((c) => _CategoryRow(category: c, allowAdminActions: true, state: state, l10n: l10n, onDelete: () => context.read<AdminCubit>().deleteCategory(c.id))).toList()),
        ),
      ],
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
          title: 
          Text(
          l10n.addCategory,
          style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,         
            ),
        ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.categoryName),
                  validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: l10n.imageUrl),
                  validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await context.read<AdminCubit>().addCategory(nameController.text.trim(), imageController.text.trim());
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddProductDialog(BuildContext context, List<CategoryModel> categories) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();
    var selectedCategory = categories.isNotEmpty ? categories.first.name : 'General';
    var isAvailable = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:           Text(
          l10n.addProduct,
          style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,         
            ),
        ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: l10n.productName),
                        validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(labelText: l10n.description),
                        validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: l10n.price),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return l10n.requiredField;
                          if (double.tryParse(value.trim()) == null) return l10n.price;
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(labelText: l10n.imageUrl),
                        validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: InputDecoration(labelText: l10n.categoryName),
                        items: (categories.isEmpty ? [CategoryModel(id: 'general', name: 'General', imageUrl: '')] : categories)
                            .map((c) => DropdownMenuItem(value: c.name, child: Text(c.name)))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.availability),
                        value: isAvailable,
                        onChanged: (value) => setState(() => isAvailable = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    await context.read<AdminCubit>().addProduct(
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      price: double.parse(priceController.text.trim()),
                      imageUrl: imageController.text.trim(),
                      category: selectedCategory,
                      isAvailable: isAvailable,
                    );
                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
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

  Future<void> _showAddBannerDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final imageController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:           Text(
          l10n.addBanner,
          style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,         
            ),
        ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: imageController,
              decoration: InputDecoration(labelText: l10n.imageUrl),
              validator: (value) => value == null || value.trim().isEmpty ? l10n.requiredField : null,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await context.read<AdminCubit>().addBanner(imageController.text.trim());
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }
}

class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  const _MetricData({required this.title, required this.value, required this.icon});
}

class _MetricsGrid extends StatelessWidget {
  final List<_MetricData> metrics;
  final AdminState state;

  const _MetricsGrid({required this.metrics, required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: state.surfaceColor, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(metric.icon, color: state.textColor),
              Text(metric.value, style: GoogleFonts.notoSerif(fontSize: 24, fontWeight: FontWeight.bold, color: state.textColor)),
              Text(metric.title, style: GoogleFonts.manrope(color: state.textColor, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double totalRevenue;
  final AdminState state;
  final AppLocalizations l10n;

  const _RevenueCard({required this.totalRevenue, required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [state.primaryColor, AppTheme.tertiaryColor]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.totalRevenue, style: GoogleFonts.manrope(color: Colors.white70)),
          const SizedBox(height: 8),
          Text("${totalRevenue.toStringAsFixed(2)} EGP", style: GoogleFonts.notoSerif(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final AdminState state;
  final Widget child;

  const _SectionCard({required this.title, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: state.surfaceColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    Text(
          title,
          style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,         
            ),
        ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onAddCategory;
  final VoidCallback onAddBanner;
  final AppLocalizations l10n;

  const _QuickActions({required this.onAddProduct, required this.onAddCategory, required this.onAddBanner, required this.l10n});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: ElevatedButton.icon(onPressed: onAddProduct, icon: const Icon(Icons.add_box_outlined), label: Text(l10n.addProduct))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: onAddCategory, icon: const Icon(Icons.add_circle_outline), label: Text(l10n.addCategory))),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onAddBanner, icon: const Icon(Icons.image_outlined), label: Text(l10n.addBanner))),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final AdminState state;
  const _EmptyState({required this.message, required this.state});

  @override
  Widget build(BuildContext context) => Center(child: Text(message, style: TextStyle(color: state.textSecondaryColor)));
}

class _OrderRow extends StatelessWidget {
  final OrderModel order;
  final AdminState state;
  final AppLocalizations l10n;

  const _OrderRow({required this.order, required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).languageCode;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: state.primaryColor.withValues(alpha: 0.18), child: Icon(Icons.receipt_long, color: state.textColor)),
      title: Text(l10n.orderNumber(order.id.length >= 8 ? order.id.substring(0, 8) : order.id)),
      subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a', localeName).format(order.createdAt)),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final ProductModel product;
  final bool allowAdminActions;
  final AdminState state;
  final AppLocalizations l10n;
  final VoidCallback onDelete;

  const _ProductRow({required this.product, required this.allowAdminActions, required this.state, required this.l10n, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      subtitle: Text(product.category),
      trailing: allowAdminActions
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [PopupMenuItem(value: 'delete', child: Text(l10n.delete))],
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("${product.price.toStringAsFixed(2)} EGP"),
                Text(product.isAvailable ? l10n.available : l10n.outOfStock, style: TextStyle(fontSize: 12, color: product.isAvailable ? AppTheme.success : AppTheme.error)),
              ]),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${product.price.toStringAsFixed(2)} EGP"),
              Text(product.isAvailable ? l10n.available : l10n.outOfStock, style: TextStyle(fontSize: 12)),
            ]),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryModel category;
  final bool allowAdminActions;
  final AdminState state;
  final AppLocalizations l10n;
  final VoidCallback onDelete;

  const _CategoryRow({required this.category, required this.allowAdminActions, required this.state, required this.l10n, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundImage: category.imageUrl.isNotEmpty ? NetworkImage(category.imageUrl) : null, child: category.imageUrl.isEmpty ? const Icon(Icons.category) : null),
      title: Text(category.name),
      trailing: allowAdminActions
          ? IconButton(icon: const Icon(Icons.delete), onPressed: () => onDelete())
          : null,
    );
  }
}
