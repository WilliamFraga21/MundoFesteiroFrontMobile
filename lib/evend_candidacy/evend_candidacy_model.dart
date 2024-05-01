import '/flutter_flow/flutter_flow_util.dart';
import 'evend_candidacy_widget.dart' show EvendCandidacyWidget;
import 'package:flutter/material.dart';

class EvendCandidacyModel extends FlutterFlowModel<EvendCandidacyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
