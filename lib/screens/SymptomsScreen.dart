import 'package:flutter/material.dart';

class SymptomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 Symptoms"),
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
                                  """COVID-19 affects different people in different ways. Most infected people will develop mild to moderate illness and recover without hospitalization.

Most common symptoms:
 • fever
 • dry cough
 • tiredness

Less common symptoms:
 • aches and pains
 • sore throat
 • diarrhoea
 • conjunctivitis
 • headache
 • loss of taste or smell
 • a rash on skin, or discolouration of fingers or toes

Serious symptoms:
 • difficulty breathing or shortness of breath
 • chest pain or pressure
 • loss of speech or movement

Seek immediate medical attention if you have serious symptoms. Always call before visiting your doctor or health facility.

People with mild symptoms who are otherwise healthy should manage their symptoms at home.

On average it takes 5–6 days from when someone is infected with the virus for symptoms to show, however it can take up to 14 days.

""",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )))))
                ])));
  }
}
