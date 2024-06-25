
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';
class AddToner extends StatefulWidget {
  final String qrData;

  const AddToner({super.key, required this.qrData});

  @override
  State<StatefulWidget> createState() => _AddTonerState();
}

class _AddTonerState extends State<AddToner> {
  late String qrData;

  @override
  void initState() {
    super.initState();
    qrData = widget.qrData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(
                      child: Text(
                        "Add Few More Information \nand Confirm Submission:",
                        textAlign: TextAlign.center,
                        // Align text center horizontally
                        style: TextStyle(
                          fontSize: 24.0,
                          color: colorMixGrad,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NameInputTextField(qrData: qrData,),
                    const EmailInputTextField(),
                    const AddressInputTextField(),
                    const ContactPersonInputTextField(),
                    SizedBox(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 50),
                          child: GradientButton(
                            gradientColors: const [colorFirstGrad, colorSecondGrad],
                            height: 45.0,
                            width: 10.0,
                            radius: 25.0,
                            buttonText: "Submit",
                            onPressed: () {
                              /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRViewTracesci(),
                      ));*/
                              showSnackBar(context, "Submited");
                            },
                          ),
                        )),
                    SizedBox(
                      height: 100,
                    )
                  ]))),
    );
  }
}

class NameInputTextField extends StatelessWidget {
  final String qrData;
  const NameInputTextField({Key? key, required  this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: Text(
                        qrData,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

