import '/flutter_flow/flutter_flow_util.dart';
import 'event_hiring_widget.dart' show EventHiringWidget;
import 'package:flutter/material.dart';

class EventHiringModel extends FlutterFlowModel<EventHiringWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
