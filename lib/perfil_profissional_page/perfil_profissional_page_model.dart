import '/flutter_flow/flutter_flow_util.dart';
import 'perfil_profissional_page_widget.dart' show PerfilProfissionalPageWidget;
import 'package:flutter/material.dart';

class PerfilProfissionalPageModel
    extends FlutterFlowModel<PerfilProfissionalPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
