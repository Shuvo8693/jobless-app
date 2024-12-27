import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobless/controllers/profile_controller/status_controller.dart';
import 'package:jobless/utils/style.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final StatusController _statusController = Get.put(StatusController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _statusController.getProfileId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('job status category show',
              style: AppStyles.customSize(
                size: 16,
                fontWeight: FontWeight.w500,
                family: "Schuyler",
              )),
          trailing: Obx(() {
            return Transform.scale(
              scale: 0.8, // Reduce the size of the Switch
              child: Switch(
                value: _statusController.isJobExperience.value,
                onChanged: (bool value) async {
                  _statusController.isJobExperience.value = value;
                  await _statusController.updateStatus();
                  setState(() {});
                },
              ),
            );
          }),
        )
      ],
    );
  }
}
