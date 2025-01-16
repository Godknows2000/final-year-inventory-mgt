import 'package:flutter/material.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/model/shift_model.dart';
import 'package:salespro_admin/session_manager.dart';

class ShiftManagement extends StatefulWidget {
  const ShiftManagement({super.key});

  static const String route = '/shiftManagement';

  @override
  State<ShiftManagement> createState() => _ShiftManagementState();
}

class _ShiftManagementState extends State<ShiftManagement> {
  final TextEditingController _openAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String headingText = "Open New Shift";
    String labelText = "Opening Amount";
    String hindText = "Enter opening amount";

    if (SessionManager.currentShift != null) {
      headingText = "Close Shift";
      labelText = "Closing Amount";
      hindText = "Enter closing amount";
    }
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (SessionManager.currentShift != null &&
                SessionManager.currentShift!.closeAmount == null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current Open Shift:",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text("Shift ID: ${SessionManager.currentShift!.id}"),
                      Text("User ID: ${SessionManager.currentShift!.userId}"),
                      Text(
                          "Open Date: ${SessionManager.currentShift!.openDate}"),
                      Text(
                          "Open Amount: \$${SessionManager.currentShift!.openAmount}"),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              headingText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _openAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hindText,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final openAmount = double.tryParse(_openAmountController.text);
                if (openAmount == null || openAmount < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid amount."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (SessionManager.currentShift == null) {
                  setState(() {
                    SessionManager.currentShift = ShiftModel(
                      openDate: DateTime.now(),
                      userId: "user123", // Example user ID, replace with actual
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      openAmount: openAmount,
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Shift opened successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  setState(() {
                    SessionManager.currentShift = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Shift closed successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.popUntil(
                      context, ModalRoute.withName(MtHomeScreen.route));
                }
              },
              child: Text(headingText),
            ),
          ],
        ),
      ),
    );
  }
}
