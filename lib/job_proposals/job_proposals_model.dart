import '/flutter_flow/flutter_flow_util.dart';
import 'job_proposals_widget.dart' show JobProposalsWidget;
import 'package:flutter/material.dart';

class JobProposalsModel extends FlutterFlowModel<JobProposalsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
