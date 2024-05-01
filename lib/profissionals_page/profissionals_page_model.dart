import '/flutter_flow/flutter_flow_util.dart';
import 'profissionals_page_widget.dart' show ProfissionalsPageWidget;
import 'package:flutter/material.dart';

class ProfissionalsPageModel extends FlutterFlowModel<ProfissionalsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
