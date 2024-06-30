import 'package:flutter/material.dart';
import 'package:flutter_dating_app/screens/home/home_no_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FiltersScreen extends StatefulWidget {
  final Function(String, String, int, int) onApplyFilters;

  final String lastSelectedGender;
  final String? lastSelectedLocation;
  final int lastSelectedMinAge;
  final int lastSelectedMaxAge;

  const FiltersScreen({
    Key? key,
    required this.onApplyFilters,
    required this.lastSelectedGender,
    required this.lastSelectedLocation,
    required this.lastSelectedMinAge,
    required this.lastSelectedMaxAge,
  }) : super(key: key);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  int _selectedIndex = 0;
  int _minAge = 18;
  int _maxAge = 50;
  String? _selectedLocation;
  late String _selectedGender;

  String _mapGenderToFirestoreValue(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'woman';
      case 1:
        return 'man';
      case 2:
        return ''; // Return an empty string for 'Both'
      default:
        return ''; // Return an empty string if the index is invalid
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.lastSelectedGender;
    _selectedLocation = null;
    _minAge = widget.lastSelectedMinAge;
    _maxAge = widget.lastSelectedMaxAge;

    _selectedIndex = _mapGenderToToggleIndex(_selectedGender);
  }

  // Helper method to map gender to ToggleSwitch index
  int _mapGenderToToggleIndex(String gender) {
    switch (gender) {
      case 'man':
        return 1;
      case 'woman':
        return 0;
      default:
        return 2; // Both
    }
  }

  void _filter() {
    setState(() {
      _selectedIndex = 0;
      _minAge = 18;
      _maxAge = 50;
      _selectedLocation = null;
      _selectedGender = 'All';
    });

    Navigator.pop(context);
  }

  void _confirm() {
    String firestoreGenderValue = _mapGenderToFirestoreValue(_selectedIndex);
    widget.onApplyFilters(
        firestoreGenderValue, _selectedLocation ?? '', _minAge, _maxAge);
    Navigator.pop(context);
  }

  /* void _confirm() {
    widget.onApplyFilters(
        _selectedGender, _selectedLocation ?? '', _minAge, _maxAge);
    Navigator.pop(context);
  } */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Stack(children: [
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Filters',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sk-Modernist',
                    fontSize: 28),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  "Interested In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        ToggleSwitch(
                          fontSize: 16,
                          minHeight: 65.0,
                          minWidth: 115.0,
                          initialLabelIndex: _selectedIndex,
                          activeBgColor: [Color(0xFFBB254A)],
                          inactiveBgColor: Color(0xFFE8E6EA),
                          labels: ['Girls', 'Boys', 'Both'],
                          onToggle: (index) {
                            setState(() {
                              _selectedIndex = index!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(35.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     child: DropdownButtonFormField<String>(
              //       value: _selectedLocation,
              //       decoration: InputDecoration(
              //         labelText: 'Location',
              //         labelStyle: TextStyle(color: Colors.grey),
              //         hintText: 'Select a location',
              //         border: InputBorder.none,
              //         contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              //       ),
              //       items: [
              //         'select a location',
              //         'Bangkok',
              //         'Pattaya',
              //         'Ayutthaya'
              //       ].map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           _selectedLocation = newValue;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Age",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: Text(
                        "${_minAge}-${_maxAge}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red,
                    inactiveTrackColor: Color(0xFFE8E6EA),
                    thumbColor: Color(0xFFBB254A),
                    valueIndicatorColor: Color(0xFFBB254A),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                    trackHeight: 8.0,
                  ),
                  child: RangeSlider(
                    values: RangeValues(_minAge.toDouble(), _maxAge.toDouble()),
                    min: 18,
                    max: 50,
                    divisions: 32,
                    labels: RangeLabels(
                      '${_minAge.toString()} yrs',
                      '${_maxAge.toString()} yrs',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minAge = values.start.toInt();
                        _maxAge = values.end.toInt();
                      });
                    },
                    activeColor: Color(0xFFBB254A),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: _confirm,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFBB254A)), // Change button color
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(295, 56)), // Set button width and height
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Set border radius here
                        ),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sk-Modernist',
                        color: Color(0xFFFFFFFF),
                      ),
                    )),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
