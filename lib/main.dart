import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:task_list/CenterListWidget.dart';
import 'package:task_list/repoData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepoData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('задачи'),
        ),
        body: const CenterListWidget(),
      ),
    );
  }
}
