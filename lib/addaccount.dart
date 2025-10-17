import 'package:flutter/material.dart';

class Addaccount extends StatefulWidget {
  const Addaccount({super.key});

  @override
  State<Addaccount> createState() => _AddaccountState();
}

class _AddaccountState extends State<Addaccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // TODO: Replace this with your API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account added successfully!"),
        backgroundColor: Colors.deepPurple,
      ),
    );

    // Optionally clear fields
    _accountController.clear();
    _ifscController.clear();
    _bankController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bank Account"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Account Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 25),

              // Account Number
              TextFormField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Account Number",
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter account number" : null,
              ),
              const SizedBox(height: 16),

              // IFSC Code
              TextFormField(
                controller: _ifscController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: "IFSC Code",
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter IFSC code" : null,
              ),
              const SizedBox(height: 16),

              // Bank Name
              TextFormField(
                controller: _bankController,
                decoration: InputDecoration(
                  labelText: "Bank Name",
                  prefixIcon: const Icon(Icons.account_balance),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter bank name" : null,
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitAccount,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add Account",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
