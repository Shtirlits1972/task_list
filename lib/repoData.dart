import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:task_list/ItemTask.dart';

class RepoData with ChangeNotifier, DiagnosticableTreeMixin {
  // Provider.of<RepoData>(context, listen: false);
  bool _visible = false;
  List<ItemTask> _list = [];

  bool get getVisible => _visible;
  List<ItemTask> get getTaskList => _list;

  void setVisible(bool _visible1) {
    _visible = _visible1;
    notifyListeners();
  }

  void setTasksList(List<ItemTask> _list1) {
    _list = _list1;
    notifyListeners();
  }

  void addTask(ItemTask itemTask) {
    _list.add(itemTask);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        '_visible', _visible.toString()) /*IntProperty('count', count)*/);
  }
}
