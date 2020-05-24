import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/localdb/database_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sabon/model/address.dart' as add;
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:toast/toast.dart';

class GoogleMapPickAddress extends StatefulWidget {
  static String id = 'GoogleMapPickAddress';

  @override
  _GoogleMapPickAddressState createState() => _GoogleMapPickAddressState();
}

class _GoogleMapPickAddressState extends State<GoogleMapPickAddress> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController mapController;
  double newLat = 40.380720, newLong = -102.164004;
  LatLng latLng = LatLng(40.380720, -102.164004);
  String addressType = '';

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() {
    _checkGps();

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position _position) {
      if (_position != null) {
        setState(() {
          latLng = LatLng(
            _position.latitude,
            _position.longitude,
          );
          print('latitude: ${latLng.latitude} Longitude: ${latLng.longitude}');

          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  latLng.latitude,
                  latLng.longitude,
                ),
                zoom: 12,
                bearing: 45.0,
                tilt: 45.0),
          ));
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get current location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
//                    final AndroidIntent intent = AndroidIntent(
//                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
//
//                    intent.launch();
//                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get current location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    if (!(await Geolocator().isLocationServiceEnabled())) {
                      AppSettings.openLocationSettings();
                    } else {
                      setState(() {
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  String address = 'Move the map to select address';

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width;
    double mapHeight = MediaQuery.of(context).size.height - 280;
    double iconSize = 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Choose Address'),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment(0.0, 0.0),
            children: <Widget>[
              Container(
                width: mapWidth,
                height: mapHeight,
                child: GoogleMap(
                  onCameraIdle: () async {
                    // From coordinates
                    final coordinates = new Coordinates(newLat, newLong);
                    var addresses = await Geocoder.local
                        .findAddressesFromCoordinates(coordinates);
                    var first = addresses.first;
                    print(
                        "ADDRESS:::: ${first.featureName} : ${first.addressLine}");
                    setState(() {
                      address = first.addressLine.toString();
                    });
                  },
                  onCameraMove: (cPosition) {
                    LatLng newLatLong = cPosition.target;
                    newLat = newLatLong.latitude;
                    newLong = newLatLong.longitude;
                  },
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: latLng,
                    zoom: 3.0,
                  ),
//            markers: Set<Marker>.of(markers.values),
                ),
              ),
              new Positioned(
                top: (mapHeight - iconSize) / 2,
                right: (mapWidth - iconSize) / 2,
                child: new Icon(Icons.person_pin_circle, size: iconSize),
              )
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      address,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _settingModalBottomSheet(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            color: kColorPrimary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Confirm location & Proceed',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          manualAddressBottomSheet(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            color: kColorPrimary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add Manually',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    List<String> addressTypes = ['Home', 'Work'];
    String selectedType = '';

    showModalBottomSheet(
        backgroundColor: kColorBottomSheetBG,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Select Address Type',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14.0),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 19.0,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      RadioButtonGroup(
                          orientation: GroupedButtonsOrientation.HORIZONTAL,
                          activeColor: Colors.deepPurpleAccent,
                          labelStyle: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w600),
                          labels: addressTypes,
                          onSelected: (String selected) {
                            selectedType = selected;
                          }),
                      SizedBox(),
                    ],
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () async {
                      if (selectedType != '') {
                        var addressM = add.Address();
                        addressM.name = selectedType;
                        addressM.address = address.toString();

                        await DBProvider.db.insertAddress(addressM);
                        Toast.show("Address added successfully", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);

                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      } else {
                        Toast.show("Please select address type", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      }
                    },
                    focusColor: kColorPrimary,
                    color: kColorPrimary,
                    splashColor: kColorPrimary,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void manualAddressBottomSheet(context) {
    List<String> addressTypes = ['Home', 'Work'];
    String selectedType = '';
//    address='';
    TextEditingController _controller = new TextEditingController(text: address);
    showModalBottomSheet(
        backgroundColor: kColorBottomSheetBG,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Enter Address and Type',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14.0),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 19.0,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      controller: _controller,
                      maxLines: 3,
                      onChanged: (val) {
                        address = val;
                      },
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      RadioButtonGroup(
                          orientation: GroupedButtonsOrientation.HORIZONTAL,
                          activeColor: Colors.deepPurpleAccent,
                          labelStyle: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w600),
                          labels: addressTypes,
                          onSelected: (String selected) {
                            selectedType = selected;
                          }),
                      SizedBox(),
                    ],
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () async {
                      if (address == '') {
                        Toast.show("Please enter address", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      } else if (selectedType == '') {
                        Toast.show("Please select address type", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      } else {
                        var addressM = add.Address();
                        addressM.name = selectedType;
                        addressM.address = address.toString();

                        await DBProvider.db.insertAddress(addressM);
                        Toast.show("Address added successfully", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);

                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      }
                    },
                    focusColor: kColorPrimary,
                    color: kColorPrimary,
                    splashColor: kColorPrimary,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
