import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String country = '';

  @override
  void initState() {
    _initFirebase();

    super.initState();
  }

  void _initFirebase({ country }) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    if (country != null) {
      await analytics.setUserProperty(name: 'app_country', value: country);
    }
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    // Option 1: Force a new fetch
    // Works on both Android and iOS
    await remoteConfig.fetch(expiration: Duration.zero);

    // Option 2: Fetch only if older than the default cache duration (12 hours)
    // Works only on iOS
    //await remoteConfig.fetch();

    await remoteConfig.activateFetched();
    this.setState(() {
      this.country = remoteConfig.getString('country');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Country from Remote Config:',
            ),
            Text(
              country,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: () => _initFirebase(country: 'japan'),
          child: Text('Switch to Japan')
        ),
        FlatButton(
          onPressed: () => _initFirebase(country: 'australia'),
          child: Text('Switch to Australia')
        )
      ],
    );
  }
}
