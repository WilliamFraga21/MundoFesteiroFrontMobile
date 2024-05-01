import '/flutter_flow/flutter_flow_util.dart';
import 'select_edit_event_widget.dart' show SelectEditEventWidget;
import 'package:flutter/material.dart';

class SelectEditEventModel extends FlutterFlowModel<SelectEditEventWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
