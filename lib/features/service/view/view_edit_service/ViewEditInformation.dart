import 'package:flutter/material.dart';
import 'pending.dart';
import 'approved.dart';

class ViewEditInformation extends StatefulWidget {
  const ViewEditInformation({super.key});

  @override
  _ViewEditInformationState createState() => _ViewEditInformationState();
}

class _ViewEditInformationState extends State<ViewEditInformation> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: const Color.fromARGB(255, 3, 3, 3),
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Pending(),
          Approved(),
        ],
      ),
    );
  }
}
