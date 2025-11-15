import 'package:flutter/material.dart';
import 'package:jobnexus/features/applications/view/widgets/application_card.dart';

class CandidateApplication extends StatelessWidget {
  const CandidateApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Your \nApplications",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sans-serif',
                          color: Color(0XFF110e48),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.2,
                                ), // darker bottom shadow
                                offset: const Offset(
                                  0,
                                  5,
                                ), // move shadow downward
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),

                              hintText: 'Search Applications',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF6E75FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ApplicationCard();
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 0.4);
                    },
                    itemCount: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
