import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:suja_shoie_app/feature/presentation/widget/home_page_widget/work_schedule/qr_workorder_data/qr_checlist_card.dart';


import '../../../../../../constant/utils/font_styles.dart';
import '../../../../providers/theme_providers.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({
    super.key,
    required this.themeState,
  });

  final ThemeProvider themeState;

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  late String _barcodeResult = '';

  
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size.width < 600;
    return 
    size ?
       Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
           Headings(
      subHeading: "Scanned Camera",              ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(onPressed: 
      _scanQrCode
        , icon:const  Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                    size: 40,
                  ),),
      )
          
              ],
            ):
      
    
    
    Card(elevation: 5,
    shadowColor: Colors.black,
      child: Container(
        height: 248,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.themeState.isDarkTheme
              ? const Color(0xFF424242)
              : Colors.white,
        ),
        child: InkWell(
          onTap: _scanQrCode,
          child: const Column(
            children: [
              SizedBox(
                width: 200,
                height: 220,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 120,
                ),
              ),
              Headings(
                text: "Scan Barcode",
              )
            ],
          ),
        ),
      ),
    );
  }

Future<void> _scanQrCode() async {
  String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
    '#00FF00', // Overlay color (green)
    'Cancel',  // Cancel button text
    true,      // Show flash icon
    ScanMode.QR, // Scan mode (QR code in this case)
  );

  if (!mounted) return;

  setState(() {
    _barcodeResult = barcodeResult;
  });

  // Pass the scanned barcode to the AssetListDataTable widget
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => 
      QrCheklistCard(
         _barcodeResult,
      ),
    ),
  );
}
}
