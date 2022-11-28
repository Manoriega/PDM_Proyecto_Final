import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/screens/catch/TestCatch.dart';
import 'package:pokimon/screens/catch/bloc/catch_pokemon_bloc.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((Barcode scanData) {
      setState(() {
        dynamic qrText = scanData.code;
        BlocProvider.of<CatchPokemonBloc>(context)
            .add(CatchByQR(QRresultCode: qrText));
        print('$qrText');
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  /*void readQr() async {
    if (result != null) {
      controller!.pauseCamera();
      print(result!.code);
      controller!.dispose();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatchPokemonBloc, CatchPokemonState>(
      listener: (context, state) {
        if (state is IncorrectQR)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Favor de escanear otra vez"),
            ),
          );
        if (state is SucessfulCatch) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Se escaneo un pokemon"),
            ),
          );
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TestCatch(pokemon: state.pokemon),
          ));
        }
        // TODO: implement listener
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).colorScheme.primary,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
