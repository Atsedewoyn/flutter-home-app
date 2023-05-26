import 'package:home_tutor_app/components/button.dart';
import 'package:home_tutor_app/models/auth_model.dart';
import 'package:home_tutor_app/providers/dio_provider.dart';
import 'package:home_tutor_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';

// ignore: camel_case_types
class TecherDetails extends StatefulWidget {
  const TecherDetails({Key? key, required this.techer, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> techer;
  final bool isFav;

  @override
  State<TecherDetails> createState() => _TecherDetailsState();
}

// ignore: camel_case_types
class _TecherDetailsState extends State<TecherDetails> {
  Map<String, dynamic> techer = {};
  bool isFav = false;

  @override
  void initState() {
    techer = widget.techer;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Teacher Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          //Favarite Button
          IconButton(
            //press this button to add/remove favorite techer
            onPressed: () async {
              //get latest favorite list from auth model
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              //if doc id is already exist, mean remove the doc id
              if (list.contains(techer['teach_id'])) {
                list.removeWhere((id) => id == techer['teach_id']);
              } else {
                //else, add new techer to favorite list
                list.add(techer['teach_id']);
              }

              //update the list into auth model and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                //update the favorite list into database
                final response = await DioProvider().storeFavDoc(token, list);
                //if insert successfully, then change the favorite status

                if (response == 200) {
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Abouttecher(
              techer: techer,
            ),
            DetailBody(
              techer: techer,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"teach_id": techer['teach_id']});
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Abouttecher extends StatelessWidget {
  const Abouttecher({Key? key, required this.techer}) : super(key: key);

  final Map<dynamic, dynamic> techer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
              " 'http://127.0.0.1:8000/' + '${techer['teacher_profile']}' ",
            ),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            "Mr. ${techer['teacher_name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'MBBS (International Medical University, Malaysia), MRCP (Royal College of Physicians, United Kingdom)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Sarawak General Hospital',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.techer}) : super(key: key);
  final Map<dynamic, dynamic> techer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          techerInfo(
            patients: techer['patients'],
            exp: techer['experience'],
          ),
          Config.spaceMedium,
          const Text(
            'About teacher',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            'Mr. ${techer['teacher_name']} is an experience ${techer['category']} Specialist at Sarawak, graduated since 2008, and completed his/her training at Sungai Buloh General Hospital.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class techerInfo extends StatelessWidget {
  const techerInfo({Key? key, required this.patients, required this.exp})
      : super(key: key);

  final int patients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Patients',
          value: '$patients',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(
          label: 'Rating',
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
