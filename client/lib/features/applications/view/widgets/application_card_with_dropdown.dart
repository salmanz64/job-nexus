import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jobnexus/features/Job/view/pages/candidate_details.dart';

class ApplicationCardWithDropdown extends StatefulWidget {
  final Map<String, dynamic> application;

  const ApplicationCardWithDropdown({super.key, required this.application});

  @override
  State<ApplicationCardWithDropdown> createState() =>
      _ApplicationCardWithDropdownState();
}

class _ApplicationCardWithDropdownState
    extends State<ApplicationCardWithDropdown> {
  late String _currentStatus;
  late Color _statusColor;

  final Map<String, Color> _statusColors = {
    'New': Colors.blue,
    'Reviewed': Colors.orange,
    'Shortlisted': Colors.green,
    'Rejected': Colors.red,
    'Hired': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.application['status'];
    _statusColor = _statusColors[_currentStatus] ?? Colors.grey;
  }

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
              widget.application['jobTitle'],
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
                      widget.application['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF110e48),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.application['email'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.application['position'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _statusColor.withOpacity(0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentStatus,
                    icon: Icon(
                      Iconsax.arrow_down_1,
                      size: 16,
                      color: _statusColor,
                    ),
                    elevation: 2,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _currentStatus = newValue;
                          _statusColor = _statusColors[newValue] ?? Colors.grey;
                        });
                        _updateApplicationStatus(newValue);
                      }
                    },
                    items:
                        <String>[
                          'New',
                          'Reviewed',
                          'Shortlisted',
                          'Rejected',
                          'Hired',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(value),
                                  size: 14,
                                  color: _statusColors[value],
                                ),
                                SizedBox(width: 6),
                                Text(value),
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
              _buildInfoItem(
                Iconsax.briefcase,
                widget.application['experience'],
              ),
              SizedBox(width: 16),
              _buildInfoItem(Iconsax.location, widget.application['location']),
              Spacer(),
              _buildMatchScore(widget.application['matchScore']),
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
                            (context) =>
                                CandidateDetailsPage(candidate: mockCandidate),
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
                  child: Text('Message'),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Applied Date
          Text(
            widget.application['appliedDate'],
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
