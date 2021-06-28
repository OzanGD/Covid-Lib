import 'package:flutter/material.dart';

class TreatmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 Treatments"),
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
                              child: Text("""Self care:
                                  
After exposure to someone who has COVID-19, do the following:
 • Call your health care provider or COVID-19 hotline to find out where and when to get a test.
 • Cooperate with contact-tracing procedures to stop the spread of the virus.
 • If testing is not available, stay home and away from others for 14 days.
 • While you are in quarantine, do not go to work, to school or to public places. Ask someone to bring you supplies.
 • Keep at least a 1-metre distance from others, even from your family members.
 • Wear a medical mask to protect others, including if/when you need to seek medical care.
 • Clean your hands frequently.
 • Stay in a separate room from other family members, and if not possible, wear a medical mask.
 • Keep the room well-ventilated.
 • If you share a room, place beds at least 1 metre apart.
 • Monitor yourself for any symptoms for 14 days.
 • Call your health care provider immediately if you have any of these danger signs: difficulty breathing, loss of speech or mobility, confusion or chest pain.
 • Stay positive by keeping in touch with loved ones by phone or online, and by exercising at home.

Medical treatments:

Scientists around the world are working to find and develop treatments for COVID-19.

 • Optimal supportive care includes oxygen for severely ill patients and those who are at risk for severe disease and more advanced respiratory support such as ventilation for patients who are critically ill.
 • Dexamethasone is a corticosteroid that can help reduce the length of time on a ventilator and save lives of patients with severe and critical illness.

WHO does not recommend self-medication with any medicines, including antibiotics, as a prevention or cure for COVID-19.

""",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )))))
                ])));
  }
}
