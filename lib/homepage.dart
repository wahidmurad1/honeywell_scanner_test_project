import 'package:device_apps/device_apps.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:honeywell_test/controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HoneyController honeyController = Get.find<HoneyController>();
  HoneywellScanner honeywellScanner = HoneywellScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honeywell scanner example'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Device supported: ${honeyController.isDeviceSupported}',
                  style: TextStyle(color: honeyController.isDeviceSupported.value ? Colors.green : Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scanner: ${honeyController.scannerEnabled.value ? "Started" : "Stopped"}',
                  style: TextStyle(color: honeyController.scannerEnabled.value ? Colors.blue : Colors.orange),
                ),
                const SizedBox(height: 8),
                if (honeyController.scannedData != null && honeyController.errorMessage == '')
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, height: 0.8), children: [
                      const TextSpan(text: 'Scanned code: '),
                      TextSpan(text: '${honeyController.scannedData?.code}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: 'Scanned codeId symbol: '),
                      TextSpan(text: '${honeyController.scannedData?.codeId}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: 'Scanned code type: '),
                      TextSpan(text: '${honeyController.scannedData?.codeType}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: 'Scanned aimId: '),
                      TextSpan(text: '${honeyController.scannedData?.aimId}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: 'Scanned charset: '),
                      TextSpan(text: '${honeyController.scannedData?.charset}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                const SizedBox(height: 8),
                if (honeyController.errorMessage != '') ...[
                  Text(
                    'Error: ${honeyController.errorMessage.value}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
                SwitchListTile(
                  title: const Text("Scan 1D Codes"),
                  subtitle: const Text("like Code-128, Code-39, Code-93, etc"),
                  value: honeyController.scan1DFormats.value,
                  onChanged: (value) {
                    honeyController.scan1DFormats.value = value;
                    honeyController.updateScanProperties();
                  },
                ),
                SwitchListTile(
                  title: const Text("Scan 2D Codes"),
                  subtitle: const Text("like QR, Data Matrix, Aztec, etc"),
                  value: honeyController.scan2DFormats.value,
                  onChanged: (value) {
                    honeyController.scan2DFormats.value = value;
                    honeyController.updateScanProperties();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text("Start Scanner"),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                      // onPressed: () => honeyController.onClick(1),
                      onPressed: () async {
                        if (await honeywellScanner.startScanner()) {
                          honeyController.scannerEnabled.value = true;
                        }
                      },
                    ),
                    ElevatedButton(
                        child: const Text("Stop Scanner"),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade700)),
                        // onPressed: () => honeyController.onClick(2),
                        onPressed: () async {
                          if (await honeywellScanner.stopScanner()) {
                            honeyController.scannerEnabled.value = false;
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  // onPressed: () async {
                  //   // honeyController.launchApp("package:com.example.honeywell_test_result"); // Replace with the package name of the second app
                  //   // honeyController.launchSecondApp();
                  //   // 'com.android.chrome'
                  //   await LaunchApp.openApp(
                  //     androidPackageName: 'com.example.honeywell_test_result',
                  //     // androidPackageName: 'com.android.chrome',
                  //     // openStore: true,
                  //     openStore: false,
                  //   );
                  // },
                  // onPressed: ()  {
                  //  honeyController.launchedSecondApp();
                  // },
                  onPressed: () async {
                    bool isInstalled = await DeviceApps.isAppInstalled('tech.genieinfo.gprizebond');

                    if (isInstalled) {
                      DeviceApps.openApp('tech.genieinfo.gprizebond');
                    } else {
                      print('No');
                      // Handle the case where the app is not installed
                    }
                  },
                  child: Text('Open Second App'),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       child: const Text("Start Scanning"),
                //       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                //       // onPressed: () => honeyController.onClick(3),
                //       onPressed: () async {
                //         try {
                //           // await honeywellScanner.startScanning();

                //           await honeywellScanner.startScanning();
                //         } catch (err) {
                //           print('Error is $err');
                //         }
                //       },
                //     ),
                //     ElevatedButton(
                //       child: const Text("Stop Scanning"),
                //       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade700)),
                //       // onPressed: () => honeyController.onClick(4),
                //       onPressed: () async {
                //         await honeywellScanner.stopScanning();
                //       },
                //     ),
                //   ],
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     await LaunchApp.openApp(
                //       androidPackageName: 'com.example.honeywell_test_result', // Replace with the package name of the app you want to open
                //       //  iosUrlScheme: 'example://', // Replace with the URL scheme of the app you want to open
                //     );
                //   },
                //   child: Text('Open Another App'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
