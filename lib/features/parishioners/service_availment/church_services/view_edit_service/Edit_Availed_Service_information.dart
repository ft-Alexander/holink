import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:http/http.dart' as http;

class EditAvailedServiceInformation extends StatefulWidget {
  final int serviceIndex;

  const EditAvailedServiceInformation({super.key, required this.serviceIndex});

  @override
  _EditAvailedServiceInformationState createState() => _EditAvailedServiceInformationState();
}

class _EditAvailedServiceInformationState extends State<EditAvailedServiceInformation> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _skkNumberController;
  late TextEditingController _addressController;
  late TextEditingController _landmarkController;
  late TextEditingController _contactNumberController;
  late TextEditingController _othersController;
  bool houseSelected = false;
  bool storeSelected = false;
  bool othersSelected = false;
  bool isLoading = true;
  int id = 0;
  int s_id = 0;
  localhost localhostInstance = new localhost(); // Add this line

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _skkNumberController = TextEditingController();
    _addressController = TextEditingController();
    _landmarkController = TextEditingController();
    _contactNumberController = TextEditingController();
    _othersController = TextEditingController();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/getAllAvailedService.php'); // Use localhost instance
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          var service = data['services'][widget.serviceIndex];
          setState(() {
            _fullNameController.text = service["fullName"] ?? '';
            _skkNumberController.text = service["skk_number"] ?? '';
            _addressController.text = service["address"] ?? '';
            _landmarkController.text = service["landmark"] ?? '';
            _contactNumberController.text = service["contact_number"] ?? '';
            String selectedType = service["selected_type"] ?? '';
            houseSelected = selectedType == 'House';
            storeSelected = selectedType == 'Store';
            othersSelected = selectedType.isNotEmpty && selectedType != 'House' && selectedType != 'Store';
            _othersController.text = othersSelected ? selectedType : '';
            id = int.parse(service["id"]);
            s_id = int.parse(service["s_id"]);
            isLoading = false;
            print('id: $id'); // Print id
            print('s_id: $s_id'); // Print s_id
          });
        } else {
          showError('Failed to fetch service details: ${data['message']}');
        }
      } else {
        showError('Failed to fetch service details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching service details: $error'); // Print detailed error
      showError('An error occurred while fetching service details: $error');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submitEdit() async {
    if (_formKey.currentState!.validate()) {
      String selectedType = houseSelected
          ? 'House'
          : storeSelected
              ? 'Store'
              : othersSelected
                  ? _othersController.text
                  : '';

      final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/updateAvailedService.php'); // Use localhost instance
      final body = {
        's_id': s_id.toString(),
        'id': id.toString(),
        'serviceIndex': widget.serviceIndex.toString(),
        'fullName': _fullNameController.text,
        'skkNumber': _skkNumberController.text,
        'address': _addressController.text,
        'landmark': _landmarkController.text,
        'contactNumber': _contactNumberController.text,
        'selectedType': selectedType,
      };

      try {
        final response = await http.post(url, body: body);
        final data = json.decode(response.body);
        if (data['success']) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service information updated successfully. Selected Type: $selectedType')),
          );
        } else {
          showError('Failed to update service information: ${data['message']}');
        }
      } catch (error) {
        showError('An error occurred while updating service information: $error');
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _skkNumberController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _contactNumberController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: Colors.green,
          ),
        ),
        title: const Text(
          'Edit Service Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                _othersController.clear();
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
                                _othersController.clear();
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
                                controller: _othersController,
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
                        controller: _fullNameController,
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
                        controller: _skkNumberController,
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
                        controller: _addressController,
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
                        controller: _landmarkController,
                        decoration: const InputDecoration(
                          labelText: 'Nearby Landmark:',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactNumberController,
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: _submitEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Save', style: TextStyle(fontSize: 18)),
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
