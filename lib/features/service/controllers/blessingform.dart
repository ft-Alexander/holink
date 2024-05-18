import 'package:flutter/material.dart';
import 'reviewInformation.dart'; // Import the ReviewInformation file

class BlessingForm extends StatefulWidget {
  const BlessingForm({super.key});

  @override
  _BlessingFormState createState() => _BlessingFormState();
}

class _BlessingFormState extends State<BlessingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  bool houseSelected = false;
  bool storeSelected = false;
  bool othersSelected = false;
  TextEditingController othersController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skkController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    othersController.dispose();
    nameController.dispose();
    skkController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    contactController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  bool _allFieldsFilled() {
    return nameController.text.isNotEmpty &&
        skkController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        (houseSelected || storeSelected || (othersSelected && othersController.text.isNotEmpty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'ADD INFORMATION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {}); // Rebuild form on field changes to update button state
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd1a65b), // Button background color
                      minimumSize: const Size.fromHeight(50), // Set height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'BLESSING',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please enter necessary information below.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Type:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: houseSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          houseSelected = value!;
                          storeSelected = false;
                          othersSelected = false;
                          othersController.clear();
                        });
                      },
                    ),
                    const Text('House'),
                    Checkbox(
                      value: storeSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          storeSelected = value!;
                          houseSelected = false;
                          othersSelected = false;
                          othersController.clear();
                        });
                      },
                    ),
                    const Text('Store'),
                    Checkbox(
                      value: othersSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          othersSelected = value!;
                          houseSelected = false;
                          storeSelected = false;
                        });
                      },
                    ),
                    const Text('Others(Please Specify):'),
                    if (othersSelected)
                      Expanded(
                        child: TextFormField(
                          controller: othersController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name (First Name, Middle Name, Surname)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: skkController,
                  decoration: const InputDecoration(
                    labelText: 'SKK NO:',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your SKK number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address:',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: landmarkController,
                  decoration: const InputDecoration(
                    labelText: 'Nearby Landmark:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number:',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Schedule Date (Refer to Calendar for Date Availability)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'MM/DD/YYYY',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: '00:00 AM/PM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _allFieldsFilled()
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewInformation(
                                    service: 'BLESSING',
                                    serviceType: 'SPECIAL (Private)',
                                    fullName: nameController.text,
                                    skkNumber: skkController.text,
                                    address: addressController.text,
                                    landmark: landmarkController.text,
                                    contactNumber: contactController.text,
                                    date: dateController.text,
                                    time: timeController.text,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allFieldsFilled() ? Colors.green : Colors.grey,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
