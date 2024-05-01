import '/flutter_flow/flutter_flow_util.dart';
import 'search_event_page_widget.dart' show SearchEventPageWidget;
import 'package:flutter/material.dart';

class SearchEventPageModel extends FlutterFlowModel<SearchEventPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
