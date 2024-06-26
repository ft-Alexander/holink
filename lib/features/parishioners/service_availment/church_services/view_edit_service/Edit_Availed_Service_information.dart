import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holink/dbConnection/localhost.dart';
import 'package:http/http.dart' as http;

class EditAvailedServiceInformation extends StatefulWidget {
  final int serviceIndex;
  final Map<String, String> serviceDetails;

  const EditAvailedServiceInformation({
    super.key,
    required this.serviceIndex,
    required this.serviceDetails,
  });

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
  int special_event = 0;
  localhost localhostInstance = localhost();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _skkNumberController = TextEditingController();
    _addressController = TextEditingController();
    _landmarkController = TextEditingController();
    _contactNumberController = TextEditingController();
    _othersController = TextEditingController();
    populateServiceDetails();
  }

  void populateServiceDetails() {
    setState(() {
      _fullNameController.text = widget.serviceDetails["fullname"] ?? '';
      _skkNumberController.text = widget.serviceDetails["skk_number"] ?? '';
      _addressController.text = widget.serviceDetails["address"] ?? '';
      _landmarkController.text = widget.serviceDetails["landmark"] ?? '';
      _contactNumberController.text = widget.serviceDetails["contact_number"] ?? '';
      String selectedType = widget.serviceDetails["select_type"] ?? '';
      houseSelected = selectedType == 'House';
      storeSelected = selectedType == 'Store';
      othersSelected = selectedType.isNotEmpty && selectedType != 'House' && selectedType != 'Store';
      _othersController.text = othersSelected ? selectedType : '';
      id = int.parse(widget.serviceDetails["id"] ?? '0');
      special_event = int.parse(widget.serviceDetails["special_event"] ?? '0');
      isLoading = false;
      print('id: $id'); // Print id
      print('special_event: $special_event'); // Print special_event
      print('fullname: ${_fullNameController.text}');
      print('skk_number: ${_skkNumberController.text}');
      print('address: ${_addressController.text}');
      print('landmark: ${_landmarkController.text}');
      print('contact_number: ${_contactNumberController.text}');
      print('select_type: ${_othersController.text}');
    });
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

      final url = Uri.parse('http://${localhostInstance.ipServer}/dashboard/myfolder/service/updateServiceInformationBlessing.php');
      final body = {
        'special_event': special_event.toString(),
        'id': id.toString(),
        'fullname': _fullNameController.text,
        'skk_number': _skkNumberController.text,
        'address': _addressController.text,
        'landmark': _landmarkController.text,
        'contact_number': _contactNumberController.text,
        'select_type': selectedType,
      };

      print('Sending request to $url with body: $body'); // Print request details

      try {
        final response = await http.post(url, body: body);
        print('Response status: ${response.statusCode}'); // Print response status
        print('Response body: ${response.body}'); // Print response body

        final data = json.decode(response.body);
        if (data['success']) {
          Navigator.pop(context, 'updated');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service information updated successfully.')),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'EDIT INFORMATION',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 118, 164, 38),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2.0,
                color: Colors.green,
                width: double.infinity,
              ),
            ],
          ),
        ),
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
                          const Text('Others: '),
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
                          child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
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
