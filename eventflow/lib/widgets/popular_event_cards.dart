import 'package:flutter/material.dart';
import 'package:eventflow/models/popular_event_model.dart';
import 'package:intl/intl.dart';

class PopularEventCards extends StatelessWidget {
  const PopularEventCards({
    super.key,
    required this.popularEvents,
  });

  final List<PopularEventModel> popularEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Popular',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () {
                
          },
          child: Container(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(),
              itemCount: popularEvents.length,
              padding: EdgeInsets.only(
                left: 20,
                right: 20
              ),
              separatorBuilder: (context, index) => SizedBox(width: 25),
              itemBuilder: (context, index) {
                return Container(
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          // ---image container---
                        Container(
                          width: 350,
                          height: 135,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                          ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popularEvents[index].dateTime != null
                                    ? DateFormat('EEE, MMM d  ·  h:mm a').format(popularEvents[index].dateTime!)
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                popularEvents[index].name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                popularEvents[index].location,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] 
                    )
                    );
                  }
                ),
              ),
            )
          ],
    );
  }
}
