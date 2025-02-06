import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja_shoie_app/constant/utils/lottieLoadingAnimation.dart';
import 'package:suja_shoie_app/constant/utils/theme_styles.dart';
import 'package:suja_shoie_app/feature/presentation/api_services/datapoint_service.dart';
import 'package:suja_shoie_app/feature/presentation/api_services/get_checklist_details_service.dart';
import 'package:suja_shoie_app/feature/presentation/providers/additional_datapoint_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/checklist_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/datapoint_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/get_checklist_details_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/qrscanner_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/theme_providers.dart';
import 'package:suja_shoie_app/feature/presentation/widget/checklist_details/additional_datapoint.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constant/utils/image_base64.dart';
import '../../../constant/utils/show_snakbar.dart';
import '../../../models/chepoint_request.model.dart';
import '../../data/core/api_constant.dart';
import '../api_services/initate_pause_service.dart';
import '../api_services/operator_service.dart';
import '../api_services/sm_datapoint_service.dart';
import '../providers/loginprovider.dart';
import '../providers/operator_provider.dart';
import '../providers/orgid_provider.dart';
import '../providers/sm_datapoint_provider.dart';
import '../widget/checklist_details/take_photo.dart';
import '../widget/home_page_widget/work_schedule/assetlist_workschedule/asset_list_workschedule.dart';
import '../widget/home_page_widget/work_schedule/qr_workorder_data/qr_checlist_card.dart';

class CheckPointDetails extends StatefulWidget {
  final int planId;
  final List<File?>? capturedImages;
  final int? pageId;
  final int? acrpinspectionstatus;
  final int? assetId;
  final String assetname;

  const CheckPointDetails(
      {super.key,
      required this.planId,
      this.assetId,
      this.capturedImages,
      this.pageId,
      this.acrpinspectionstatus,
      required this.assetname});

  @override
  _CheckPointDetailsState createState() => _CheckPointDetailsState();
}

class _CheckPointDetailsState extends State<CheckPointDetails> {
  final GetChecklistService _checkListService = GetChecklistService();
  final TextEditingController numberController = TextEditingController();
  final InitiatePauseService initiatePauseService = InitiatePauseService();
  final ImageBase64 imageBase64 = ImageBase64();
  bool isOkayButtonVisible = true;
  bool isConfirmButtonVisible = true;
  String personName = ''; // State variable to store the personName
  bool isCheckboxChecked = false;
  bool isLoading = true;
  bool isTextFieldVisible = true;
  bool isOperatorIdEntered = false;
  bool showDataPointsButton = false;
  // Store the entered data for each popup
  Map<int, Map<String, dynamic>> popupData = {};
  List<List<String>> selectedDropdownValues = [];

  // Step 2: Create a map to store the fetched "Data Points" data
  Map<int, List<String>> dataPointValuesMap = {};
  Map<int, List<String>> userEnteredDataPoints = {};
  Map<int, List<DataEntry>> myStatefulWidgetDataMap = {};
  final GlobalKey<FormState> operatorFormKey = GlobalKey<FormState>();
  Map<int, List<Map<String, String>>> EnteredDataPoints = {};
  bool singleTap = false;
  // void pauseStatus() {
  //   initiatePauseService.initiatePause(context: context, id: widget.planId);
  // }
  List<String> acrdpValues = [];

  // getStatusIcon(int method) {
  //   if (method == 1) {
  //     return Image.asset(
  //       "assets/images/Eye.png",
  //       fit: BoxFit.cover,

  //       width: 40, // You can set your desired width and height here
  //       height: 40,
  //     );
  //   }  else if (method == 2) {
  //     return Image.asset(
  //       "assets/images/Ear.png",
  //       fit: BoxFit.cover,

  //       width: 40, // You can set your desired width and height here
  //       height: 40,
  //     );
  //   }
  //   else if (method == 3) {
  //     return Image.asset(
  //       "assets/images/Hand.png",
  //       fit: BoxFit.cover,

  //       width: 40, // You can set your desired width and height here
  //       height: 40,
  //     );
  //   }
  //   else if (method == 4) {
  //     return Image.asset(
  //       "assets/images/Nose.png",
  //       fit: BoxFit.cover,

  //       width: 40, // You can set your desired width and height here
  //       height: 40,
  //     );
  //   }

  //    else if (method == 5) {
  //     return Text(
  //       "Instrument",
  //       style: TextStyle(fontSize: 14, color: Colors.black),
  //     );
  //   } else if (method == 6) {
  //     return Text(
  //       "Operation",
  //       style: TextStyle(fontSize: 14, color: Colors.black),
  //     );
  //   } else if (method == 7) {
  //     return Text(
  //       "Spill Kit",
  //       style: TextStyle(fontSize: 14, color: Colors.black),
  //     );
  //   } else if (method == 8) {
  //     return Text(
  //       "Waste Cloth",
  //       style: TextStyle(fontSize: 14, color: Colors.black),
  //     );
  //   } else if (method == 9) {
  //     return Column(
  //       children: [
  //         Image.asset(
  //           "assets/images/Hand.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //         Image.asset(
  //           "assets/images/Ear.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //       ],
  //     );
  //   }
  //    else if (method == 10) {
  //     return Column(
  //       children: [
  //         Image.asset(
  //           "assets/images/Eye.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //         Image.asset(
  //           "assets/images/Hand.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //       ],
  //     );
  //   }

  //    else if (method == 11) {
  //     return Column(
  //       children: [
  //         Image.asset(
  //           "assets/images/Eye.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //         Image.asset(
  //           "assets/images/Ear.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //       ],
  //     );
  //   } else if (method == 12) {
  //     return Image.asset(
  //       "assets/images/Hand.png",
  //       fit: BoxFit.cover,
  //       width: 40, // You can set your desired width and height here
  //       height: 40,
  //     );
  //   } else if (method == 13) {
  //     return Column(
  //       children: [
  //         Text(
  //           "Operation",
  //           style: TextStyle(fontSize: 14, color: Colors.black),
  //         ),
  //         Image.asset(
  //           "assets/images/Ear.png",
  //           fit: BoxFit.cover,

  //           width: 40, // You can set your desired width and height here
  //           height: 40,
  //         ),
  //       ],
  //     );
  //   }
  // }

  getStatusIcon(int method) {
    if (method == 1) {
      return Image.asset(
        "assets/images/Eye.png",
        fit: BoxFit.cover,

        width: 40, // You can set your desired width and height here
        height: 40,
      );
    } else if (method == 2) {
      return Image.asset(
        "assets/images/Hand.png",
        fit: BoxFit.cover,
        width: 40, // You can set your desired width and height here
        height: 40,
      );
    } else if (method == 3) {
      return Image.asset(
        "assets/images/Ear.png",
        fit: BoxFit.cover,

        width: 40, // You can set your desired width and height here
        height: 40,
      );
    } else if (method == 4) {
      return Column(
        children: [
          Image.asset(
            "assets/images/Eye.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
          Image.asset(
            "assets/images/Hand.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
        ],
      );
    } else if (method == 5) {
      return Text(
        "Instrument",
        style: TextStyle(fontSize: 14, color: Colors.black),
      );
    } else if (method == 6) {
      return Text(
        "Operation",
        style: TextStyle(fontSize: 14, color: Colors.black),
      );
    } else if (method == 7) {
      return Text(
        "Spill Kit",
        style: TextStyle(fontSize: 14, color: Colors.black),
      );
    } else if (method == 8) {
      return Text(
        "Waste Cloth",
        style: TextStyle(fontSize: 14, color: Colors.black),
      );
    } else if (method == 9) {
      return Column(
        children: [
          Image.asset(
            "assets/images/Hand.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
          Image.asset(
            "assets/images/Ear.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
        ],
      );
    } else if (method == 10) {
      return Image.asset(
        "assets/images/Nose.png",
        fit: BoxFit.cover,
        width: 40, // You can set your desired width and height here
        height: 40,
      );
    } else if (method == 11) {
      return Column(
        children: [
          Image.asset(
            "assets/images/Eye.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
          Image.asset(
            "assets/images/Ear.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
        ],
      );
    } else if (method == 12) {
      return Image.asset(
        "assets/images/Hand.png",
        fit: BoxFit.cover,
        width: 40, // You can set your desired width and height here
        height: 40,
      );
    } else if (method == 13) {
      return Column(
        children: [
          Text(
            "Operation",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          Image.asset(
            "assets/images/Ear.png",
            fit: BoxFit.cover,

            width: 40, // You can set your desired width and height here
            height: 40,
          ),
        ],
      );
    }
  }

  String responsibilityRole(int method) {
    if (method == 1) {
      return 'Operator';
    } else {
      return 'Maintenance Engineer';
    }
  }

  int setStatusValue(String status) {
    switch (status) {
      case "Passed":
        return 1;
      case "Failed":
        return 2;
      case "Conditionally Passed":
        return 3;
      case "Not Applicable":
        return 4;
      default:
        return 0; // Handle unknown status here
    }
  }

  String getStatusValue(int status) {
    switch (status) {
      case 1:
        return "Passed";
      case 2:
        return "Failed";
      case 3:
        return "Conditionally Passed";
      case 4:
        return "Not Applicable";
      default:
        return "Select Answer"; // Handle unknown status here
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCheckList();
  }

  Future<void> _fetchCheckList() async {
    try {
      final orgId = Provider.of<OrgIdProvider>(context, listen: false).orgid;
      final responseData = await _checkListService.getCheckListDetails(
          context: context,
          planId: widget.planId ?? 0,
          acrpinspectionstatus: widget.acrpinspectionstatus ?? 0,
          orgid: orgId ?? 0);
      setState(() {
        isLoading = false;
      });
      final response =
          Provider.of<GetCheckListDetailsProvider>(context, listen: false)
              .user
              ?.responseData;

      if (response != null) {
        final checklist = response.getChecklistDetails ?? [];

        selectedDropdownValues = List.generate(
          checklist.length,
          (index) =>
              [getStatusValue(checklist[index].acrdcheckpointinspectionresult)],
        );

        // Set the initial dropdown values based on checklist data here
        for (int index = 0; index < checklist.length; index++) {
          var newValue =
              getStatusValue(checklist[index].acrdcheckpointinspectionresult);
          selectedDropdownValues[index] = [newValue];

          if (newValue == "Failed" || newValue == "Conditionally Passed") {
            showDataPointsButton = true;
          } else if (newValue == "Passed") {
            showDataPointsButton = true;
          } else if (newValue == "Select Answer" ||
              newValue == "Not Applicable") {
            showDataPointsButton = true;
          } else {
            showDataPointsButton = false;
          }
        }
      }
    } catch (e) {
      print('Error fetching checklist: $e');
      isLoading = false;
    }
  }

  void _handleDropdownChange(int index, String newValue) async {
    await _fetchDataPoints(index);
    var fetchdata = Provider.of<DataPointProvider>(context, listen: false)
        .user
        ?.checklistDatapointsList;

    setState(() {
      final String previousValue = selectedDropdownValues[index].first;

      if (previousValue != newValue) {
        // Clear all fields when the previous value is different from the new value
        userEnteredDataPoints[index] = List<String>.filled(
          selectedDropdownValues.length,
          "", // Clear the text field value
          growable: true,
        );
      }

      while (selectedDropdownValues.length <= index) {
        selectedDropdownValues.add(["Select Answer"]);
      }
      selectedDropdownValues[index] = [newValue]; // Update the selected value

      if (newValue == "Passed") {
        if (fetchdata?.length != 0) {
          _showPopup(context, index);
          showDataPointsButton = true;
        } else {
          showDataPointsButton = true;
        }
      } else if (newValue == "Failed" || newValue == "Conditionally Passed") {
        _showPopup(context, index);
        showDataPointsButton = true;
      } else if (newValue == "Select Answer" || newValue == "Not Applicable") {
        showDataPointsButton = true;
      } else {
        showDataPointsButton = false;
      }
    });
  }

  bool isSnackbarShown = false;
  bool isHandlingSubmit = false; // Add this flag

  void handleSubmit() {
    if (isHandlingSubmit) {
      return; // Return early if already handling a submission
    }

    isHandlingSubmit = true;

    String personId = numberController.text;

    if (personId.isEmpty) {
      setState(() {
        personName = 'Person ID is required';
        isTextFieldVisible = true;
      });

      isHandlingSubmit = false; // Reset the flag
    } else {
      OperatorService operatorService = OperatorService();
      final orgId = Provider.of<OrgIdProvider>(context, listen: false).orgid;
      operatorService
          .getOperatorName(
              personId: personId, context: context, orgid: orgId ?? 0)
          .then((result) {
        var operator =
            Provider.of<OperatorProvider>(context, listen: false).user;

        if (operator != null && operator.employeeNumber == personId) {
          setState(() {
            personName = operator.personfname ?? 'Operator name not found';
            isTextFieldVisible = false;
          });
        } else {
          setState(() {
            isTextFieldVisible = true;
            personName = '';
          });

          // Show the Snackbar only if it hasn't been shown yet
          if (!isSnackbarShown) {
            isSnackbarShown =
                true; // Set the flag to true after showing the Snackbar
          }
        }

        isHandlingSubmit = false; // Reset the flag
      }).catchError((error) {
        setState(() {
          personName = 'Error: $error';
          isTextFieldVisible = false;
        });

        isHandlingSubmit = false; // Reset the flag
      });
    }
  }

  // Future<void> _SmfetchDataPoints(int index) async {
  //   SmDataPointService dataPointService = SmDataPointService();

  //   final responseData =
  //       Provider.of<GetCheckListDetailsProvider>(context, listen: false)
  //           .user
  //           ?.responseData;
  //   final checklist = responseData?.getChecklistDetails ?? [];

  //   if (checklist.isNotEmpty && index < checklist.length) {
  //     final acrdId = checklist[index].acrdid;

  //     // Fetch "Data Points" data using dataPointService.getDatapoints
  //     final dataPoints = await dataPointService.getDatapoints(
  //       context: context,
  //       acrdId: acrdId,
  //     );

  //     dataPointValuesMap[index] = dataPoints ?? [];

  //     // Initialize user-entered data points if not already done
  //     if (!userEnteredDataPoints.containsKey(index)) {
  //       userEnteredDataPoints[index] = List<String>.filled(
  //         dataPointValuesMap[index]!.length,
  //         "", // Initialize with empty strings
  //         growable: true,
  //       );
  //     }
  //   }
  // }

  Future<void> _fetchDataPoints(int index) async {
    DataPointService dataPointService = DataPointService();

    final responseData =
        Provider.of<GetCheckListDetailsProvider>(context, listen: false)
            .user
            ?.responseData;
    final checklist = responseData?.getChecklistDetails ?? [];

    if (checklist.isNotEmpty && index < checklist.length) {
      final acrdId = checklist[index].acrdid;
      final orgId = Provider.of<OrgIdProvider>(context, listen: false).orgid;

      // Fetch "Data Points" data using dataPointService.getDatapoints
      final dataPoints = await dataPointService.getDatapoints(
          context: context,
          acrdId: acrdId,
          planId: widget.planId,
          orgid: orgId ?? 0);

      dataPointValuesMap[index] = dataPoints ?? [];

      // Initialize user-entered data points if not already done
      if (!userEnteredDataPoints.containsKey(index)) {
        userEnteredDataPoints[index] = List<String>.filled(
          dataPointValuesMap[index]!.length,
          "", // Initialize with empty strings
          growable: true,
        );
      }
    }
  }

  // Future<List<String>> convertFilePathsToBase64(List<String> filePaths) async {
  //   List<String> base64Images = [];

  //   for (var filePath in filePaths) {
  //     if (filePath.isNotEmpty) {
  //       final file = File(filePath);
  //       if (await file.exists()) {
  //         final image = img.decodeImage(await file.readAsBytes());

  //         if (image != null) {
  //           // Resize the image to a smaller dimension
  //           final resizedImage = img.copyResize(image, width: 600, height: 400);
  //           final resizedImageBytes = img.encodeJpg(resizedImage, quality: 20);

  //           String base64String = base64Encode(resizedImageBytes);

  //           base64Images.add(base64String);
  //         } else {
  //           // Handle the case where image decoding fails
  //           base64Images.add(''); // Add an empty string or another placeholder
  //         }
  //       } else {
  //         // Handle the case where the file doesn't exist (if needed)
  //         base64Images.add(''); // Add an empty string or another placeholder
  //       }
  //     } else {
  //       // Handle the case where the file path is empty (if needed)
  //       base64Images.add(''); // Add an empty string or another placeholder
  //     }
  //   }

  //   return base64Images;
  // }

  Future submitChecklist(BuildContext context, apifor, statusName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    var operator =
        Provider.of<OperatorProvider>(context, listen: false).user?.personid;

    final responseData =
        Provider.of<GetCheckListDetailsProvider>(context, listen: false)
            .user
            ?.responseData;
    final checklist = responseData?.getChecklistDetails ?? [];

    List<String>? headerImagesPaths = widget.capturedImages
        ?.map((file) => file != null ? file.path : '')
        .toList();

    List<String> base64HeaderImages =
        await imageBase64.convertFilePathsToBase64(headerImagesPaths!);
    final orgid =
        Provider.of<LoginProvider>(context, listen: false).user?.orgId ?? 0;
    final checklistRequest = ChecklistRequest(
        clientAuthToken: token,
        apiFor: apifor,
        fromDateTime: ApiConstant.fromDate,
        toDateTime: toDate,
        clientId: "vijay",
        acrhAcmphId: checklist.first.acrhacmphid,
        acrhid: checklist.first.acrhid,
        planid: checklist.first.planid,
        operatorId: operator ?? 0,
        headerimage: base64HeaderImages,
        checkPoints: [],
        statusId: statusName,
        orgid: orgid);

    // Populate checkPoints list with your checkpoint data
    for (int index = 0; index < checklist.length; index++) {
      final asset = checklist[index];

      final responseData =
          Provider.of<DataPointProvider>(context, listen: false)
              .user
              ?.checklistDatapointsList;

      final datapointDescriptions =
          responseData?.map((e) => e.amdpDatapointDescription).toList() ?? [];

      final dataAcrdp = responseData?.map((e) => e.acrdpId).toList() ?? [];

      final combinedDatapoint = EnteredDataPoints[index] ?? [];

      // Filter out empty datapoints
      // final filteredDataPoints = dataPoints
      //     .asMap()
      //     .entries
      //     .where((entry) =>
      //         entry.value.isNotEmpty &&
      //         entry.key < datapointDescriptions.length &&
      //         datapointDescriptions[entry.key].isNotEmpty == true)
      //     .toList();

      // List<String> assetImages = await convertFilePathsToBase64(imagesList);
      final responseAddData =
          Provider.of<AdditionalDataPointProvider>(context, listen: false)
              .user
              ?.responseData;

      final addDatapointDescription = responseAddData?.additionaldatapointslist
              .map((e) => e.amdpDatapointDescription)
              .toList() ??
          [];

      final adddata = myStatefulWidgetDataMap[index] ?? [];

// Filter out empty datapoints
      final filteredAdditionalData = adddata
          .asMap()
          .entries
          .where((entry) =>
              entry.key < addDatapointDescription.length &&
              addDatapointDescription[entry.key].isNotEmpty == true)
          .toList();

      final checkpoint = ChecklistCheckpoint(
        acrdId: asset.acrdid,
        acrdCheckpointStatus:
            setStatusValue(selectedDropdownValues[index].first),
        acrdCheckpointNotes: popupData[index]?['note'] ?? "",

        datapoints: [],
        images: [], // Initialize the datapoints list for this checkpoint
      );

      final imagesList = (popupData[index]?['images'] as List<File?>?)
          ?.where((image) {
            if (image != null) {
              final imagePath = image.path.toLowerCase();

              // Check if it's a local file path (not starting with "http://" or "https://")
              // and matches the allowed format
              if (!Uri.parse(imagePath).isAbsolute &&
                  imagePath.startsWith(
                      "/data/user/0/com.example.suja_shoie_app/cache/")) {
                return true; // Include the local file path
              }
            }
            return false;
          })
          .map((image) => image?.path ?? "")
          .toList();

      List<String> listOfImage =
          await imageBase64.convertFilePathsToBase64(imagesList ?? []);
      checkpoint.images?.addAll(listOfImage ?? []);

      for (final entry in filteredAdditionalData) {
        final i = entry.key;
        final dataEntry =
            entry.value; // Assuming entry.value is a DataEntry object
        final addDatapoint = ChecklistDataPoint(
          amdpDatapointId: dataEntry.amdpId,
          acrdpId: 0,
          amdpDatapointDescription: dataEntry.option, // Use entry.option here
          acrdpDatapointValue:
              dataEntry.dataPoints, // Access the value property
        );

        checkpoint.datapoints
            ?.add(addDatapoint); // Add this datapoint to the current checkpoint
      }

      for (int i = 0; i < combinedDatapoint.length; i++) {
        final description = combinedDatapoint[i]['acrpDescription'];
        final acrdpId = combinedDatapoint[i]['acrdpId'];
        final editedValue = combinedDatapoint[i]['editedValue'];

        // Check if acrdpId and editedValue are not empty and the index is within bounds
        if (acrdpId != null && editedValue != null) {
          final datapoint = ChecklistDataPoint(
            amdpDatapointId: i + 1,
            acrdpId: int.parse(acrdpId), // Convert acrdpId to integer
            amdpDatapointDescription: description ??
                "", // Use amdpDatapointDescription from datapointDescriptions list
            acrdpDatapointValue: editedValue.isEmpty
                ? "0"
                : editedValue, // Use editedValue as acrdpDatapointValue
          );

          checkpoint.datapoints
              ?.add(datapoint); // Add this datapoint to the current checkpoint
        }
      }
      checklistRequest.checkPoints
          ?.add(checkpoint); // Add the checkpoint to the checklist
    }

    final requestBody = jsonEncode(checklistRequest.toJson());

    print(requestBody);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          print(responseJson);
          return responseJson;
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
          throw ("Invalid JSON response from the server");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }

  void _navigateBack() {
    final response = Provider.of<CheckListProvider>(context, listen: false)
        .user
        ?.responseData;
    final asset = response?.checklist ?? [];

    final qrresponse = Provider.of<QrScannerProvider>(context, listen: false)
        .user
        ?.responseData;
    final qrasset = qrresponse?.checklist ?? [];
    if (widget.pageId == 1) {
      // Access the flag from the widget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QrCheklistCard(qrasset.first.assetbarcode),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckListCardView(
              //  widget.assetId,
              asset.first.acrpassetId),
        ),
      );
    }
  }

  void _submitPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                color: Colors.white,
                child: Column(children: [
                  const Text("Confirm you submission"),
                  const SizedBox(
                    height: defaultPadding * 3,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (personName.isNotEmpty && !isTextFieldVisible) {
                              try {
                                final response = await submitChecklist(
                                    context, "submit_checklist", 3);
                                if (response['response_code'] == 4 ||
                                    response['response_code'] == 5 ||
                                    response['response_code'] == 6) {
                                  ShowError.showAlert(
                                      context, response['response_msg']);
                                } else {
                                  // If response_code is not 4, 5, or 6, proceed to _navigateBack()
                                  _navigateBack();
                                  popupData.clear();
                                  userEnteredDataPoints.clear();
                                  myStatefulWidgetDataMap.clear();
                                  numberController.clear();
                                }
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text("Submit"),
                        ),

                        // ElevatedButton(
                        //     onPressed: () {
                        //       submitChecklist(context, "submit_checklist", 3);
                        //       _navigateBack();

                        //       popupData.clear();
                        //       userEnteredDataPoints.clear();
                        //       myStatefulWidgetDataMap.clear();
                        //       numberController.clear();
                        //     },
                        //     child: const Text("Submit")),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Go back")),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }

  Future<void> _showPopup(BuildContext context, int index) async {
    await _fetchDataPoints(index);
    // await _SmfetchDataPoints(index);
    final responseData =
        Provider.of<GetCheckListDetailsProvider>(context, listen: false)
            .user
            ?.responseData;
    final checklist = responseData?.getChecklistDetails ?? [];

    List<TextEditingController> datapointControllers = [];

    // List imageFiles = [];

    final serverImage = Provider.of<DataPointProvider>(context, listen: false)
        .user
        ?.detailImageUrl;

    final imageUrls = serverImage ?? [];

    List<File?> capturedImg = []; // Initialize capturedImg with an empty list

    Map<String, dynamic> initialData = popupData[index] ??
        {
          'note': checklist[index].notes,
          'images': capturedImg,
        };

    List<File?> capturedImages =
        (initialData['images'] as List?)?.cast<File?>() ?? [];

    List<String> dataPointValues = userEnteredDataPoints[index] ??
        List<String>.filled(
          selectedDropdownValues.length,
          "",
          growable: true,
        );

    for (String imageUrl in imageUrls) {
      final uniqueUrl = Uri.parse(imageUrl)
          .replace(
              query:
                  'timestamp=${DateTime.now().millisecondsSinceEpoch}-${UniqueKey().toString()}')
          .toString();

      // Download the image and convert it to a file
      final response = await http.get(Uri.parse(uniqueUrl));
      final List<int> bytes = response.bodyBytes;

      // Get the app's document directory to store the files
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${appDocumentDirectory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Write the bytes to a file
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      capturedImg.add(file);
    }
    // Load previously captured images

    // Access notes, provide a default value if null

    // TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Pre-fill the input fields with initial data
    var noteValue = "";

    TextEditingController noteController = TextEditingController();

    noteController.text = initialData['note'];

    // descriptionController.text = initialData['description'];

    List<DataEntry> localDataEntries = myStatefulWidgetDataMap[index] ?? [];

    List<String> acrdDescription = [];

    List<String> datalowerRangeValue = [];
    List<String> datahigherRangeValue = [];
    List<String> dataamtsValue = [];

    void onMyStatefulWidgetDataChanged(int index, List<DataEntry> newData) {
      setState(() {
        myStatefulWidgetDataMap[index] = newData;
      });
    }

    final lowerRangeValue = "";

    final upperRangeValue = "";
    final amts_value = "";

    bool isValidInteger(String value) {
      if (value == null) return false;
      final trimmedValue = value.trim();
      if (trimmedValue.isEmpty) return false;
      return double.parse(trimmedValue) != null;
    }
final size= MediaQuery.of(context).size.width<600;
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AlertDialog(
              backgroundColor: themeProvider.isDarkTheme
                  ? const Color(0xFF424242)
                  : Color.fromARGB(255, 255, 255, 255),
              content: Container(
                width: size? 300: 550,
                height: size ? 400 :700,
                color: themeProvider.isDarkTheme
                    ? const Color(0xFF424242)
                    : Color.fromARGB(255, 255, 255, 255),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [

                      size ?     Column(
                        children: [
                           
                          Row(
                            children: [
                            
                              Expanded(
                                child: ImageCapture(
                                  capturedImages: capturedImages,
                                  onImagesCaptured: (updatedImages) {
                                    setState(() {
                                      capturedImages = updatedImages;
                                      popupData[index]?['images'] =
                                          capturedImages ?? "";
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: defaultPadding,
                              ),
                            ],
                          ),
                        ],
                      ):

                      Row(
                        children: [
                          const Text('Add Images        :'),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ImageCapture(
                              capturedImages: capturedImages,
                              onImagesCaptured: (updatedImages) {
                                setState(() {
                                  capturedImages = updatedImages;
                                  popupData[index]?['images'] =
                                      capturedImages ?? "";
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                        ],
                      ),


size ? Column(
                        children: [
                       
                          Container(

                            width: double.infinity,
                            height: 50,
                            child: TextFormField(
                              controller: noteController,
                            
                              onChanged: (value) {
                                noteValue = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter Notes',
                                floatingLabelBehavior:

                                    FloatingLabelBehavior.never,
                                contentPadding:
                                    EdgeInsets.all(defaultPadding),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.yellow,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: '',
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (value) {
                                if (selectedDropdownValues[index].first !=
                                    "Passed") {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter the Notes';
                                  }
                                  //                                 if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  //   return 'Cannot contain special symbols';
                                  // }
                                  if (value.startsWith(' ')) {
                                    return 'Notes cannot start with a space';
                                  }
                                }
                                return null; // Return null when "Passed" is selected
                              },
                            ),
                          ),
                        ],
                      ):

                      Row(
                        children: [
                          const Text('Add Notes           :'),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: noteController,
                              onChanged: (value) {
                                noteValue = value;
                              },
                              decoration: const InputDecoration(
                                hintMaxLines: 2,
                                labelText: 'Enter Notes',
                                floatingLabelBehavior:
                              
                                    FloatingLabelBehavior.never,
                                contentPadding:
                                    EdgeInsets.all(defaultPadding * 3),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.yellow,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: '',
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (value) {
                                if (selectedDropdownValues[index].first !=
                                    "Passed") {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter the Notes';
                                  }
                                  //                                 if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  //   return 'Cannot contain special symbols';
                                  // }
                                  if (value.startsWith(' ')) {
                                    return 'Notes cannot start with a space';
                                  }
                                }
                                return null; // Return null when "Passed" is selected
                              },
                            ),
                          ),
                        ],
                      ),


                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Consumer<DataPointProvider>(
                        builder: (context, DetailsProvider, _) {
                          final response = DetailsProvider.user;
                          final datapoint = response?.checklistDatapointsList;

                          acrdDescription =
                              List.generate(datapoint?.length ?? 0, (index) {
                            return datapoint![index]
                                    ?.amdpDatapointDescription
                                    .toString() ??
                                ''; // Return acrdpId as String or an empty string if datapoint[index] is null
                          });

                          acrdpValues =
                              List.generate(datapoint?.length ?? 0, (index) {
                            return datapoint![index]?.acrdpId.toString() ??
                                ''; // Return acrdpId as String or an empty string if datapoint[index] is null
                          });

                          datalowerRangeValue =
                              List.generate(datapoint?.length ?? 0, (index) {
                            return datapoint![index]?.amtsLowerRangeValue ??
                                ''; // Return acrdpId as String or an empty string if datapoint[index] is null
                          });
                          datahigherRangeValue =
                              List.generate(datapoint?.length ?? 0, (index) {
                            return datapoint![index]?.amtsUpperRangeValue ??
                                ''; // Return acrdpId as String or an empty string if datapoint[index] is null
                          });

                          dataamtsValue =
                              List.generate(datapoint?.length ?? 0, (index) {
                            return datapoint![index]?.amtsValue ??
                                ''; // Return acrdpId as String or an empty string if datapoint[index] is null
                          });

                          datapointControllers = List.generate(
                            datapoint?.length ?? 0,
                            (index) {
                              if (index < datapoint!.length) {
                                final initialValue =
                                    datapoint[index].datapointValue.toString();
                                return TextEditingController(
                                    text: initialValue);
                              } else {
                                // Handle the case where dataPointValues is shorter than datapoint
                                return TextEditingController();
                              }
                            },
                          );

                          // Update the TextEditingController objects with locally stored values
                          if (userEnteredDataPoints.containsKey(index)) {
                            final List<String> storedValues =
                                userEnteredDataPoints[index]!;
                            for (int i = 0; i < storedValues.length; i++) {
                              if (i < datapointControllers.length) {
                                // Update existing TextEditingController
                                datapointControllers[i].text = storedValues[i];
                              } else {
                                // Create and add a new TextEditingController for missing values
                                datapointControllers.add(TextEditingController(
                                    text: storedValues[i]));
                              }
                            }
                          }

                          return Column(
                            children: [
                              if (datapoint?.length != 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Data Point:"),
                                    Card(
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      child: SizedBox(
                                        height: size ?250 : 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size ?100: 180,
                                                      child: Text(
                                                        "Parameter",
                                                        style: TextStyle(
                                                          fontSize: size ?14: 17,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:  size ?75 :150,
                                                      child: Text(
                                                        "Specification",
                                                        style: TextStyle(
                                                          fontSize: size ?14: 17,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 60,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        "Actual",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      datapoint?.length ?? 0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        datapoint?[index];
                                                    final lowerRangeValue = item
                                                        ?.amtsLowerRangeValue;
                                                    final upperRangeValue = item
                                                        ?.amtsUpperRangeValue;

                                                    final datapointcondition =
                                                        (((lowerRangeValue !=
                                                                        null &&
                                                                    upperRangeValue !=
                                                                        null) &&
                                                                isValidInteger(
                                                                    lowerRangeValue) &&
                                                                isValidInteger(
                                                                    upperRangeValue) &&
                                                                (double.tryParse(
                                                                            lowerRangeValue) ??
                                                                        0) <=
                                                                    (double.tryParse(datapointControllers[index].text) ??
                                                                        0) &&
                                                                (double.tryParse(
                                                                            upperRangeValue) ??
                                                                        0) >=
                                                                    (double.tryParse(datapointControllers[index]
                                                                            .text) ??
                                                                        0)) ||
                                                            (datapointControllers[
                                                                        index]
                                                                    .text ==
                                                                item!.amtsValue) // Compare entered value with expected value
                                                        );

                                                    final setvaluerange =
                                                        (lowerRangeValue ==
                                                                    '0' ||
                                                                lowerRangeValue
                                                                        ?.isEmpty ==
                                                                    true) &&
                                                            (upperRangeValue ==
                                                                    '0' ||
                                                                upperRangeValue
                                                                        ?.isEmpty ==
                                                                    true) &&
                                                            (item?.amtsValue ==
                                                                    '0' ||
                                                                item?.amtsValue
                                                                        ?.isEmpty ==
                                                                    true);

                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height:
                                                              defaultPadding,
                                                        ),
                                                        SizedBox(
                                                          height: 80,
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 200,
                                                                child: Text(
                                                                    "${item?.amdpDatapointDescription}  "),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              if (item?.amtsLowerRangeValue
                                                                      ?.isNotEmpty ??
                                                                  false)
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "${item?.amtsLowerRangeValue}"),
                                                                      const Text(
                                                                          "-"),
                                                                      Text(
                                                                          "${item?.amtsUpperRangeValue}"),
                                                                    ],
                                                                  ),
                                                                )
                                                              else
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(
                                                                      item?.amtsValue ??
                                                                          ""),
                                                                ),
                                                              SizedBox(
                                                                width: 28,
                                                              ),
                                                              SizedBox(
                                                                width: 150,
                                                                height:
                                                                    70, // Set the desired height here
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            datapointControllers[index],
                                                                        onChanged:
                                                                            (newValue) {
                                                                          setState(
                                                                              () {
                                                                            if (index >= 0 &&
                                                                                index < dataPointValues.length) {
                                                                              dataPointValues[index] = newValue;
                                                                            }
                                                                          });
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Enter value',
                                                                          floatingLabelBehavior:
                                                                              FloatingLabelBehavior.never,
                                                                          contentPadding:
                                                                              EdgeInsets.all(defaultPadding),
                                                                          errorStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10.0, // Adjust the font size as needed
                                                                            height:
                                                                                0.10, // Adjust the height to control spacing
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: setvaluerange
                                                                                  ? Colors.grey // Skip validation if all values are 0 or empty
                                                                                  : datapointControllers[index].text.isEmpty
                                                                                      ? Colors.grey
                                                                                      : datapointcondition
                                                                                          ? Colors.grey
                                                                                          : Colors.orange, // Border color when validation fails
                                                                              width: 2.0, // Border width when focused
                                                                            ),
                                                                          ),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: setvaluerange
                                                                                  ? Colors.grey // Skip validation if all values are 0 or empty
                                                                                  : datapointControllers[index].text.isEmpty
                                                                                      ? Colors.grey
                                                                                      : datapointcondition
                                                                                          ? Colors.grey
                                                                                          : Colors.orange, // Border color when validation fails
                                                                              width: 2.0, // Border width when focused
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: setvaluerange
                                                                                  ? Colors.grey // Skip validation if all values are 0 or empty
                                                                                  : datapointControllers[index].text.isEmpty
                                                                                      ? Colors.grey
                                                                                      : datapointcondition
                                                                                          ? Colors.grey
                                                                                          : Colors.orange, // Border color when validation fails
                                                                              width: 2.0, // Border width when focused
                                                                            ),
                                                                          ),
                                                                          hintText: dataPointValues.isNotEmpty
                                                                              ? 'Enter Value'
                                                                              : '',
                                                                          labelStyle:
                                                                              TextStyle(
                                                                            color: datapointControllers[index].text.isEmpty
                                                                                ? Colors.grey
                                                                                : ((lowerRangeValue != null && upperRangeValue != null) && isValidInteger(lowerRangeValue) && isValidInteger(upperRangeValue) && (double.tryParse(lowerRangeValue) ?? 0) <= (double.tryParse(datapointControllers[index].text) ?? 0) && (double.tryParse(upperRangeValue) ?? 0) >= (double.tryParse(datapointControllers[index].text) ?? 0)) || ((isValidInteger(item?.amtsValue ?? "")) && (isValidInteger(datapointControllers[index].text) ?? false) && (int.tryParse(item?.amtsValue ?? "") ?? 0) == (int.tryParse(datapointControllers[index].text) ?? 0))
                                                                                    ? Colors.black
                                                                                    : Colors.orange,
                                                                          ),
                                                                        ),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'^\d+\.?\d{0,4}')),
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Required Field';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    ),
                                                                    (setvaluerange ||
                                                                            datapointControllers[index]
                                                                                .text
                                                                                .isEmpty)
                                                                        ? const Text(
                                                                            "")
                                                                        : (((lowerRangeValue != null && upperRangeValue != null) && isValidInteger(lowerRangeValue) && isValidInteger(upperRangeValue) && (double.tryParse(lowerRangeValue) ?? 0) <= (double.tryParse(datapointControllers[index].text) ?? 0) && (double.tryParse(upperRangeValue) ?? 0) >= (double.tryParse(datapointControllers[index].text) ?? 0)) ||
                                                                                (datapointControllers[index].text == item!.amtsValue))
                                                                            ? const Text('')
                                                                            : const Text(
                                                                                "Value out of Spec",
                                                                                style: TextStyle(color: Colors.orange, fontSize: 12),
                                                                              ),
                                                                  ],
                                                                ),
                                                              ),
                                                              (((lowerRangeValue == '0' || lowerRangeValue?.isEmpty == true) &&
                                                                          (upperRangeValue == '0' ||
                                                                              upperRangeValue?.isEmpty ==
                                                                                  true) &&
                                                                          (item?.amtsValue == '0' ||
                                                                              item?.amtsValue?.isEmpty ==
                                                                                  true)) ||
                                                                      datapointControllers[
                                                                              index]
                                                                          .text
                                                                          .isEmpty)
                                                                  ? Text("")
                                                                  : datapointcondition
                                                                      ? Text('')
                                                                      : Icon(
                                                                          Icons
                                                                              .warning,
                                                                          color:
                                                                              Colors.orange,
                                                                        ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Data Points        :'),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(child: Text("No Data Points"))
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isConfirmButtonVisible)
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    isConfirmButtonVisible = false;

                                    final Map<String, dynamic> data = {
                                      'note': noteController.text,
                                      'images':
                                          capturedImages, // Store captured images
                                    };

                                    popupData[index] = data;

                                    // Get edited values from the text controllers
                                    List<String> editedValues =
                                        datapointControllers
                                            .map(
                                                (controller) => controller.text)
                                            .toList();

                                    userEnteredDataPoints[index] = editedValues;

                                    List<Map<String, String>> combinedValues =
                                        [];
                                    for (int i = 0;
                                        i < acrdDescription.length;
                                        i++) {
                                      Map<String, String> valuePair = {
                                        'acrpDescription': acrdDescription[i],
                                        'acrdpId': acrdpValues[i],
                                        'editedValue': i < editedValues.length
                                            ? editedValues[i]
                                            : "", // Use edited value if available, otherwise use an empty string
                                      };
                                      combinedValues.add(valuePair);
                                    }
                                    EnteredDataPoints[index] = combinedValues;
                                    myStatefulWidgetDataMap[index] =
                                        localDataEntries;
                                    _showPopup(context, index);
                                  }
                                },
                                child: const Text(
                                  "Okay",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 8,
                            ),
                            if (!isConfirmButtonVisible)
                              ElevatedButton(
                                onPressed: () {
                                  List<String> editedValues =
                                      datapointControllers
                                          .map((controller) => controller.text)
                                          .toList();

                                  if (acrdpValues.length != 0)
                                    setState(() {
                                      isConfirmButtonVisible = false;
                                      bool allConditionsMet =
                                          true; // Assume all conditions are met initially

                                      for (int i = 0;
                                          i < acrdpValues.length;
                                          i++) {
                                        if (((((datalowerRangeValue[i] == '0' ||
                                                        datalowerRangeValue[i]
                                                            .isEmpty) &&
                                                    (datahigherRangeValue[i] ==
                                                            "0" ||
                                                        datahigherRangeValue[i]
                                                            .isEmpty) &&
                                                    (dataamtsValue[i] == "0" ||
                                                        dataamtsValue[i]
                                                            .isEmpty)) ||
                                                isValidInteger(datalowerRangeValue[i]) &&
                                                    isValidInteger(
                                                        datahigherRangeValue[
                                                            i]) &&
                                                    ((double.tryParse(datalowerRangeValue[i]) ??
                                                                0) <=
                                                            (double.tryParse(datapointControllers[i].text) ??
                                                                0) &&
                                                        (double.tryParse(datahigherRangeValue[i]) ??
                                                                0) >=
                                                            (double.tryParse(editedValues[i]) ??
                                                                0)))) ||
                                            (isValidInteger(dataamtsValue[i]) &&
                                                (dataamtsValue[i] ==
                                                    datapointControllers[i].text))) {
                                          allConditionsMet = true;
                                          // Condition met

                                          // Condition met
                                        } else {
                                          // Condition not met, set allConditionsMet to false and break the loop
                                          allConditionsMet = false;
                                          break;
                                        }
                                      }
                                      // After the loop, update the selectedDropdownValues[index] based on allConditionsMet
                                      allConditionsMet
                                          ? selectedDropdownValues[index] = [
                                              "Passed"
                                            ]
                                          : selectedDropdownValues[index] = [
                                              "Failed"
                                            ];

                                      final Map<String, dynamic> data = {
                                        'note': noteController.text,
                                        'images':
                                            capturedImages, // Store captured images
                                      };

                                      popupData[index] = data;

                                      // Get edited values from the text controllers

                                      userEnteredDataPoints[index] =
                                          editedValues;

                                      List<Map<String, String>> combinedValues =
                                          [];
                                      for (int i = 0;
                                          i < acrdDescription.length;
                                          i++) {
                                        Map<String, String> valuePair = {
                                          'acrpDescription': acrdDescription[i],
                                          'acrdpId': acrdpValues[i],
                                          'editedValue': i < editedValues.length
                                              ? editedValues[i]
                                              : "", // Use edited value if available, otherwise use an empty string
                                        };
                                        combinedValues.add(valuePair);
                                      }
                                      EnteredDataPoints[index] = combinedValues;
                                      myStatefulWidgetDataMap[index] =
                                          localDataEntries;

                                      // _showPopup(context, index);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      isConfirmButtonVisible = true;
                                    });
                                  else if (formKey.currentState!.validate()) {
                                    isConfirmButtonVisible = false;
                                    final Map<String, dynamic> data = {
                                      'note': noteController.text,
                                      'images':
                                          capturedImages, // Store captured images
                                    };

                                    popupData[index] = data;

                                    // Get edited values from the text controllers

                                    userEnteredDataPoints[index] = editedValues;

                                    List<Map<String, String>> combinedValues =
                                        [];
                                    for (int i = 0;
                                        i < acrdDescription.length;
                                        i++) {
                                      Map<String, String> valuePair = {
                                        'acrpDescription': acrdDescription[i],
                                        'acrdpId': acrdpValues[i],
                                        'editedValue': i < editedValues.length
                                            ? editedValues[i]
                                            : "", // Use edited value if available, otherwise use an empty string
                                      };
                                      combinedValues.add(valuePair);
                                    }
                                    EnteredDataPoints[index] = combinedValues;
                                    myStatefulWidgetDataMap[index] =
                                        localDataEntries;

                                    // _showPopup(context, index);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    isConfirmButtonVisible = true;

                                    // Navigator.of(context)
                                    //     .pop();
                                  }
                                },
                                child: Text("Confirm"),
                              ),
                            // Confirm button for the checkbox

                            const SizedBox(
                              width: 8,
                            ),
                            if (isConfirmButtonVisible)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // popupData.clear();
                                    // userEnteredDataPoints.clear();
                                    // myStatefulWidgetDataMap.clear();

                                    // if (selectedDropdownValues[index].first !=
                                    //     "Passed")
                                    if (!formKey.currentState!.validate()) {
                                      selectedDropdownValues[index] = [
                                        "Select Answer"
                                      ];
                                    }
                                  });

                                  final Map<String, dynamic> data = {
                                    'note': noteController.text,
                                    // 'description':
                                    //     descriptionController.text ?? "",
                                    // 'dataPoints': dataPointValues,
                                    'images':
                                        capturedImages, // Store captured images
                                  };

                                  popupData[index] = data;
                                  final List<String> editedValues =
                                      datapointControllers
                                          .map((controller) => controller.text)
                                          .toList();

                                  userEnteredDataPoints[index] = editedValues;

                                  myStatefulWidgetDataMap[index] =
                                      localDataEntries;

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final response = Provider.of<CheckListProvider>(context, listen: false)
        .user
        ?.responseData;
    final asset = response?.checklist ?? [];

    // final DateFormat inputFormat = DateFormat('yyyy-MM-dd');

    final inspectionDetails =
        Provider.of<GetCheckListDetailsProvider>(context, listen: false)
            .user
            ?.responseData
            .getChecklistDetails;

    final String? inspectionDate =
        (inspectionDetails != null && inspectionDetails.isNotEmpty)
            ? inspectionDetails.first.acrpinspectiondate
            : null;

    final DateFormat dateInputFormat = DateFormat("yyyy-MM-dd");
    DateTime convertDate;

    if (inspectionDate != null) {
      convertDate = dateInputFormat.parse(inspectionDate);
    } else {
      print('Inspection date is null');
      convertDate =
          DateTime.now(); // Assign a default value if inspectionDate is null
    }

    String inspectiondate = DateFormat("yyyy-MM-dd").format(convertDate);
    DateTime nowdate = DateTime.now();
    String currentdate = DateFormat("yyyy-MM-dd").format(nowdate);

    print('Inspection Date: $inspectiondate');
    print('Current Date: $currentdate');

    final qrresponse = Provider.of<QrScannerProvider>(context, listen: false)
        .user
        ?.responseData;
    final qrasset = qrresponse?.checklist ?? [];
    final cheklistcurrentvalue =
        context.read<GetCheckListDetailsProvider>().user?.responseData;

    bool isAnySelectAnswer =
        selectedDropdownValues.any((value) => value.first == "Select Answer");

    final size = MediaQuery.of(context).size.width < 600;
    return Consumer<GetCheckListDetailsProvider>(
      builder: (context, getCheckListDetailsProvider, _) {
        final responseData = getCheckListDetailsProvider.user?.responseData;
        final checklist = responseData?.getChecklistDetails ?? [];

        String chekListname = '';

        if (checklist.isNotEmpty) {
          chekListname = checklist.first.checklistName;
        }

        String headerImage = '';
        if (checklist.isNotEmpty) {
          headerImage = checklist.first.headerimageurl;
        }

        Widget buildImageWidget() {
          Widget imageWidget;

          if (headerImage != null) {
            try {
              imageWidget = Image.network(
                checklist.first.headerimageurl,
                width: 100, // Set the width as needed
                height: 50, // Set the height as needed
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/Suji shoie1.jpg', // Replace with the path to your placeholder image
                    width: 100, // Set the width as needed
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              );
            } catch (e) {
              print('Error loading image: $e');
              imageWidget = Image.asset(
                'assets/images/Suji shoie1.jpg', // Replace with the path to your placeholder image
                width: 50, // Set the width as needed
                height: 30, // Set the height as needed
                fit: BoxFit.cover,
              );
            }
          } else {
            imageWidget = Image.asset(
              'assets/images/Suji shoie1.jpg', // Replace with the path to your placeholder image
              width: 50, // Set the width as needed
              height: 30, // Set the height as needed
              fit: BoxFit.cover,
            );
          }

          return imageWidget;
        }

        Widget _buildStatusBadge(String text, Color color) {
          return Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        }

        /// Helper Method: Label & Value Text
        Widget _buildLabeledText(String label, String value) {
          return Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              AutoSizeText(
                value,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }

        return isLoading
            ? Scaffold(
                body: Center(
                  child: LottieLoadingAnimation(),
                ),
              )
            : checklist.isEmpty
                ? Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      iconTheme: const IconThemeData(
                        color: Colors.white,
                      ),
                      toolbarHeight: 90,
                      title: const Text(""),
                    ),
                    body: const Center(
                      child: Text(
                        "No checklist data",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : WillPopScope(
                    onWillPop: () async {
                      return (widget.acrpinspectionstatus != 3 &&
                              widget.acrpinspectionstatus != 4)
                          ? false
                          : true;
                    },
                    child: size
                        ? Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                              toolbarHeight: 130,
                              backgroundColor: themeProvider.isDarkTheme
                                  ? const Color(0xFF212121)
                                  : const Color(0xFF25476A),
                              title: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// First Row: Asset Name & Status Badge
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Asset Name
                                          Expanded(
                                            child: AutoSizeText(
                                              widget.assetname ?? "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          /// Status Badge
                                          if (widget.acrpinspectionstatus == 2)
                                            _buildStatusBadge(
                                                "In Progress", Colors.orange)
                                          else if (widget
                                                      .acrpinspectionstatus ==
                                                  3 ||
                                              widget.acrpinspectionstatus == 4)
                                            _buildStatusBadge(
                                                "Completed", Colors.green)
                                          else if (widget
                                                      .acrpinspectionstatus ==
                                                  1 &&
                                              inspectiondate == currentdate)
                                            _buildStatusBadge(
                                                "Open", Colors.blue),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      /// Second Row: Reference No & Checklist Name
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Reference Number
                                          _buildLabeledText("Ref No -",
                                              "${checklist.first.documentNo ?? 0}"),

                                          /// Checklist Name (Optional - Uncomment if needed)
                                          // Expanded(
                                          //   child: AutoSizeText(
                                          //     chekListname,
                                          //     maxLines: 2,
                                          //     style: const TextStyle(
                                          //       fontSize: 18,
                                          //       fontWeight: FontWeight.bold,
                                          //       color: Colors.white,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      /// Third Row: Revision No & Inspection Date
                                      Row(
                                        children: [
                                          _buildLabeledText("Revision No -",
                                              "${checklist.first.versionId ?? 0}"),
                                          const SizedBox(width: 10),
                                          Text(
                                            inspectiondate ?? "",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                if (widget.acrpinspectionstatus == 3 ||
                                    widget.acrpinspectionstatus == 4)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child:
                                            ClipOval(child: buildImageWidget()),
                                      ),
                                    ],
                                  )
                                else
                                  SizedBox(
                                    width: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          widget.capturedImages?.length ??
                                              0, // Handle null list
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final File? imageFile =
                                            widget.capturedImages?[index];

                                        if (imageFile == null) {
                                          return SizedBox(); // Return an empty widget if null
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, top: 30, bottom: 10),
                                          child: ClipOval(
                                            child: Image.file(
                                              imageFile,
                                              width:
                                                  90, // Adjust width as needed
                                              height:
                                                  90, // Adjust height as needed
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),

                            /// Helper Method: Status Badge

                            body: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    children: [
                                      AutoSizeText(
                                        chekListname,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    if (isTextFieldVisible)
                                      // Show TextField conditionally
                                      if (widget.acrpinspectionstatus == 3 ||
                                          widget.acrpinspectionstatus == 4)
                                        Text(
                                          checklist.first.personfname,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                      else
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Form(
                                                  key: operatorFormKey,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left:
                                                                defaultPadding *
                                                                    2),
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                    child: TextFormField(
                                                      controller:
                                                          numberController,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter Operator Id';
                                                        }
                                                        if (value.contains(RegExp(
                                                            r'[!@#$%^&*(),.?":{}|<>]'))) {
                                                          return 'Operator Id cannot contain special symbols';
                                                        }
                                                        if (value
                                                            .contains(' ')) {
                                                          return 'Operator Id cannot contain spaces';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Enter Operator Id',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black45),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        labelStyle:
                                                            const TextStyle(
                                                                fontSize: 10),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade50),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade50),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (operatorFormKey
                                                          .currentState
                                                          ?.validate() ==
                                                      true) {
                                                    handleSubmit();
                                                  }
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    if (!isTextFieldVisible)
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Operator Name", // Show personName
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                  " ${personName.substring(0, 1).toUpperCase()}${personName.substring(1).toLowerCase()}", // Show personName
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        defaultPadding / 2),
                                    child: ListView.builder(
                                      itemCount: checklist.length,
                                      itemBuilder: (context, index) {
                                        final asset = checklist[index];
                                        String decodedTamilText = utf8.decode(
                                          asset.checkpoint.runes.toList(),
                                          allowMalformed: true,
                                        );
                                        final statusIcon = asset.methods;
                                        final role = responsibilityRole(
                                            asset.responsibility);

                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 5),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      child: Text(
                                                        "${asset.seqNo}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            decodedTamilText,
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            role,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    getStatusIcon(statusIcon),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            value: index <
                                                                        selectedDropdownValues
                                                                            .length &&
                                                                    selectedDropdownValues[
                                                                            index]
                                                                        .isNotEmpty
                                                                ? selectedDropdownValues[
                                                                        index]
                                                                    .first
                                                                : "Select Answer",
                                                            onChanged:
                                                                (newValue) {
                                                              _handleDropdownChange(
                                                                  index,
                                                                  newValue!);
                                                            },
                                                            items: [
                                                              "Select Answer",
                                                              "Passed",
                                                              "Failed",
                                                              "Conditionally Passed",
                                                              "Not Applicable"
                                                            ]
                                                                .map(
                                                                  (value) =>
                                                                      DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (showDataPointsButton &&
                                                        index <
                                                            selectedDropdownValues
                                                                .length &&
                                                        selectedDropdownValues[
                                                                index]
                                                            .isNotEmpty &&
                                                        selectedDropdownValues[
                                                                    index]
                                                                .first !=
                                                            "Not Applicable" &&
                                                        selectedDropdownValues[
                                                                    index]
                                                                .first !=
                                                            "Select Answer")
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            if (!singleTap) {
                                                              singleTap = true;
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              2))
                                                                  .then((_) =>
                                                                      singleTap =
                                                                          false);
                                                              await _showPopup(
                                                                  context,
                                                                  index);
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        10),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            backgroundColor:
                                                                Colors.blue,
                                                          ),
                                                          child: const Text(
                                                            "Add Input",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (widget.acrpinspectionstatus != 3 &&
                                    widget.acrpinspectionstatus != 4)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (personName.isNotEmpty &&
                                              !isTextFieldVisible) {
                                            try {
                                              final response =
                                                  await submitChecklist(context,
                                                      "submit_checklist", 2);
                                              if (response['response_code'] == 4 ||
                                                  response['response_code'] ==
                                                      5 ||
                                                  response['response_code'] ==
                                                      6) {
                                                ShowError.showAlert(context,
                                                    response['response_msg']);
                                              } else {
                                                // If response_code is not 4, 5, or 6, proceed to _navigateBack()
                                                _navigateBack();
                                              }
                                            } catch (error) {
                                              // Handle and show the error message here
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text(error.toString()),
                                                  backgroundColor: Colors.amber,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: personName.isNotEmpty
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        child: const Text("Save"),
                                      ),
                                      const SizedBox(width: defaultPadding),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (!isAnySelectAnswer &&
                                              personName.isNotEmpty) {
                                            _submitPop(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: !isAnySelectAnswer &&
                                                  personName.isNotEmpty
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        child: const Text("Submit"),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // pauseStatus();
                                          _navigateBack();
                                          //   popupData.clear();
                                          //   userEnteredDataPoints.clear();
                                          //   myStatefulWidgetDataMap.clear();
                                          //   numberController.clear();
                                        },
                                        child: const Text("Go Back"),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Go Back"),
                                      ),
                                    ],
                                  ),
                              ],
                            ))
                        : Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                              toolbarHeight: 110,
                              title: PreferredSize(
                                preferredSize: const Size.fromHeight(90),
                                child: Container(
                                  color: themeProvider.isDarkTheme
                                      ? const Color(0xFF212121)
                                      : const Color(0xFF25476A),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  height: 180,
                                  child: SafeArea(
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(children: [
                                                  AutoSizeText(
                                                    widget.assetname ?? "",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    inspectiondate ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (widget
                                                          .acrpinspectionstatus ==
                                                      2)
                                                    Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        "Inprogress",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )
                                                  else if (widget
                                                              .acrpinspectionstatus ==
                                                          3 ||
                                                      widget.acrpinspectionstatus ==
                                                          4)
                                                    Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        "Completed",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )
                                                  else if (widget
                                                              .acrpinspectionstatus ==
                                                          1 &&
                                                      inspectiondate ==
                                                          currentdate)
                                                    Container(
                                                      height: 30,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        "Open",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  SizedBox(width: 20),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Ref No - ",
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: AutoSizeText(
                                                          "${checklist.first.documentNo ?? 0}",
                                                          maxFontSize: 20,
                                                          minFontSize: 18,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),

                                              // if (widget.acrpinspectionstatus == 1)
                                              //   Container(
                                              //     height: 30,
                                              //     width: 75,
                                              //     decoration: BoxDecoration(
                                              //         color: Colors.red,
                                              //         borderRadius:
                                              //             BorderRadius.circular(6))
                                              //     padding: EdgeInsets.all(6),
                                              //     child: Text(
                                              //       "Overdue",
                                              //       style: TextStyle(
                                              //           fontSize: 16,
                                              //           color: Colors.black),
                                              //     ),
                                              //   )
                                            ],
                                          ),

                                          //                                widget.pageId == 1?

                                          // Text(
                                          //                                qrasset.first.assetname??"",
                                          //                                 style: const TextStyle(
                                          //                                   fontSize: 20,
                                          //                                   fontWeight: FontWeight.bold,
                                          //                                   color: Colors.white,
                                          //                                 ),
                                          //                               ):  Text(
                                          //                               asset.first.assetname??"",
                                          //                                 style: const TextStyle(
                                          //                                   fontSize: 20,
                                          //                                   fontWeight: FontWeight.bold,
                                          //                                   color: Colors.white,
                                          //                                 ),
                                          //                               ),

                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: AutoSizeText(
                                                    chekListname,
                                                    maxFontSize: 25,
                                                    minFontSize: 20,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Revison No - ",
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${checklist.first.versionId ?? 0}",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (isTextFieldVisible)
                                                  // Show TextField conditionally
                                                  if (widget.acrpinspectionstatus ==
                                                          3 ||
                                                      widget.acrpinspectionstatus ==
                                                          4)
                                                    Text(
                                                      checklist
                                                          .first.personfname,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  else
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Form(
                                                              key:
                                                                  operatorFormKey,
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    left:
                                                                        defaultPadding *
                                                                            2),
                                                                decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5))),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      numberController,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter Operator Id';
                                                                    }
                                                                    if (value.contains(
                                                                        RegExp(
                                                                            r'[!@#$%^&*(),.?":{}|<>]'))) {
                                                                      return 'Operator Id cannot contain special symbols';
                                                                    }
                                                                    if (value
                                                                        .contains(
                                                                            ' ')) {
                                                                      return 'Operator Id cannot contain spaces';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Enter Operator Id',
                                                                    hintStyle: const TextStyle(
                                                                        color: Colors
                                                                            .black45),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    labelStyle: const TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                    contentPadding:
                                                                        const EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .blueGrey
                                                                              .shade50),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .blueGrey
                                                                              .shade50),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (operatorFormKey
                                                                      .currentState
                                                                      ?.validate() ==
                                                                  true) {
                                                                handleSubmit();
                                                              }
                                                            },
                                                            child: const Text(
                                                              'OK',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                if (!isTextFieldVisible)
                                                  Text(
                                                    personName, // Show personName
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                if (widget.acrpinspectionstatus == 3 ||
                                    widget.acrpinspectionstatus == 4)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, top: 8, bottom: 8),
                                          child: ClipOval(
                                              child: buildImageWidget()),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  SizedBox(
                                    width: 150,
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.capturedImages?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final imageFile =
                                            widget.capturedImages?[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16,
                                            top: 8,
                                            bottom: 8,
                                          ),
                                          child: ClipOval(
                                            child: Image.file(
                                              imageFile!,
                                              width:
                                                  100, // Set the width as needed
                                              height:
                                                  50, // Set the height as needed
                                              fit: BoxFit
                                                  .cover, // Adjust the fit as needed
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            body: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    child: ListView.builder(
                                      itemCount: checklist.length,
                                      itemBuilder: (context, index) {
                                        final asset = checklist[index];
                                        String decodedTamilText = utf8.decode(
                                            asset.checkpoint.runes.toList(),
                                            allowMalformed: true);
                                        final statusIcon = asset.methods;
                                        final role = responsibilityRole(
                                            asset.responsibility);

                                        return Card(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          child: Container(
                                              height: 250,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: ListTile(
                                                      title: Text(
                                                          "${asset.seqNo}."),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: ListTile(
                                                      title: AutoSizeText(
                                                        decodedTamilText,
                                                        maxLines: 10,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 100,
                                                      child: getStatusIcon(
                                                          statusIcon),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 60,
                                                      child: Text(role),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    DropdownButton<
                                                                        String>(
                                                                      underline:
                                                                          Container(),
                                                                      value: index < selectedDropdownValues.length &&
                                                                              selectedDropdownValues[index].isNotEmpty
                                                                          ? selectedDropdownValues[index].first
                                                                          : "Select Answer",
                                                                      onChanged:
                                                                          (newValue) {
                                                                        _handleDropdownChange(
                                                                            index,
                                                                            newValue!);
                                                                      },
                                                                      items: <String>[
                                                                        "Select Answer",
                                                                        "Passed",
                                                                        "Failed",
                                                                        "Conditionally Passed",
                                                                        "Not Applicable"
                                                                      ].map<
                                                                          DropdownMenuItem<
                                                                              String>>((String
                                                                          value) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              value,
                                                                          child:
                                                                              Text(value),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if (showDataPointsButton &&
                                                            index <
                                                                selectedDropdownValues
                                                                    .length && // Check if index is within range
                                                            selectedDropdownValues[
                                                                    index]
                                                                .isNotEmpty && // Check if the list is not empty
                                                            selectedDropdownValues[
                                                                        index]
                                                                    .first !=
                                                                "Not Applicable" &&
                                                            selectedDropdownValues[
                                                                        index]
                                                                    .first !=
                                                                "Select Answer")
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (!singleTap) {
                                                                    singleTap =
                                                                        true;
                                                                    Future.delayed(const Duration(
                                                                            seconds:
                                                                                2))
                                                                        .then((value) =>
                                                                            singleTap =
                                                                                false);
                                                                    await _showPopup(
                                                                        context,
                                                                        index);
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Add Input",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (widget.acrpinspectionstatus != 3 &&
                                    widget.acrpinspectionstatus != 4)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (personName.isNotEmpty &&
                                              !isTextFieldVisible) {
                                            try {
                                              final response =
                                                  await submitChecklist(context,
                                                      "submit_checklist", 2);
                                              if (response['response_code'] == 4 ||
                                                  response['response_code'] ==
                                                      5 ||
                                                  response['response_code'] ==
                                                      6) {
                                                ShowError.showAlert(context,
                                                    response['response_msg']);
                                              } else {
                                                // If response_code is not 4, 5, or 6, proceed to _navigateBack()
                                                _navigateBack();
                                              }
                                            } catch (error) {
                                              // Handle and show the error message here
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text(error.toString()),
                                                  backgroundColor: Colors.amber,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: personName.isNotEmpty
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        child: const Text("Save"),
                                      ),
                                      const SizedBox(width: defaultPadding),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (!isAnySelectAnswer &&
                                              personName.isNotEmpty) {
                                            _submitPop(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: !isAnySelectAnswer &&
                                                  personName.isNotEmpty
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        child: const Text("Submit"),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // pauseStatus();
                                          _navigateBack();
                                          //   popupData.clear();
                                          //   userEnteredDataPoints.clear();
                                          //   myStatefulWidgetDataMap.clear();
                                          //   numberController.clear();
                                        },
                                        child: const Text("Go Back"),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Go Back"),
                                      ),
                                    ],
                                  ),
                              ],
                            )),
                  );
      },
    );
  }
}
