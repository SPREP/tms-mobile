import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(children: [
            Text(
              "The Telegraph Department (Marconi House) was established in 1919 in Nuku’alofa under the administration of a Mr. Land who was the Superintendent. The main functions of the office were to relay telegraph messages (via Morse code) to and from Fiji and New Zealand and to and from ships that were in the vicinity of Tonga. The Marconi House was like an amateur radio and its customers were mainly expatriates working and, or residing in Tonga. One of its other functions was to receive and broadcast overseas news. Mr. Land started disseminating descriptive weather reports on a daily basis to Suva, Fiji, to a body called the Harbour Board. They were the Weather Authority in Fiji at the time. In January 1928, four Tongans were trained in Telegraph and were posted to Haapai, Vavau, Niuatoputapu and Niuafo’ou later the same year. Part of the daily functions was to record and report the weather.  All five stations in Tonga were equipped with a rain gauge, a barometer, a Stevenson screen containing a dry and wet bulb thermometers and a maximum and minimum thermometer. Each station reported the daily weather at 2100Z. The weather reports were recorded in field books and all observations were passed to Suva, Fiji. During 1928-1931, the reports increased to three reports per day. In 1942 (during WWII), the Royal New Zealand Air Force (RNZAF) established a base at Fua’amotu (today’s main airport). They setup a 6th weather station. In 1945, the first Tongan was sent to train as a weather observer at the weather office in Suva which was under the control of the Fiji Government and the New Zealand Air Force. In 1946, the South Pacific Air Transport Council (SPATC) was established. Major countries involved were New Zealand, Australia, United Kingdom, France and many islands of the Pacific. Part of their responsibilities included production of weather forecasts (from Nadi), train personnel, provide equipment and salaries for the operations of weather stations in the Pacific including Tonga. This setup was administrated from Wellington, New Zealand. In 1948, the first qualified meteorological observer returned from Fiji and commenced duty at Fua’amotu Airport Weather Station. In 1951, the RNZAF closed down Fuaamotu airport as it was only a military aerodrome. All operations at Fuaamotu weather station were then moved and merged with the office in Nuku’alofa. In October 1951, two more officers were recruited to help man the Nuku’alofa office. The Nuku’alofa weather office remained part of the Telegraph Department until the government of Tonga took over the Meteorological Services in 1970. Then in 1986 when Telecom was corporatised, the weather office was relocated to the Ministry of Civil Aviation. It is important to note that New Zealand continued to pay for employment wages until 1986.There it remains until today. In November 2003, the Meteorological Services relocated back to Fua’amotu International Airport. It is where the Service currently operates today.",
              maxLines: 100,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    );
  }
}
