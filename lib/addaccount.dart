import 'package:flutter/material.dart';
import 'package:bottlebucks/services/addaccountapi.dart'; // your addAccount() file

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

  Future<void> _handleAddAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "accountno": _accountController.text.trim(),
      "IFSC_code": _ifscController.text.trim(),
      "bank_name": _bankController.text.trim(),
    };

    setState(() => _isSubmitting = true);
    await addAccount(context, data);
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Bank Account",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter account number" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: "IFSC Code",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter IFSC code" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _bankController,
                decoration: const InputDecoration(
                  labelText: "Bank Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter bank name" : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleAddAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Account",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
