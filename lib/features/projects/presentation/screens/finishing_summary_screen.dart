import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/features/contracts/presentation/cubit/contracts_cubit.dart';
import 'package:apartment/features/contracts/presentation/cubit/contracts_state.dart';
import 'package:apartment/features/contracts/domain/entities/apartment_finishing_order_entity.dart';
import 'package:apartment/features/projects/presentation/widgets/summary/room_orders_section.dart';

class FinishingSummaryScreen extends StatefulWidget {
  final ProjectUnitEntity unit;
  final double totalFinishingCost;

  const FinishingSummaryScreen({
    super.key,
    required this.unit,
    required this.totalFinishingCost,
  });

  @override
  State<FinishingSummaryScreen> createState() => _FinishingSummaryScreenState();
}

class _FinishingSummaryScreenState extends State<FinishingSummaryScreen> {
  final Map<String, int> _selectedOrders = {};
  double _dynamicTotalFinishingCost = 0.0;
  bool _isOrdersLoaded = false;
  List<ApartmentFinishingOrderRoomEntity> _rooms = [];

  @override
  void initState() {
    super.initState();
    _dynamicTotalFinishingCost = widget.totalFinishingCost;
    
    // Fetch orders if we have a valid unit ID
    final unitId = int.tryParse(widget.unit.id);
    if (unitId != null) {
      context.read<ContractsCubit>().fetchFinishingOrders(unitId);
    }
  }

  void _calculateTotal() {
    double total = 0;
    for (var room in _rooms) {
      final selectedId = _selectedOrders[room.roomName];
      if (selectedId != null) {
        var order = room.orders.last;
        for (var o in room.orders) {
          if (o.id == selectedId) {
            order = o;
            break;
          }
        }
        total += double.tryParse(order.totalCost) ?? 0.0;
      }
    }
    setState(() {
      _dynamicTotalFinishingCost = total;
    });
  }

  void _onOrderSelected(String roomName, int orderId) {
    setState(() {
      _selectedOrders[roomName] = orderId;
    });
    _calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'ملخص التشطيب',
          style: TextStyle(
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ContractsCubit, ContractsState>(
        listener: (context, state) {
          if (state is FinishingOrdersLoaded) {
            _rooms = state.rooms;
            // Pre-select the last order for each room
            for (var room in _rooms) {
              if (room.orders.isNotEmpty) {
                // The last order is usually the latest one created
                _selectedOrders[room.roomName] = room.orders.last.id;
              }
            }
            _isOrdersLoaded = true;
            _calculateTotal();
          }
        },
        builder: (context, state) {
          if (state is FinishingOrdersLoading) {
            return Center(child: CircularProgressIndicator(color: context.colors.gold));
          }
          
          if (state is ContractsError && !_isOrdersLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  state.message,
                  style: TextStyle(color: context.colors.error, fontSize: AppFonts.bodyLarge),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  children: [
                    // Unit Info Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(FluentIcons.building_home_24_regular, color: context.colors.primary),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.unit.title,
                                    style: TextStyle(
                                      fontSize: AppFonts.bodyLarge,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    widget.unit.locationTypeLabel,
                                    style: TextStyle(
                                      fontSize: AppFonts.bodySmall,
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${formatter.format(widget.unit.price).trim()} ${l10n.sar}',
                              style: TextStyle(
                                fontSize: AppFonts.bodyMedium,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Details Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        'طلبات التشطيب الخاصة بك',
                        style: TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    if (_isOrdersLoaded && _rooms.isNotEmpty) ...[
                      // List of rooms and their orders
                      ..._rooms.map((room) => RoomOrdersSection(
                            room: room,
                            selectedOrderId: _selectedOrders[room.roomName],
                            onOrderSelected: (orderId) => _onOrderSelected(room.roomName, orderId),
                          )),
                    ] else ...[
                      // Fallback Finishing Details if no orders fetched yet or none exist
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: context.colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'إجمالي التكلفة الإضافية',
                                    style: TextStyle(
                                      fontSize: AppFonts.bodyLarge,
                                      color: context.colors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '+${formatter.format(_dynamicTotalFinishingCost).trim()} ${l10n.sar}',
                                    style: TextStyle(
                                      fontSize: AppFonts.bodyLarge,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Grand Total & Submit
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: context.colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الإجمالي النهائي (الوحدة + التشطيب)',
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${formatter.format(widget.unit.price + _dynamicTotalFinishingCost).trim()} ${l10n.sar}',
                        style: TextStyle(
                          fontSize: AppFonts.displaySmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.gold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            AppRouter.contractsReview,
                            extra: {
                              'totalFinishingCost': _dynamicTotalFinishingCost,
                              'unit': widget.unit,
                              'selectedFinishingOrderIds': _selectedOrders.values.toList(),
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                        child: Text(
                          l10n.reviewAndSignContracts,
                          style: const TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
