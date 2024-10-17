import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingView extends StatefulWidget {
  const TrackingView({super.key});

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {

   // list const locations
   List<Map<String,dynamic>> listLocations = [

      {
        "name": "North Aliciahaven178",
        "address": "978 East Street",
        "coordinates": {"latitude": 39.6938, "longitude": 167.238}
      },
      {
        "name": "Dooleyfield14",
        "address": "859 E 1st Street",
        "coordinates": {"latitude": 1.0878, "longitude": 62.4837}
      },
      {
        "name": "Fort Eliport25",
        "address": "941 Jodie Loop",
        "coordinates": {"latitude": -32.1522, "longitude": -25.9626}
      },
    {
      "name": "Missoula180",
      "address": "96554 Theresa Alley",
      "coordinates": {"latitude": -13.7733, "longitude": 1.7078}
    },
    {
      "name": "Framingham23",
      "address": "504 E High Street",
      "coordinates": {"latitude": 31.0169, "longitude": 80.4452}
    },
    {
      "name": "South Jaunitaland139",
      "address": "522 Rosalee Square",
      "coordinates": {"latitude": 25.4656, "longitude": 7.7473}
    }
  ];


   late GoogleMapController mapController;
   final Set<Marker> _markers = {};
   var  markers = [];

  var currentLoc ;
  var currentName ;

  @override
  void initState() {
    // TODO: implement initState

    for (var action in listLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$action["name'),
          position:  LatLng(action['coordinates']["latitude"], action['coordinates']["longitude"]),
          // infoWindow: InfoWindow(title: 'Marker ${i + 1}'),
        ),
      );
    }

    setState(() {
       currentLoc = LatLng(listLocations[0]['coordinates']["latitude"], listLocations[0]['coordinates']["longitude"]);

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
         //  container 1
         Expanded(
           flex: 3,
           child: Stack(
             children: [
               GoogleMap(

                 mapType: MapType.normal,
             onMapCreated: (controller) {
               mapController = controller;
             },

             initialCameraPosition: CameraPosition(
               target: currentLoc, // Center on first marker
               // zoom: 4.0,
             ),

             markers: _markers,
                 ),
               Positioned(
                 bottom: 30,
                   left: 15,
                   child: FloatingActionButton(

                       onPressed: () {
                         currentName =null;
                         mapController.animateCamera(
                           CameraUpdate.newCameraPosition(
                             CameraPosition(target: currentLoc,
                                 ), // Zoom and center on the tapped marker
                           ),
                         );
                       },
                       child: const Icon(Icons.restart_alt_outlined))),
               Visibility(
                 visible: currentName != null,
                 child: Positioned(
                     top: 50,
                     // left: 30,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: Container(
                             height: 50,
                             width: 360,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(10.0),
                               boxShadow: const [
                                 BoxShadow(
                                     color: Colors.black12,
                                     blurRadius: 8.0,
                                     spreadRadius: -4,
                                     offset: Offset(0, 8)),
                                 BoxShadow(
                                     color: Colors.black12,
                                     blurRadius: 24.0,
                                     spreadRadius: -4,
                                     offset: Offset(0, 20)),
                               ],
                             ),
                             child: Center(child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const Padding(
                                   padding: EdgeInsets.all(8.0),
                                   child: Icon((Icons.location_searching_rounded)),
                                 ),
                                 Text("${currentName ?? " "} - ${(currentLoc as LatLng).latitude}, ${(currentLoc as LatLng).latitude}"),
                               ],
                             ),),
                           ),
                         ),
                       ],
                     )),
               )

             ],
           ),

         ),
         // container 2
         Expanded(
           flex: 2,
             child: Container(
           decoration: BoxDecoration(
             border: Border.all(color: Colors.black38),
               color: Colors.grey[200],
                 ),
           child: Column(mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Padding(
                 padding: EdgeInsets.only(left: 16,top: 20,bottom: 15),
                 child: Text("Locations",style: TextStyle(fontSize: 17),),
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 5),
                   child: ListView.separated(shrinkWrap: true,
                     itemCount: listLocations.length,padding: EdgeInsets.zero,
                     itemBuilder: (BuildContext context, int index) {
                       return Container(
                         decoration: BoxDecoration(
                           color: const Color(0xFFFFFFFF),
                           borderRadius: BorderRadius.circular(16.0),
                           boxShadow: const [
                             BoxShadow(
                                 color: Colors.black12,
                                 blurRadius: 8.0,
                                 spreadRadius: -4,
                                 offset: Offset(0, 8)),
                             BoxShadow(
                                 color: Colors.black12,
                                 blurRadius: 24.0,
                                 spreadRadius: -4,
                                 offset: Offset(0, 20)),
                           ],
                         ),
                         child: ListTile(
                           onTap: (){

                             setState(() {
                               currentLoc = LatLng(listLocations[index]['coordinates']["latitude"], listLocations[index]['coordinates']["longitude"]);
                               currentName = listLocations[index]['name'];
                             });
                             mapController.animateCamera(
                               CameraUpdate.newCameraPosition(
                                 CameraPosition(target: LatLng(listLocations[index]['coordinates']["latitude"], listLocations[index]['coordinates']["longitude"]),
                                     zoom: 10.0), // Zoom and center on the tapped marker
                               ),
                             );
                           },
                           title: Text(listLocations[index]["name"]),
                           subtitle: Text("${listLocations[index]['address']}}"),
                           trailing: const Icon(Icons.location_searching_rounded,color:  Color(
                               0xFF940404),),
                         ),
                       );
                     }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                   ),
                 ),
               ),
             ],
           ),
         ))
        ],
      ),
    );
  }
}


// AIzaSyBA6BE3Vv5UAUAaPODuzOeavmcULP5gIx0