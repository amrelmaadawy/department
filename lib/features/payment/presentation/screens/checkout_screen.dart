import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/secure_checkout_button.dart';
import '../../../../core/presentation/widgets/network_action_guard.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalFinishingCost;

  const CheckoutScreen({
    super.key,
    required this.totalFinishingCost,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.applePay;
  bool _isLoading = false;

  void _handlePayment() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay / Payment Gateway processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Navigate to success screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PaymentSuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate the amount to pay (down payment)
    final double vatAmount = widget.totalFinishingCost * 0.15;
    final double totalAmount = widget.totalFinishingCost + vatAmount;
    final double amountToPay = totalAmount * 0.20; // 20% down payment

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.checkoutTitle,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentSummaryCard(
                subtotal: widget.totalFinishingCost,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.paymentMethods,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PaymentMethodSelector(
                selectedMethod: _selectedMethod,
                onMethodChanged: (method) {
                  setState(() {
                    _selectedMethod = method;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl), // Padding for the bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: NetworkActionGuard(
        child: SecureCheckoutButton(
          amount: amountToPay,
          isLoading: _isLoading,
          onPressed: _handlePayment,
        ),
      ),
    );
  }
}
