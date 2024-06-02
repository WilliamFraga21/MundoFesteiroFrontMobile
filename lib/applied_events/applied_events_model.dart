import '/flutter_flow/flutter_flow_util.dart';
import 'applied_events_widget.dart' show AppliedEventsWidget;
import 'package:flutter/material.dart';

class AppliedEventsModel extends FlutterFlowModel<AppliedEventsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
