// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   String _location = 'Unknown';
//   Position? homeLocation;
//   Position? officeLocation;
//   Position? carLocation;
//   bool _isAtHome = false;
//   bool _isAtOffice = false;
//   bool _isInCar = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBackgroundLocationMonitoring();
//   }
//
//   void _startBackgroundLocationMonitoring() async {
//     // Check location permission
//     var status = await Permission.location.request();
//     if (!status.isGranted) {
//       // Handle if permission is not granted
//       return;
//     }
//
//     // Get the current locations
//     homeLocation = await _getLocation();
//     officeLocation = await _getLocation();
//     carLocation = await _getLocation();
//
//     // Continuously monitor the user's location
//     Geolocator.getPositionStream().listen((Position position) {
//       _checkLocation(position);
//     });
//   }
//
//   Future<Position?> _getLocation() async {
//     var permission = await Permission.location.request();
//     if (permission.isGranted) {
//       try {
//         return await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);
//       } catch (e) {
//         // Handle location retrieval errors
//         print(e.toString());
//         return null;
//       }
//     } else {
//       // Handle case where permission is not granted
//       return null;
//     }
//   }
//
//   void _checkLocation(Position position) {
//     double homeDistance = _calculateDistance(position, homeLocation);
//     double officeDistance = _calculateDistance(position, officeLocation);
//     double carDistance = _calculateDistance(position, carLocation);
//
//     setState(() {
//       _isAtHome = homeDistance <= 1;
//       _isAtOffice = officeDistance <= 1;
//       _isInCar = carDistance <= 1;
//
//       if (_isAtHome) {
//         _location = 'Home';
//       } else if (_isAtOffice) {
//         _location = 'Office';
//       } else if (_isInCar) {
//         _location = 'Car';
//       } else {
//         _location = 'Unknown';
//       }
//     });
//   }
//
//   double _calculateDistance(Position position, Position? location) {
//     if (location == null) {
//       return double.infinity;
//     }
//     return Geolocator.distanceBetween(
//       location.latitude,
//       location.longitude,
//       position.latitude,
//       position.longitude,
//     );
//   }
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   void _setHomeLocation() async {
//     var location = await _getLocation();
//     setState(() {
//       homeLocation = location;
//     });
//   }
//
//   void _setOfficeLocation() async {
//     var location = await _getLocation();
//     setState(() {
//       officeLocation = location;
//     });
//   }
//
//   void _setCarLocation() async {
//     var location = await _getLocation();
//     setState(() {
//       carLocation = location;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _setHomeLocation,
//               child: Text('Set Home Location'),
//             ),
//             ElevatedButton(
//               onPressed: _setOfficeLocation,
//               child: Text('Set Office Location'),
//             ),
//             ElevatedButton(
//               onPressed: _setCarLocation,
//               child: Text('Set Car Location'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Location: $_location',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             if (_isAtHome)
//               Text(
//                 'You are at home',
//                 style: TextStyle(fontSize: 16, color: Colors.green),
//               ),
//             if (_isAtOffice)
//               Text(
//                 'You are at office',
//                 style: TextStyle(fontSize: 16, color: Colors.blue),
//               ),
//             if (_isInCar)
//               Text(
//                 'You are in the car',
//                 style: TextStyle(fontSize: 16, color: Colors.orange),
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _location = 'Unknown';
  Position? homeLocation;
  Position? officeLocation;
  Position? carLocation;
  Position? _previousLocation;
  bool _isAtHome = false;
  bool _isAtOffice = false;
  bool _isInCar = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startBackgroundLocationMonitoring();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkMyLocation();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBackgroundLocationMonitoring() async {
    // Check location permission
    var status = await Permission.location.request();
    if (!status.isGranted) {
      // Handle if permission is not granted
      return;
    }

    // Get the current locations
    homeLocation = await _getLocation();
    officeLocation = await _getLocation();
    carLocation = await _getLocation();

    // Continuously monitor the user's location
    Geolocator.getPositionStream().listen((Position position) {
      _checkLocation(position);
    });
  }

  Future<Position?> _getLocation() async {
    var permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        // Handle location retrieval errors
        print(e.toString());
        return null;
      }
    } else {
      // Handle case where permission is not granted
      return null;
    }
  }

  void _checkLocation(Position position) {
    if (_previousLocation != null) {
      double distance = Geolocator.distanceBetween(
        _previousLocation!.latitude,
        _previousLocation!.longitude,
        position.latitude,
        position.longitude,
      );

      // If the distance is significant, consider it as movement
      if (distance > 1) {
        _showMovementMessage(_previousLocation!, position);
      }
    }

    double homeDistance = _calculateDistance(position, homeLocation);
    double officeDistance = _calculateDistance(position, officeLocation);
    double carDistance = _calculateDistance(position, carLocation);

    setState(() {
      _isAtHome = homeDistance <= 1;
      _isAtOffice = officeDistance <= 1;
      _isInCar = carDistance <= 1;

      if (_isAtHome) {
        _location = 'Home';
      } else if (_isAtOffice) {
        _location = 'Office';
      } else if (_isInCar) {
        _location = 'Car';
      } else {
        _location = 'Unknown';
      }

      _previousLocation = position;
    });
  }

  double _calculateDistance(Position position, Position? location) {
    if (location == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      position.latitude,
      position.longitude,
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _setHomeLocation() async {
    var location = await _getLocation();
    setState(() {
      homeLocation = location;
    });
  }

  void _setOfficeLocation() async {
    var location = await _getLocation();
    setState(() {
      officeLocation = location;
    });
  }

  void _setCarLocation() async {
    var location = await _getLocation();
    setState(() {
      carLocation = location;
    });
  }

  void _checkMyLocation() async {
    var currentLocation = await _getLocation();
    if (currentLocation != null) {
      _checkLocation(currentLocation);
      if (_isAtHome) {
        _showDefaultWindow('You are at Home');
      } else if (_isAtOffice) {
        _showDefaultWindow('You are at Office');
      } else if (_isInCar) {
        _showDefaultWindow('You are in the Car');
      }
    }
  }

  void _showDefaultWindow(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMovementMessage(Position from, Position to) {
    String fromLocation;
    String toLocation;

    if (_isAtHome) {
      fromLocation = 'Home';
    } else if (_isAtOffice) {
      fromLocation = 'Office';
    } else if (_isInCar) {
      fromLocation = 'Car';
    } else {
      fromLocation = 'Unknown';
    }

    double homeDistance = _calculateDistance(to, homeLocation);
    double officeDistance = _calculateDistance(to, officeLocation);
    double carDistance = _calculateDistance(to, carLocation);

    if (homeDistance <= 1) {
      toLocation = 'Home';
    } else if (officeDistance <= 1) {
      toLocation = 'Office';
    } else if (carDistance <= 1) {
      toLocation = 'Car';
    } else {
      toLocation = 'Unknown';
    }

    String message = 'Moved from $fromLocation to $toLocation';
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setHomeLocation,
              child: Text('Set Home Location'),
            ),
            ElevatedButton(
              onPressed: _setOfficeLocation,
              child: Text('Set Office Location'),
            ),
            ElevatedButton(
              onPressed: _setCarLocation,
              child: Text('Set Car Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkMyLocation,
              child: Text('Check My Location'),
            ),
            SizedBox(height: 20),
            Text(
              'Location: $_location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (_isAtHome)
              Text(
                'You are at home',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            if (_isAtOffice)
              Text(
                'You are at office',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            if (_isInCar)
              Text(
                'You are in the car',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
