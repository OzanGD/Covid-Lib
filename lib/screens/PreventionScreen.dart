import 'package:flutter/material.dart';

class PreventionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 Prevention"),
          backgroundColor: Color(0xff1b1b1b),
        ),
        body: Container(
            color: Color(0xff424242),
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SingleChildScrollView(
                              child: Text(
                                  """Protect yourself and others around you by knowing the facts and taking appropriate precautions. Follow advice provided by your local health authority.

To prevent the spread of COVID-19:
 • Clean your hands often. Use soap and water, or an alcohol-based hand rub.
 • Maintain a safe distance from anyone who is coughing or sneezing.
 • Wear a mask when physical distancing is not possible.
 • Don’t touch your eyes, nose or mouth.
 • Cover your nose and mouth with your bent elbow or a tissue when you cough or sneeze.
 • Stay home if you feel unwell.
 • If you have a fever, cough and difficulty breathing, seek medical attention.

Calling in advance allows your healthcare provider to quickly direct you to the right health facility. This protects you, and prevents the spread of viruses and other infections.

Masks:
Masks can help prevent the spread of the virus from the person wearing the mask to others. Masks alone do not protect against COVID-19, and should be combined with physical distancing and hand hygiene. Follow the advice provided by your local health authority.

""",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )))))
                ])));
  }
}
