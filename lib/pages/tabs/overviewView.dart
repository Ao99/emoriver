import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoriver/services/recordService.dart';
import 'package:emoriver/models/record.dart';

class OverviewView extends StatelessWidget {
  final IconData tabIcon = Icons.date_range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOverview(),
    );
  }

  Widget _buildOverview() => FutureBuilder(
    future: RecordService.getRecordsByUserDocId('9t9D2s4i32rk0zsrWf4A'),
    builder: (BuildContext context,
        AsyncSnapshot<QuerySnapshot<Record>> snapshot) {
      if(snapshot.hasData) {
        final records = snapshot.data.docs.map(
          (doc) => doc.data(),
        ).toList();
        return ListView(
          children: records.map((r) => Text(
            r.toJson().toString()
          )).toList(),
        );
      } else if(snapshot.hasError) {
        return SizedBox.shrink();
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}