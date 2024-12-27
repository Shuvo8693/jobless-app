import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobless/helpers/route.dart';
import 'package:jobless/main.dart';
import 'package:jobless/service/google_api_service.dart';
import 'package:jobless/utils/app_colors.dart';
import 'package:jobless/views/base/custom_button.dart';

class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  _LocationSelectorScreenState createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(19.432608, -99.133209); // Default to Mexico City
  LatLng? _pickedLocation;
  late final TextEditingController _searchController = TextEditingController();
  List<String> onChangeTextFieldValue = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _goToSearchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        _moveCamera(LatLng(location.latitude, location.longitude));
      }
    } catch (e) {
      print('Error occurred while searching: $e');
    }
  }

  void _moveCamera(LatLng target) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ),
    );
    setState(() {
      _pickedLocation = target;
    });
    // Show the bottom sheet when the user taps on the map
  }

  void _confirmLocation(String selectedLocation) {
    if (_pickedLocation != null && selectedLocation.isNotEmpty == true) {
      // You can make an API call here to save the selected location or perform other actions
      final args = Get.arguments ?? {};
      final categoryList = (args['categoryList'] as List<String>?) ?? [];
      final jobExperience = (args['jobExperience'] as bool?) ?? false;

      print(selectedLocation);
      Get.toNamed(AppRoutes.signUpScreen, arguments: {
        'address': selectedLocation,
        'categoryList': categoryList,
        'jobExperience': jobExperience
      });
      print("Location confirmed: $_pickedLocation");
    } else {
      print("No location selected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map view
          Positioned.fill(
            child: SafeArea(
              child: GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                onTap: (position) {
                  _moveCamera(position);
                },
                myLocationEnabled: true,
              ),
            ),
          ),

          // Search bar at the top
          Positioned(
            top: 40.h,
            // Adjust this to position the search bar slightly below the status bar
            left: 15.w,
            right: 15.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (inputValue) async {
                        if (inputValue.isNotEmpty == true) {
                          var result = await GoogleApiService.fetchSuggestions(inputValue);
                          print(result.toString());
                          setState(() {
                            onChangeTextFieldValue = result;
                          });
                          print(onChangeTextFieldValue.toString());
                        }
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search location",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 24.sp,
                        ),
                      ),
                      onSubmitted: (value) {
                        // Handle search submission logic here
                        _goToSearchLocation(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      // Handle search button press logic
                      _goToSearchLocation(_searchController.text);
                      onChangeTextFieldValue.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 110.h,
            left: 15.w,
            right: 15.w,
            child: onChangeTextFieldValue.isNotEmpty == true
                ? Container(
                    height: 200.h,
                    width: 50.w,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: onChangeTextFieldValue.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              String selectedLocation = onChangeTextFieldValue[index].toString();
                              print(selectedLocation);
                              if (selectedLocation.isNotEmpty == true) {
                                _searchController.text = selectedLocation;
                                print(_searchController.text);
                              }
                            },
                            child: Text(onChangeTextFieldValue[index].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Confirm button at the bottom
          Positioned(
            bottom: 30.h,
            left: 15.w,
            right: 15.w,
            child: CustomButton(
              onTap: () {
                // Handle confirm location logic
                _confirmLocation(_searchController.text);
              },
              text: 'Confirm Location',
              height: 54.h,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
