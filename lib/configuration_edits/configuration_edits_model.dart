import '/flutter_flow/flutter_flow_util.dart';
import 'configuration_edits_widget.dart' show ConfigurationEditsWidget;
import 'package:flutter/material.dart';

class ConfigurationEditsModel
    extends FlutterFlowModel<ConfigurationEditsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
