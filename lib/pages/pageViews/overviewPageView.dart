import 'package:flutter/material.dart';
import '../../services/recordService.dart';
import '../../models/record.dart';

class OverviewPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOverview(),
    );
  }

  Widget _buildOverview() => FutureBuilder(
    future: RecordService.getRecordsByUserDocId('9t9D2s4i32rk0zsrWf4A'),
    builder: (BuildContext context,
        AsyncSnapshot<List<Record>> snapshot) {
      if(snapshot.hasData) {
        return ListView(
          children: snapshot.data.map((r) => Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 400,
                    child: Text(r.toJson()['emotions'].toString()),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                      RecordService.deleteRecordByDocId(r.docId),
                    child: Icon(Icons.delete_outline),
                  )
                ],
              ),
              Divider(),
            ],
          )).toList(),
        );
      } else if(snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}