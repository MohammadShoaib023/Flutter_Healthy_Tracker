import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:health_tracker/shared/components/reusable_components.dart';
import 'package:health_tracker/smartwatch_connection/scan_screen/cubit/states.dart';
import 'package:flutter/material.dart';

class ScanCubit extends Cubit<ScanStates>
{
  ScanCubit() : super(ScanDevicesInitialState());

  static ScanCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> devicesList = [];

void startScanning(BuildContext context) {
  FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

  FlutterBluePlus.onScanResults.listen((List<ScanResult> results) {
    for (ScanResult result in results) {
      // Check if the device already exists in the list
      var deviceExists = devicesList.any((device) => device['mac'] == result.device.remoteId.str);

      // If the device does not exist, add it to the list
      if (!deviceExists) {
        print("HERE DEVICE INFO :${result.device.platformName}");
        print("HERE DEVICE INFO :${result}");
        // print("HERE DEVICE INFO :${result.device.platformName}");
        // print("HERE DEVICE INFO :${result.device.platformName}");
        // print("HERE DEVICE INFO :${result.device.platformName}");
        // print("HERE DEVICE INFO :${result.device.platformName}");
        // print("HERE DEVICE INFO :${result.device.platformName}");




        devicesList.add({
          'device': result.device.platformName,
          'name': result.device.advName 
          //: 'Unknown Device', // Check if the name is empty
          ,
          'mac': result.device.remoteId.str,

        });
      }
    }

    if (devicesList.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Found ${devicesList.length} devices');
    }

    // Emit success state after scanning is complete
    emit(ScanCompletedSuccessState());
  }).onError((error) {
    // Emit error state if an error occurs
    emit(ScanDevicesErrorState());
    if (kDebugMode) {
      print(error.toString());
    }
  });
}
}
