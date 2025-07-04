import 'package:flutter/material.dart';
import 'package:mukai/theme/theme.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController zigController = TextEditingController();
  final TextEditingController usdController = TextEditingController();
  final double exchangeRate = 36.0;
  String? errorMessage;

  void convertZigToUsd(String zigText) {
    setState(() {
      errorMessage = null;
      if (zigText.isEmpty) {
        usdController.clear();
        return;
      }

      try {
        final zigValue = double.parse(zigText);
        final usdValue = zigValue / exchangeRate;
        usdController.text = usdValue.toStringAsFixed(2);
      } catch (e) {
        errorMessage = 'Please enter a valid number for Zig';
        usdController.clear();
      }
    });
  }

  void convertUsdToZig(String usdText) {
    setState(() {
      errorMessage = null;
      if (usdText.isEmpty) {
        zigController.clear();
        return;
      }

      try {
        final usdValue = double.parse(usdText);
        final zigValue = usdValue * exchangeRate;
        zigController.text = zigValue.toStringAsFixed(2);
      } catch (e) {
        errorMessage = 'Please enter a valid number for USD';
        zigController.clear();
      }
    });
  }

  @override
  void dispose() {
    zigController.dispose();
    usdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
        centerTitle: false,
        title: const Text(
          'Zig ↔ USD Converter',
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Exchange Rate: 1 USD = 36 Zig',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CurrencyInputField(
              label: 'Zig',
              controller: zigController,
              onChanged: convertZigToUsd,
              prefix: 'ZIG',
            ),
            const SizedBox(height: 20),
            CurrencyInputField(
              label: 'US Dollars',
              controller: usdController,
              onChanged: convertUsdToZig,
              prefix: '\$',
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CurrencyInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String prefix;

  const CurrencyInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: '$prefix ',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }
}
