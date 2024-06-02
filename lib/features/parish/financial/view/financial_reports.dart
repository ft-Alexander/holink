import 'package:flutter/material.dart';

import 'package:holink/features/parish/financial/view/financial_transactions.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<Map<String, String>> reports = [
    {"title": "Meeting Snacks", "date": "March 9, 2024"},
    {"title": "Electricity Bill", "date": "February 20, 2024"},
    {"title": "Mass Offerings", "date": "February 18, 2024"},
    {"title": "Donations from Boñaga Family", "date": "February 17, 2024"},
    {"title": "Donations from Anterola Family", "date": "February 17, 2024"},
    {"title": "Water Bill", "date": "February 17, 2024"},
    {"title": "Donations from Espinas Family", "date": "February 17, 2024"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTopNavBar(),
      ),
      body: Column(
        children: [
          _buildGenerateReportButton(),
          Expanded(child: _buildReportList()),
        ],
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransactionsPage()),
            );
          },
          child: const Text(
            'TRANSACTIONS',
            style: TextStyle(
              color: Color(0xff797979),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text(
                'REPORTS',
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 2.0,
              width: 200.0,
              color: const Color(0xffB37840),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              //GENERATE REPORT FUNCTION
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(6.0), // Adjust the radius here
              ),
            ),
            child: const Text(
              'Generate Report',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList() {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return ReportCard(
          title: reports[index]['title']!,
          date: reports[index]['date']!,
        );
      },
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String date;

  const ReportCard({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff904410)), // Green border
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Rounded corners to match container
        ),
        elevation: 0, // Remove the shadow
        child: ListTile(
          leading: const Icon(Icons.receipt_long, color: Color(0xffB37840)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(date),
          trailing: TextButton(
            onPressed: () {},
            child: const Text(
              'See Details',
              style: TextStyle(
                color: Color(0xff686868),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
