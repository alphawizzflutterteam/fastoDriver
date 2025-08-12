import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pristine_andaman_driver/Theme/style.dart';
import 'package:pristine_andaman_driver/utils/PushNotificationService.dart';
import 'package:pristine_andaman_driver/utils/Session.dart';
import 'package:pristine_andaman_driver/utils/common.dart';
import 'package:pristine_andaman_driver/utils/constant.dart';
import 'package:pristine_andaman_driver/utils/new_utils/ui.dart';

class StartGarageScreen extends StatefulWidget {
  String? bookingId;
  bool? garage;
  StartGarageScreen({required this.bookingId, required this.garage});

  @override
  State<StartGarageScreen> createState() => _StartGarageScreenState();
}

class _StartGarageScreenState extends State<StartGarageScreen> {
  final ImagePicker _picker = ImagePicker();

  File? driverImg;
  File? vehicleFront;
  File? vehicleBack;
  File? vehicleImg;
  File? startImg;
  List<String> imgType = [
    "Driver's Selfie",
    "Vehicle Front Pic",
    "Vehicle Back Pic",
    "Vehicle Pic"
  ];
  int currentImageIndex = 0;

  bool isNetwork = false;
  bool loading = false;

  updatebookingStatus(String bookingId, String driverStatus) async {
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "booking_id": bookingId,
          "driver_status": driverStatus.toString()
        };
        print("COMPLETE RIDE === $data");
        // return;
        Map response = await apiBaseHelper.postAPICall(
            Uri.parse(baseUrl1 + "payment/update_driver_booking_status"), data);
        print(response);
        print(response);
        // setState(() {
        //   acceptStatus = false;
        // });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          Navigator.pop(context, true);
          // showDialog(
          //     context: context,
          //     builder: (context) => CompleteRideDialog(widget.model));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MyRidesPage(selected: true)));
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  ///function to upload images
  Future<void> _updateDriver(File? Img, String imgType) async {
    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "https://bikebooking.alphawizzserver.com/api/payment/update_booking_status_images"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };
        request.headers.addAll(headers);
        request.fields.addAll({
          // "user_id": curUserId.toString(),
          'booking_id': widget.bookingId.toString(),
          'text': '',
          'type': imgType.toString(),
        });
        if (Img != null)
          request.files.add(
            http.MultipartFile(
              'image',
              Img!.readAsBytes().asStream(),
              Img!.lengthSync(),
              filename: path.basename(Img!.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        // if (vehicleFront != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle_front',
        //       vehicleFront!.readAsBytes().asStream(),
        //       vehicleFront!.lengthSync(),
        //       filename: path.basename(vehicleFront!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        // if (vehicleBack != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle_back',
        //       vehicleBack!.readAsBytes().asStream(),
        //       vehicleBack!.lengthSync(),
        //       filename: path.basename(vehicleBack!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        // if (vehicleImg != null)
        //   request.files.add(
        //     http.MultipartFile(
        //       'vehicle',
        //       vehicleImg!.readAsBytes().asStream(),
        //       vehicleImg!.lengthSync(),
        //       filename: path.basename(vehicleImg!.path),
        //       contentType: MediaType('image', 'jpeg'),
        //     ),
        //   );
        print("img request: " + request.toString());
        http.StreamedResponse res = await request.send();
        print("This is img response:" + res.toString());
        setState(() {
          loading = false;
        });
        print("${res.statusCode}");
        if (res.statusCode == 200) {
          final respStr = await res.stream.bytesToString();
          print("This is response:" + respStr.toString());
          Map data = jsonDecode(respStr.toString());

          if (data['status']) {
            //  Map info = data['data'];
            setSnackbar(data['message'].toString(), context);
            await App.init();
            // App.localStorage.clear();
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginPage()),
            //         (route) => false);
          } else {
            setSnackbar(data['message'].toString(), context);
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = true;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        loading = true;
      });
    }
  }

  // Tracks which image to pick next

  // Function to pick images one by one
  // Future getImage(ImageSource source, BuildContext context, int i) async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(
  //     source: source,
  //     // source: ImageSource.camera,
  //     imageQuality: 30,
  //   );
  //
  //   if (image != null) {
  //     setState(() {
  //       update = true;
  //       if (i == 1) {
  //         _image = File(image!.path);
  //       } else if (i == 2) {
  //         panImage = File(image!.path);
  //       } else if (i == 4) {
  //         vehicleImage = File(image!.path);
  //       } else if (i == 3) {
  //         adharImage = File(image!.path);
  //       } else if (i == 6) {
  //         insuranceImage = File(image!.path);
  //       } else if (i == 7) {
  //         bankImage = File(image!.path);
  //       } else {
  //         _finalImage = File(image!.path);
  //       }
  //     });
  //     // getCropImage(context, i, image.path);
  //   }
  // }
  Future<void> _pickImage(BuildContext context) async {
    if (currentImageIndex > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have picked all 4 images')),
      );
      updatebookingStatus(widget.bookingId.toString(), '1');
      // otpDialog();
      return;
    }
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );

    if (image != null) {
      setState(() {
        // Store the image in the appropriate variable
        switch (currentImageIndex) {
          case 0:
            driverImg = File(image.path);
            _updateDriver(driverImg, 'driver_selfie');
            break;
          case 1:
            vehicleFront = File(image.path);
            _updateDriver(vehicleFront, 'vehicle_front');
            break;
          case 2:
            vehicleBack = File(image.path);
            _updateDriver(vehicleBack, 'vehicle_back');
            break;
          case 3:
            vehicleImg = File(image.path);
            _updateDriver(vehicleImg, 'vehicle_image');
            break;
        }
        currentImageIndex++; // Move to the next image
      });
    }
  }

//   void requestPermission(BuildContext context) async {
//     if (await Permission.camera.isPermanentlyDenied ||
//         await Permission.storage.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//       openAppSettings();
//     } else {
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.camera,
//         Permission.storage,
//       ].request();
// // You can request multiple permissions at once.
//
//       if (statuses[Permission.camera] == PermissionStatus.granted &&
//           statuses[Permission.storage] == PermissionStatus.granted) {
//         getImage(ImageSource.camera, context);
//       } else {
//         if (await Permission.camera.isDenied ||
//             await Permission.storage.isDenied) {
//           // The user opted to never again see the permission request dialog for this
//           // app. The only way to change the permission's status now is to let the
//           // user manually enable it in the system settings.
//           openAppSettings();
//         } else {
//           setSnackbar("Oops you just denied the permission", context);
//         }
//       }
//     }
//   }
//   Future getImage(ImageSource source, BuildContext context) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//       source: source,
//       // source: ImageSource.camera,
//       imageQuality: 30,
//     );
//
//     if (image != null) {
//       setState(() {
//         // Store the image in the appropriate variable
//         if(currentImageIndex == 0){
//           driverImg = File(image.path);
//         } else if(currentImageIndex == 1){
//           vehicleFront = File(image.path);
//         } else if(currentImageIndex == 2){
//           vehicleBack = File(image.path);
//         } else if(currentImageIndex == 3){
//           vehicleImg = File(image.path);
//         }
//         currentImageIndex++; // Move to the next image
//       });
//     }
//   }

  void otpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Start Ride",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    startImg != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              startImg!,
                              fit: BoxFit.cover,
                              height: 150,
                              // width: double.infinity, // Ensure full width image display
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              final XFile? pickedFile = await _picker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  startImg = File(pickedFile.path);
                                });
                              }
                            },
                            child: Icon(Icons.camera_alt_outlined,
                                size: 40, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      "Enter OTP given by user",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "OTP here",
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      // controller: otpController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Theme.of(context)
                        //           .primaryColor),
                        //   child: Text("Back",
                        //     style: TextStyle(
                        //         color: Colors.black
                        //     ),),
                        //   onPressed: () async{
                        //     // setState((){
                        //     //   acceptStatus = false;
                        //     // });
                        //    Navigator.pop(context);
                        //   },
                        // ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff409144)),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Pick Images",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildImageTile(driverImg, "Driver's Selfie"),
                _buildImageTile(vehicleFront, "Vehicle Front"),
                _buildImageTile(vehicleBack, "Vehicle Back"),
                _buildImageTile(vehicleImg, "Vehicle Image"),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff409144),
                  // Button background color (theme)
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () {
                  _pickImage(context);
                  // requestPermission(context);
                },
                child: Text(
                  _getButtonText(), // Dynamically set button text
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white), // Button text style
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to set dynamic button text
  String _getButtonText() {
    if (currentImageIndex > 3) {
      return "Submit";
    }
    return "Capture ${imgType[currentImageIndex]}";
  }

  // Widget to display image or title if image is not yet picked
  Widget _buildImageTile(File? image, String imageTitle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align title to the start
        children: [
          Text(
            imageTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            child: image == null
                ? DottedBorder(
                    color: Colors.green,
                    // Dotted border color
                    strokeWidth: 2,
                    dashPattern: [8, 4],
                    // Dotted pattern
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: Container(
                      height: 200,
                      color: Colors.green.shade50,
                      alignment: Alignment.center,
                      child: Text(
                        imageTitle,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity, // Ensure full width image display
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/*
class _StartGarageScreenState extends State<StartGarageScreen> {
  final ImagePicker _picker = ImagePicker();

  File? image1;
  File? image2;
  File? image3;
  File? image4;
  File? extraImage; // Extra image picked in dialog
  int currentImageIndex = 1; // Tracks which image to pick next
  int? imageToReplace; // Track the index of image to replace

  // Function to pick images or replace an image
  Future<void> _pickImage({int? replaceIndex}) async {
    // If the user is replacing an image
    if (replaceIndex != null) {
      imageToReplace = replaceIndex;
    } else {
      if (currentImageIndex > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have picked all 4 images')),
        );
        // Open dialog after picking all 4 images
        _openExtraImageDialog();
        return;
      }
    }

    final PickedFile? image = await _picker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image != null) {
      setState(() {
        if (imageToReplace != null) {
          // If replacing an image
          _replaceImage(replaceIndex!, File(image.path));
          imageToReplace = null;
        } else {
          // Store the image in the appropriate variable
          switch (currentImageIndex) {
            case 1:
              image1 = File(image.path);
              break;
            case 2:
              image2 = File(image.path);
              break;
            case 3:
              image3 = File(image.path);
              break;
            case 4:
              image4 = File(image.path);
              break;
          }
          currentImageIndex++; // Move to the next image
        }
      });
    }
  }

  // Replace a specific image
  void _replaceImage(int index, File newImage) {
    switch (index) {
      case 1:
        image1 = newImage;
        break;
      case 2:
        image2 = newImage;
        break;
      case 3:
        image3 = newImage;
        break;
      case 4:
        image4 = newImage;
        break;
    }
  }

  // Function to open dialog and pick an additional image
  void _openExtraImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Pick an Additional Image'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  extraImage == null
                      ? Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      extraImage!,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final PickedFile? pickedFile = await _picker.getImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          extraImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Text('Pick Extra Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button background color (theme)
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick 4 Images"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildImageTile(image1, "Image 1", 1),
                _buildImageTile(image2, "Image 2", 2),
                _buildImageTile(image3, "Image 3", 3),
                _buildImageTile(image4, "Image 4", 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button background color (theme)
                  padding: EdgeInsets.symmetric(vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () => _pickImage(), // Picks the next image
                child: Text(
                  _getButtonText(), // Dynamically set button text
                  style: TextStyle(fontSize: 18, color: Colors.white), // Button text style
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to set dynamic button text
  String _getButtonText() {
    if (currentImageIndex > 4) {
      return "Pick Extra Image in Dialog";
    }
    return "Pick Image $currentImageIndex";
  }

  // Widget to display image or title if image is not yet picked
  Widget _buildImageTile(File? image, String imageTitle, int index) {
    return GestureDetector(
      onTap: () {
        if (image != null) {
          // If image is already picked, allow the user to replace it
          _pickImage(replaceIndex: index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
          children: [
            DottedBorder(
              color: Colors.green, // Dotted border color
              strokeWidth: 2,
              dashPattern: [8, 4], // Dotted pattern
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: image == null
                    ? Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: Text(
                    imageTitle,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity, // Ensure full width image display
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              imageTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Text color matching theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
