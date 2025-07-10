import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileCard extends StatelessWidget {
  final String userName;

  const ProfileCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text('hello'.tr(args: [userName]),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('welcome_message'.tr()),
      ),
    );
  }
}
