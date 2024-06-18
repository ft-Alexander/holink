import 'package:flutter/material.dart';
import 'package:holink/features/parish/scheduling/model/priest.dart';
import 'package:holink/features/parish/scheduling/model/lector.dart';
import 'package:holink/features/parish/scheduling/model/sacristan.dart';

class AddPersonDialog extends StatelessWidget {
  final List<Priest> priests;
  final List<Priest> selectedPriests;
  final List<Lector> lectors;
  final List<Lector> selectedLectors;
  final List<Sacristan> sacristans;
  final List<Sacristan> selectedSacristans;
  final Future<void> Function() onSave;

  AddPersonDialog({
    required this.priests,
    required this.selectedPriests,
    required this.lectors,
    required this.selectedLectors,
    required this.sacristans,
    required this.selectedSacristans,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Text('Add Person'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildMultiSelectDropdown<Priest>(
                  label: 'Select Priests',
                  items: priests,
                  selectedItems: selectedPriests,
                  displayString: (priest) => priest.name,
                  onChanged: (Priest? value) {
                    setState(() {
                      if (selectedPriests.contains(value)) {
                        selectedPriests.remove(value);
                      } else {
                        selectedPriests.add(value!);
                      }
                    });
                  },
                ),
                SizedBox(height: 16.0),
                _buildMultiSelectDropdown<Lector>(
                  label: 'Select Lectors',
                  items: lectors,
                  selectedItems: selectedLectors,
                  displayString: (lector) => lector.name,
                  onChanged: (Lector? value) {
                    setState(() {
                      if (selectedLectors.contains(value)) {
                        selectedLectors.remove(value);
                      } else {
                        selectedLectors.add(value!);
                      }
                    });
                  },
                ),
                SizedBox(height: 16.0),
                _buildMultiSelectDropdown<Sacristan>(
                  label: 'Select Sacristans',
                  items: sacristans,
                  selectedItems: selectedSacristans,
                  displayString: (sacristan) => sacristan.name,
                  onChanged: (Sacristan? value) {
                    setState(() {
                      if (selectedSacristans.contains(value)) {
                        selectedSacristans.remove(value);
                      } else {
                        selectedSacristans.add(value!);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await onSave();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required String label,
    required List<T> items,
    required List<T> selectedItems,
    required String Function(T) displayString,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8.0),
        DropdownButtonFormField<T>(
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayString(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        Wrap(
          children: selectedItems.map((T item) {
            return Chip(
              label: Text(displayString(item)),
              onDeleted: () {
                onChanged(item);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
