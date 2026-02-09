import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/branding/colors.dart';

class ResultUploadScreen extends StatefulWidget {
  const ResultUploadScreen({super.key});

  @override
  State<ResultUploadScreen> createState() => _ResultUploadScreenState();
}

class _ResultUploadScreenState extends State<ResultUploadScreen> {
  int _currentStep = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UPLOAD RESULTS")),
      body: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.backgroundBlack,
          colorScheme: const ColorScheme.dark(primary: AppColors.fairRed),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) setState(() => _currentStep++);
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep == 2 ? "SUBMIT" : "NEXT")),
                  const SizedBox(width: 12),
                  if (_currentStep != 0)
                    TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text("BACK")),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text("Upload Screenshot"),
              content: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Gallery only as per requirements
                      await _picker.pickImage(source: ImageSource.gallery);
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.textGrey,
                            style: BorderStyle.solid,
                            width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image,
                              size: 40, color: AppColors.textGrey),
                          Text("Tap to select Proof",
                              style: TextStyle(color: AppColors.textGrey))
                        ],
                      )),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text("Verify Positions"),
              content: const TextField(
                decoration:
                    InputDecoration(labelText: "Enter Winner Team Name"),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text("Confirm & Distribute"),
              content: const Text(
                  "This action will auto-credit wallets. This cannot be undone."),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}
