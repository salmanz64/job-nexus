import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/core/constants/application_status_color.dart';
import 'package:jobnexus/features/Job/view/pages/candidate_details.dart';
import 'package:jobnexus/features/profile/models/profile_model.dart';

class ApplicationCardWithDropdown extends StatefulWidget {
  final String candidateName;
  final String jobTitle;
  final String candidateEmail;
  final String candidatePosition;
  String status;
  final int experience;
  final String candidateLocation;
  final String appliedDate;
  final ProfileModel candidate;

  ApplicationCardWithDropdown({
    super.key,
    required this.status,
    required this.candidateName,
    required this.candidate,
    required this.jobTitle,
    required this.candidateEmail,
    required this.candidatePosition,
    required this.experience,
    required this.candidateLocation,
    required this.appliedDate,
  });

  @override
  State<ApplicationCardWithDropdown> createState() =>
      _ApplicationCardWithDropdownState();
}

class _ApplicationCardWithDropdownState
    extends State<ApplicationCardWithDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF6E75FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.jobTitle,
              style: TextStyle(
                color: Color(0xFF6E75FF),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8),

          // Header with candidate info and status dropdown
          Row(
            children: [
              // Candidate Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF6E75FF).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.profile_circle,
                  color: Color(0xFF6E75FF),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),

              // Candidate Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.candidateName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF110e48),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.candidateEmail,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.candidatePosition,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: ApplicationStatusColors.colors[widget.status]!
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ApplicationStatusColors.colors[widget.status]!
                        .withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.status,
                    icon: Icon(
                      Iconsax.arrow_down_1,
                      size: 16,
                      color: ApplicationStatusColors.colors[widget.status]!,
                    ),
                    elevation: 2,
                    style: TextStyle(
                      color: ApplicationStatusColors.colors[widget.status]!,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          widget.status = newValue;
                        });
                        _updateApplicationStatus(newValue);
                      }
                    },
                    items:
                        <String>[
                          'applied',
                          'reviewed',
                          'shortlisted',
                          'rejected',
                          'accepted',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(value),
                                  size: 14,
                                  color: ApplicationStatusColors.colors[value]!,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  value,
                                  style: TextStyle(
                                    color:
                                        ApplicationStatusColors.colors[value]!,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Additional Info
          Row(
            children: [
              _buildInfoItem(Iconsax.briefcase, widget.experience.toString()),
              SizedBox(width: 16),
              _buildInfoItem(Iconsax.location, widget.candidateLocation),
              Spacer(),
              _buildMatchScore(73),
            ],
          ),

          SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View Profile action
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => CandidateDetailsPage(
                              candidateDetails: widget.candidate,
                            ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6E75FF),
                    side: BorderSide(color: Color(0xFF6E75FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('View Profile'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Message action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6E75FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Message', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Applied Date
          Text(
            widget.appliedDate,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildMatchScore(int score) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            '$score%',
            style: TextStyle(
              color: scoreColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 2),
          Icon(Iconsax.arrow_up_3, size: 12, color: scoreColor),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'New':
        return Iconsax.clock;
      case 'Reviewed':
        return Iconsax.eye;
      case 'Shortlisted':
        return Iconsax.tick_circle;
      case 'Rejected':
        return Iconsax.close_circle;
      case 'Hired':
        return Iconsax.award;
      default:
        return Iconsax.info_circle;
    }
  }

  void _updateApplicationStatus(String newStatus) {
    // Implement your status update logic here
    print('Updating application status to: $newStatus');

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to $newStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
