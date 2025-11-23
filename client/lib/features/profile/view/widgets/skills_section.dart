import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/profile/view/widgets/main_profile_section.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;
  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return MainProfileSection(
      title: 'Skills',
      icon: Iconsax.cpu,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
      ),
    );
    ;
  }
}
