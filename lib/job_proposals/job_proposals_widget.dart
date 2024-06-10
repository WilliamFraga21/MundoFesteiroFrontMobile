import 'package:mundo_festeiro_mobile_app/index.dart';
import 'package:mundo_festeiro_mobile_app/perfil_contractor_page/perfil_contractor_page_widget.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'job_proposals_model.dart';
export 'job_proposals_model.dart';
import '../hamburger/hamburger.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Helper/helper.dart';
import "../datas/propostasModel.dart";
import "../datas/prestadorModel.dart";

class JobProposalsWidget extends StatefulWidget {
  const JobProposalsWidget({super.key});

  @override
  State<JobProposalsWidget> createState() => _JobProposalsWidgetState();
}

class _JobProposalsWidgetState extends State<JobProposalsWidget> {
  late JobProposalsModel _model;
  late Future<List<Proposta>> futurePropostas;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futurePropostas = fetchPropostas(); // Inicializa o futuro
    _model = createModel(context, () => JobProposalsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<PrestadorModel> fetchPrestadoByID(int id) async {
    var url = Uri.parse(apiUrl + '/prestador/id/$id');

    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['prestador'] != null) {
        // Supondo que a resposta JSON contém uma lista de prestadores
        List<dynamic> prestadorList = jsonResponse['prestador'];
        if (prestadorList.isNotEmpty) {
          return PrestadorModel.fromJson(prestadorList[0]);
        } else {
          throw Exception('Prestador não encontrado');
        }
      } else {
        print(response.body);
        throw Exception('Prestador não encontrado');
      }
    } else {
      print(response.body);
      throw Exception('Falha ao carregar prestador');
    }
  }

  Future<void> acceptProposta(int propostaID) async {
    var url =
        Uri.parse(apiUrl + '/api/prestador/contratar/aceitar/$propostaID');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.post(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Proposta aceita com sucesso
      print('Proposta aceita com sucesso');
      setState(() {
        futurePropostas = fetchPropostas(); // Recarregue a lista de propostas
      });
    } else {
      // Falha ao aceitar proposta
      print('Falha ao aceitar proposta: ${response.body}');
    }
  }

  Future<List<Proposta>> fetchPropostas() async {
    var url = Uri.parse(apiUrl + '/api/prestador/propostas');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData != null && responseData['propostas'] != null) {
        List<dynamic> propostasJson = responseData['propostas'];
        return propostasJson
            .map((proposta) => Proposta.fromJson(proposta))
            .toList();
      } else {
        return []; // Retorna uma lista vazia se 'propostas' for nulo ou se a resposta do servidor não contiver dados
      }
    } else {
      print(response.body);
      return []; // Retorna uma lista vazia se a solicitação falhar
    }
  }

  void _onProfileTap() {
    // Lógica para quando o perfil for clicado
    Navigator.pushNamed(context, 'PerfilPage', arguments: {
      'transition': PageTransitionType.fade,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          drawer: HamburgerMenu(
            onProfileTap: _onProfileTap,
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            title: Text(
              'Logo',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                  ),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: FutureBuilder<List<Proposta>>(
                future: futurePropostas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 100,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Ocorreu um erro inesperado.',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma proposta encontrada.',
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  } else {
                    List<Proposta> propostas = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: propostas.length,
                      itemBuilder: (context, index) {
                        Proposta proposta = propostas[index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 8.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 3.0,
                                  color: Color(0x20000000),
                                  offset: Offset(
                                    0.0,
                                    1.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: const Color(0xFF05BD7B),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 12.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      // context.pushNamed('PerfilContractorPage');
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: proposta.photo != null
                                          ? Image.network(
                                              proposta.photo!,
                                              width: 70.0,
                                              height: 70.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
                                              width: 70.0,
                                              height: 70.0,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            proposta.infosUserProposta.name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color:
                                                      const Color(0xFF05BD7B),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 0.0, 4.0),
                                          child: Text(
                                            proposta
                                                .infosUserProposta.dataProposta,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Colors.black,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 0.0, 4.0),
                                          child: Text(
                                            'Serviço: ${proposta.infosUserProposta.profissao}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Colors.black,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                            child: proposta.infosUserProposta
                                                        .aceitarProposta ==
                                                    0
                                                ? FFButtonWidget(
                                                    onPressed: () {
                                                      acceptProposta(proposta
                                                          .infosUserProposta
                                                          .propostaID);
                                                    },
                                                    text: 'Aceitar',
                                                    options: FFButtonOptions(
                                                      width: 237.0,
                                                      height: 35.0,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      color: const Color(
                                                          0xFF05BD7B),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                      elevation: 3.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0),
                                                    ),
                                                  )
                                                : FFButtonWidget(
                                                    onPressed: () async {
                                                      try {
                                                        PrestadorModel
                                                            prestadorModel =
                                                            await fetchPrestadoByID(
                                                                proposta
                                                                    .infosUserProposta
                                                                    .prestadorId);
                                                        verCandidaturas(
                                                            prestadorModel);
                                                      } catch (e) {
                                                        print(
                                                            'Erro ao buscar prestador: $e');
                                                        // Exibir um aviso ao usuário
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title:
                                                                  Text('Erro'),
                                                              content: Text(
                                                                  'Erro ao carregar perfil do prestador.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    text: 'Ver Perfil Completo',
                                                    options: FFButtonOptions(
                                                      width: 237.0,
                                                      height: 35.0,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      color: const Color(
                                                          0xFFCCCCCC),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                      elevation: 3.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }

  void verCandidaturas(PrestadorModel prestadorModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PerfilContractorPageWidget(data: prestadorModel)));
  }

  verPrestador(PrestadorModel prestadorModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PerfilContractorPageWidget(data: prestadorModel)));
  }
}
