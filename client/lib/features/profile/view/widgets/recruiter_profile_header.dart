import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/theme/app_pallete.dart';

class RecruiterProfileHeader extends StatelessWidget {
  final String companyName;
  final String location;
  final String industry;
  const RecruiterProfileHeader({
    super.key,
    required this.companyName,
    required this.industry,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Pallete.purpleColor, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=400&h=300&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Iconsax.building, color: Colors.grey[400]),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  industry,
                  style: TextStyle(
                    fontSize: 16,
                    color: Pallete.purpleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(location, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
