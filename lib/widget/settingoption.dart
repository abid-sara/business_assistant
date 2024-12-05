import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isNotificationOption; // New property to distinguish Notifications
  final bool? isNotificationEnabled; // To track notification toggle state (for Notifications)
  final Function(bool)? onNotificationToggle; // Function to handle toggle change

  const SettingsOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isNotificationOption = false, // Defaults to false for other settings
    this.isNotificationEnabled, // Only for Notification settings
    this.onNotificationToggle, // Only for Notification settings
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            Row(
              children: [
                Icon(icon, color: const Color.fromARGB(255, 69, 67, 67)),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            isNotificationOption
                ? Switch(
                    value: isNotificationEnabled ?? false, // Toggle the notification state
                    onChanged: onNotificationToggle, // Handle toggle change
                    activeColor: AppColors.darkGreen,
                  )
                : const Icon(Icons.arrow_forward_ios, size: 20, color: Color.fromARGB(255, 69, 67, 67)),
          ],
        ),
      ),
    );
  }
}
