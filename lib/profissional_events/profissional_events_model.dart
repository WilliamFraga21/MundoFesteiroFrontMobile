import '/flutter_flow/flutter_flow_util.dart';
import 'profissional_events_widget.dart' show ProfissionalEventsWidget;
import 'package:flutter/material.dart';

class ProfissionalEventsModel
    extends FlutterFlowModel<ProfissionalEventsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();

    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
