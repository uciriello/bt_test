
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/global_translations_provider.dart';
import 'homepage.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/setting'; 
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
  final globalTranslations = Provider.of<GlobalTranslationsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(translations.text('pageNames.settings')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(MyHomePage.routeName, (r) {
                return false;
              });
            },
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.withOpacity(.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  translations.text('pages.settings.general'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  translations.text('pages.settings.language'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton(
                    value: globalTranslations.locale.toString(),
                    items: translations.supportedLocales().map((l) {
                      return DropdownMenuItem(
                        child: Text('${l.languageCode}'),
                        value: l.languageCode,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      globalTranslations.setNewLanguage(newValue);
                    }),
              ],
            ),
          ),
          Divider(),
        ]));
  }
}
