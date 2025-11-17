import 'package:flutter/material.dart';
import '../widgets/send_button.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String paymentMethod = 'Paystack';
  bool isFavorite = false;
  bool showSuccess = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    recipientController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => showSuccess = true);
    await _controller.forward();

    // keep the success card visible for a bit
    await Future.delayed(const Duration(seconds: 2));

    await _controller.reverse();
    setState(() => showSuccess = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction completed')),
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount required';
    final cleaned = value.replaceAll(',', '');
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed <= 0) return 'Enter a valid positive number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: recipientController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Recipient name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'KSh ',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Paystack', child: Text('Paystack')),
                  DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                  DropdownMenuItem(value: 'Visa', child: Text('Visa')),
                ],
                onChanged: (v) => setState(() => paymentMethod = v ?? 'Paystack'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mark as Favorite'),
                  Switch(
                    value: isFavorite,
                    onChanged: (v) => setState(() => isFavorite = v),
                  )
                ],
              ),
              const SizedBox(height: 24),
              SendButton(
                label: 'Send Money',
                onPressed: _onSend,
              ),

              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showSuccess
                    ? ScaleTransition(
                        scale: _scaleAnim,
                        child: Card(
                          key: const ValueKey('success_card'),
                          color: Colors.green[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: const [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Success! Your transaction was processed.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
