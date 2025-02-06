// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/orgid_provider.dart';
    
import '../../../../../api_services/checklist_status_count_service.dart';
import '../../../../../providers/checklist_status_count_provider.dart';
import '../../../../../providers/theme_providers.dart';
import '../../workorder_widget/checklist_dropdown.dart';




class DropdownMenuWorkOrder extends StatefulWidget {
  final Widget pending;
  final Widget open;
  final Widget inProgress;
  final Widget complete;
  final Widget overdue;
  final Widget reject;

  // final Future<dynamic> Function(int) fetchDataFunction;
  // final void Function(dynamic) updateProviderFunction;
  final List<SheetInfo> bottomSheetInfo;


  const DropdownMenuWorkOrder({
    Key? key,
    required this.pending,
    required this.open,
    required this.inProgress,
    required this.complete,
    required this.overdue,
    required this.reject,

 required this.bottomSheetInfo,
  }) : super(key: key);

  @override
  _DropdownMenuExampleState createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuWorkOrder> {
  int selectedValueIndex = 0;
  int? isLoadingIndex; // Track which index is loading
  List<int?> statusCounts = [null, null, null]; // Use `null` to indicate no data yet

  List<String> dropdownOptions = ['Open', 'In Progress', 'Complete'];
  List<Color> valueColors = [Colors.blue, Colors.orange, Colors.green];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadStatusCount(selectedValueIndex);
    });
  }

  void _loadStatusCount(int index) {
    setState(() {
      isLoadingIndex = index; // Set loading index
      statusCounts[index] = null; // Clear the previous value until the new one loads
    });

    final orgId = Provider.of<OrgIdProvider>(context, listen: false).orgid;
    
    ChecklistStatusService()
        .getStatusCount(context: context, count: index + 1, orgid: orgId ?? 0)
        .then((_) {
      final checklistStatusCountProvider =
          Provider.of<CheckListStatusCountProvider>(context, listen: false);

      setState(() {
        statusCounts[index] = checklistStatusCountProvider.user!.count;
        isLoadingIndex = null; // Reset loading index after data loads
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 110,
            height: 30,
            child: DropdownButton<int>(
              isExpanded: true,
              elevation: 5,
              underline: Container(),
              value: selectedValueIndex,
              icon: const Icon(Icons.arrow_drop_down),
              iconEnabledColor: themeState.isDarkTheme ? Colors.blue : Colors.blue,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: themeState.isDarkTheme ? Colors.white : Colors.black,
              ),
              dropdownColor: themeState.isDarkTheme ? const Color(0xFF424242) : Colors.white,
              onChanged: (newValueIndex) {
                setState(() {
                  selectedValueIndex = newValueIndex!;
                  _loadStatusCount(newValueIndex);
                });
              },
              items: List.generate(
                dropdownOptions.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Text(dropdownOptions[index]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showBottomSheet(context);
            },
            child: isLoadingIndex == selectedValueIndex || statusCounts[selectedValueIndex] == null
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : RichText(
                    text: TextSpan(
                      text: '${statusCounts[selectedValueIndex]}',
                      style: TextStyle(
                        fontSize: 43,
                        color: valueColors[selectedValueIndex],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          text: widget.bottomSheetInfo[selectedValueIndex].text,
          content: widget.bottomSheetInfo[selectedValueIndex].content,
        );
      },
    );
  }
}




class CustomBottomSheet extends StatelessWidget {
  final String text;
  final Widget content;

  const CustomBottomSheet({super.key, 
    required this.text,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(color: Colors.black54,
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
 