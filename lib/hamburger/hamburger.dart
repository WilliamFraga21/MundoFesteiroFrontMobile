import 'package:mundo_festeiro_mobile_app/applied_events/applied_events_widget.dart';
import 'package:mundo_festeiro_mobile_app/configuration_edits/configuration_edits_widget.dart';
import 'package:mundo_festeiro_mobile_app/edit_curriculum/edit_curriculum_widget.dart';
import 'package:mundo_festeiro_mobile_app/job_proposals/job_proposals_widget.dart';
import 'package:mundo_festeiro_mobile_app/perfil_page/perfil_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/provide_services_page/provide_services_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/search_event_page/search_event_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/select_category_service/select_category_service_widget.dart';
import 'package:mundo_festeiro_mobile_app/services_page/services_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/select_edit_event/select_edit_event_widget.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'dart:convert';
import '../Helper/helper.dart';
import 'package:provider/provider.dart';
import '../datas/user_provider.dart';
import '../datas/user.dart' as DataUser;

class HamburgerMenu extends StatelessWidget {
  final VoidCallback onProfileTap;
  var nameUser;
  var photoUser;
  HamburgerMenu({
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      child: Drawer(
        elevation: 16.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: FlutterFlowExpandedImageView(
                                image: Image.network(
                                  // photoUser ??
                                  'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
                                  fit: BoxFit.contain,
                                ),
                                allowRotation: false,
                                tag: 'circleImageTag',
                                useHeroAnimation: true,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'circleImageTag',
                          transitionOnUserGestures: true,
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              photoUser ??
                                  user?.photoUrl ??
                                  'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                child: Text(
                  nameUser ?? user?.name ?? 'Usuário não conectado',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Outfit',
                        color: const Color(0xFF018959),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    perfilPage(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Perfil',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    configuration(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Configuracoes',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    verPropostas(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Ver Propostas',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    verEventosAplicados(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Eventos Aplicados',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    gerenciarEvent(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Gerenciar Evento',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  searchPrestador(context);
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Procurar Prestador',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  searchEvent(context);
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Procurar Evento',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding:
            //       const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            //   child: InkWell(
            //     splashColor: Colors.transparent,
            //     focusColor: Colors.transparent,
            //     hoverColor: Colors.transparent,
            //     highlightColor: Colors.transparent,
            //     onTap: () async {
            //       context.pushNamed('SearchEmergencyProfissional');
            //     },
            //     child: Container(
            //       width: MediaQuery.sizeOf(context).width * 0.48,
            //       height: 55.0,
            //       decoration: BoxDecoration(
            //         color: FlutterFlowTheme.of(context).secondaryBackground,
            //         boxShadow: const [
            //           BoxShadow(
            //             blurRadius: 4.0,
            //             color: Color(0x33000000),
            //             offset: Offset(
            //               0.0,
            //               2.0,
            //             ),
            //             spreadRadius: 2.0,
            //           )
            //         ],
            //         borderRadius: BorderRadius.circular(6.0),
            //         border: Border.all(
            //           color: const Color(0xFF05BD7B),
            //           width: 2.0,
            //         ),
            //       ),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.max,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Flexible(
            //             child: Align(
            //               alignment: const AlignmentDirectional(0.0, 0.0),
            //               child: Padding(
            //                 padding: const EdgeInsetsDirectional.fromSTEB(
            //                     20.0, 0.0, 0.0, 0.0),
            //                 child: Text(
            //                   'Contratação de Emergência',
            //                   textAlign: TextAlign.center,
            //                   style: FlutterFlowTheme.of(context)
            //                       .bodyMedium
            //                       .override(
            //                         fontFamily: 'Outfit',
            //                         letterSpacing: 0.0,
            //                       ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           const Icon(
            //             Icons.arrow_forward_ios,
            //             color: Color(0xFFB9BEC1),
            //             size: 20.0,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    createCurriculum(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.48,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        spreadRadius: 2.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Cadastrar Curriculo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFB9BEC1),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Flexible(
            //   child: Align(
            //     alignment: const AlignmentDirectional(0.0, 1.0),
            //     child: Padding(
            //       padding:
            //           const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            //       child: InkWell(
            //         splashColor: Colors.transparent,
            //         focusColor: Colors.transparent,
            //         hoverColor: Colors.transparent,
            //         highlightColor: Colors.transparent,
            //         onTap: () async {
            //           context.pushNamed(
            //             'LoginPage',
            //             extra: <String, dynamic>{
            //               kTransitionInfoKey: const TransitionInfo(
            //                 hasTransition: true,
            //                 transitionType: PageTransitionType.fade,
            //                 duration: Duration(milliseconds: 0),
            //               ),
            //             },
            //           );
            //         },
            //         child: Container(
            //           width: MediaQuery.sizeOf(context).width * 0.48,
            //           height: 55.0,
            //           decoration: BoxDecoration(
            //             color: FlutterFlowTheme.of(context).secondaryBackground,
            //             boxShadow: const [
            //               BoxShadow(
            //                 blurRadius: 4.0,
            //                 color: Color(0x33000000),
            //                 offset: Offset(
            //                   0.0,
            //                   2.0,
            //                 ),
            //                 spreadRadius: 2.0,
            //               )
            //             ],
            //             borderRadius: BorderRadius.circular(6.0),
            //             border: Border.all(
            //               color: const Color(0xFF05BD7B),
            //               width: 2.0,
            //             ),
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               Flexible(
            //                 child: Align(
            //                   alignment: const AlignmentDirectional(0.0, 0.0),
            //                   child: Padding(
            //                     padding: const EdgeInsetsDirectional.fromSTEB(
            //                         25.0, 0.0, 0.0, 0.0),
            //                     child: Text(
            //                       'Login',
            //                       style: FlutterFlowTheme.of(context)
            //                           .bodyMedium
            //                           .override(
            //                             fontFamily: 'Outfit',
            //                             letterSpacing: 0.0,
            //                           ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const Icon(
            //                 Icons.login_outlined,
            //                 color: Color(0xFFB9BEC1),
            //                 size: 25.0,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Flexible(
              child: Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 10.0, 0.0, 30.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      final dbHelper = DatabaseHelper();
                      await dbHelper.deleteToken();
                      await dbHelper.deleteUser();
                      context.pushNamed(
                        'LoginPage',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.48,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                            spreadRadius: 2.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: const Color(0xFF05BD7B),
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    25.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Logout',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.logout_outlined,
                            color: Color(0xFFB9BEC1),
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gerenciarEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectEditEventWidget(),
      ),
    );
  }

  void configuration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigurationEditsWidget(),
      ),
    );
  }

  void verPropostas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JobProposalsWidget(),
      ),
    );
  }

  void verEventosAplicados(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AppliedEventsWidget(),
      ),
    );
  }

  void perfilPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PerfilPageWidget(),
      ),
    );
  }

  void searchPrestador(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesPageWidget(),
      ),
    );
  }

  void searchEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectCategoryServiceWidget(),
      ),
    );
  }

  void createCurriculum(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProvideServicesPageWidget(),
      ),
    );
  }
}
