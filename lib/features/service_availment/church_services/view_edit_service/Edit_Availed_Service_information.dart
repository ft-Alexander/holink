import 'package:flutter/material.dart';
import 'package:holink/features/service_availment/view/global_state.dart'; // Import the global state

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

  @override
  void initState() {
    super.initState();
    var service = globalState.availedServices[widget.serviceIndex];
    _fullNameController = TextEditingController(text: service["fullName"] ?? '');
    _skkNumberController = TextEditingController(text: service["skkNumber"] ?? '');
    _addressController = TextEditingController(text: service["address"] ?? '');
    _landmarkController = TextEditingController(text: service["landmark"] ?? '');
    _contactNumberController = TextEditingController(text: service["contactNumber"] ?? '');
    String selectedType = service["selectedType"] ?? '';
    houseSelected = selectedType == 'House';
    storeSelected = selectedType == 'Store';
    othersSelected = selectedType.isNotEmpty && selectedType != 'House' && selectedType != 'Store';
    _othersController = TextEditingController(text: othersSelected ? selectedType : '');
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

  void _submitEdit() {
    if (_formKey.currentState!.validate()) {
      String selectedType = houseSelected
          ? 'House'
          : storeSelected
              ? 'Store'
              : othersSelected
                  ? _othersController.text
                  : '';
      setState(() {
        globalState.availedServices[widget.serviceIndex] = {
          "title": globalState.availedServices[widget.serviceIndex]["title"] ?? '',
          "availedDate": globalState.availedServices[widget.serviceIndex]["availedDate"] ?? '',
          "scheduledDate": globalState.availedServices[widget.serviceIndex]["scheduledDate"] ?? '',
          "time": globalState.availedServices[widget.serviceIndex]["time"] ?? '',
          "fullName": _fullNameController.text,
          "skkNumber": _skkNumberController.text,
          "address": _addressController.text,
          "landmark": _landmarkController.text,
          "contactNumber": _contactNumberController.text,
          "selectedType": selectedType,
        };
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service information updated successfully. Selected Type: $selectedType')),
      );
    }
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
      body: Padding(
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