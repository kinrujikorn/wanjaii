import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? city;
  String? state;
  String? country;
  LatLng? coordinates;

  @override
  void initState() {
    super.initState();
    _fetchLocationData();
  }

  Future<void> _fetchLocationData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc('SaLpkosF7vPZ90SWUQ8woH5P4Js1')
              .get();

      if (documentSnapshot.exists) {
        setState(() {
          city = documentSnapshot['city'];
          state = documentSnapshot['state'];
          country = documentSnapshot['country'];
        });
        await _getCoordinatesFromAddress('$city, $state, $country');
      } else {
        setState(() {
          city = 'N/A';
          state = 'N/A';
          country = 'N/A';
        });
        print('Document with ID your_document_id does not exist');
      }
    } catch (error) {
      print('Error fetching data from Firestore: $error');
    }
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    // Use Geocoding to get LatLng from address
    // You can use your preferred geocoding service or Google Maps Geocoding API
    // For simplicity, I'm not implementing geocoding here
    // Replace this with your actual geocoding implementation
    // For example:
    // final coordinates = await _geocodingService.getCoordinates(address);
    // setState(() {
    //   this.coordinates = coordinates;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: coordinates ?? LatLng(0, 0),
                zoom: 12,
              ),
              markers: {
                if (coordinates != null)
                  Marker(
                    markerId: MarkerId('marker_id'),
                    position: coordinates!,
                    infoWindow: InfoWindow(
                      title: 'Location',
                      snippet: '$city, $state, $country',
                    ),
                  ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'City: ${city ?? "Loading..."}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'State: ${state ?? "Loading..."}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Country: ${country ?? "Loading..."}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
