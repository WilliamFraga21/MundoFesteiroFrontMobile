import 'package:mundo_festeiro_mobile_app/constants/constants.dart';
import 'package:mundo_festeiro_mobile_app/perfil_contractor_page/perfil_contractor_page_widget.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../datas/eventoModel.dart';
import 'package:flutter/material.dart';
import 'profissional_events_model.dart';
export 'profissional_events_model.dart';
import '../hamburger/hamburger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Helper/helper.dart';

class ProfissionalEventsWidget extends StatefulWidget {
  EventoModel data;

  ProfissionalEventsWidget({Key? key, required this.data}) : super(key: key);
  @override
  State<ProfissionalEventsWidget> createState() =>
      _ProfissionalEventsWidgetState();
}

class Prestador {
  final int idProposta;
  final int aceitarPrestador;
  final int idPrestador;
  final int idEvento;
  final String userName;
  final String email;
  final String contactno;
  final String createdat;
  final String curriculo;

  Prestador({
    required this.idProposta,
    required this.aceitarPrestador,
    required this.idPrestador,
    required this.idEvento,
    required this.userName,
    required this.email,
    required this.contactno,
    required this.createdat,
    required this.curriculo,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      idProposta: json['id_proposta'],
      aceitarPrestador: json['aceitarPrestador'],
      idPrestador: json['prestador_id'],
      idEvento: json['evento_id'],
      userName: json['user_name'],
      email: json['email'],
      contactno: json['contactno'].toString(),
      createdat: json['created_at'],
      curriculo: json['curriculo'],
    );
  }
}

class Profession2 {
  final String nameProfession;
  final int tempoExperiencia;
  final double valorDiaServicoProfissao;
  final double valorHoraServicoProfissao;

  Profession2({
    required this.nameProfession,
    required this.tempoExperiencia,
    required this.valorDiaServicoProfissao,
    required this.valorHoraServicoProfissao,
  });

  factory Profession2.fromJson(Map<String, dynamic> json) {
    return Profession2(
      nameProfession: json['profissao'],
      tempoExperiencia: json['tempoexperiencia'],
      valorDiaServicoProfissao: json['valorDiaServicoProfissao'].toDouble(),
      valorHoraServicoProfissao: json['valorHoraServicoProfissao'].toDouble(),
    );
  }
}

class PrestadorModel {
  final Prestador prestador;
  final List<Profession2>? profession;
  final String? photo;

  PrestadorModel({
    required this.prestador,
    required this.profession,
    required this.photo,
  });

  factory PrestadorModel.fromJson(Map<String, dynamic> json) {
    // Extrair dados do prestador
    final prestadorInfo = json['prestadorInfo'] as Map<String, dynamic>;
    final prestador = Prestador.fromJson(prestadorInfo);

    // Extrair dados da localidade do prestador

    // Extrair dados das profissões (se disponível)
    final prestadorProfessions = json['professions'] as List<dynamic>?;

    List<Profession2>? profession;
    if (prestadorProfessions != null) {
      profession = prestadorProfessions
          .map((professionJson) => Profession2.fromJson(professionJson))
          .toList();
    }

    // Extrair dados da foto (se disponível)
    final photo = json['photo'] as String?;

    return PrestadorModel(
      prestador: prestador,
      profession: profession,
      photo: photo,
    );
  }
}

class _ProfissionalEventsWidgetState extends State<ProfissionalEventsWidget> {
  late ProfissionalEventsModel _model;
  late String _message;
  bool isPropostaAceita = false;
  late Future<List<PrestadorModel>> futurePrestadores;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    late Future<PrestadorModel> futurePrestadores;
    _model = createModel(context, () => ProfissionalEventsModel());
    fetchPrestados();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _message = "";
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> aceitaProposta() async {
    var url = Uri.parse(apiUrl + '/api/evento/aceitarproposta/3');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    // Definir o valor de aceitarPrestador com base na ação do usuário
    int aceitarPrestador = 0; // Valor padrão é 0 (não aceito)
    if (_model.textController.text == 'Aceitar Proposta') {
      aceitarPrestador =
          1; // Se o texto do botão for 'Aceitar Proposta', então aceitar
    }

    var body = json.encode({
      "aceitarPrestador": aceitarPrestador,
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // fetchPrestados();
      setState(() {
        _message = 'Proposta aceita!';
        isPropostaAceita = true; // Altera a visibilidade dos botões
      });
    } else {
      // Exibir aviso com mensagem da API
      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(errorMessage ??
                'Erro ao aceitar proposta. Status code: ${response.body}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<PrestadorModel>> fetchPrestados() async {
    var url = Uri.parse(apiUrl + '/api/evento/getprestadores/1');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['prestadores'] != null) {
        List<dynamic> prestadoresData = jsonResponse['prestadores'];
        List<PrestadorModel> prestadores = prestadoresData
            .map((prestadorJson) => PrestadorModel.fromJson(prestadorJson))
            .toList();
        return prestadores;
      } else {
        throw Exception(response.body);
      }
    } else {
      throw Exception(response.body);
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
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 20.0, 0.0, 4.0),
                      child: Text(
                        'Evento',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: const Color(0xFF05BD7B),
                              fontSize: 25.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 20.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/seed/614/600',
                      width: 300.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      25.0, 0.0, 0.0, 10.0),
                  child: Text(
                    'Profissionais',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.black,
                          fontSize: 25.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                FutureBuilder<List<PrestadorModel>>(
                  future: fetchPrestados(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else {
                      final prestadores = snapshot.data!;

                      return Column(
                        children: prestadores.map((prestadorModel) {
                          final prestador = prestadorModel.prestador;

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
                                        context.pushNamed(
                                            'PerfilProfissionalPage');
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          // widget.data.photo ??
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
                                              prestador.userName,
                                              style: FlutterFlowTheme.of(
                                                      context)
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
                                                .fromSTEB(16.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              '21 anos',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
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
                                              'São Paulo - SP',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                .fromSTEB(16.0, 0.0, 0.0, 4.0),
                                            child: Text(
                                              'Garçom',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color: Colors.black,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 16.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  context.pushNamed(
                                                    'PerfilProfissionalPage',
                                                    extra: <String, dynamic>{
                                                      kTransitionInfoKey:
                                                          const TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                        duration: Duration(
                                                            milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                },
                                                text: 'Perfil completo',
                                                options: FFButtonOptions(
                                                  width: 237.0,
                                                  height: 35.0,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  color:
                                                      const Color(0xFF05BD7B),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation: 3.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                prestador.aceitarPrestador == 0,
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 16.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await aceitaProposta();
                                                  },
                                                  text: 'Aceitar Proposta',
                                                  options: FFButtonOptions(
                                                    width: 237.0,
                                                    height: 35.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color:
                                                        const Color(0xFF05BD7B),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    elevation: 3.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                prestador.aceitarPrestador == 1,
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 16.0),
                                                child: FFButtonWidget(
                                                  onPressed: () {
                                                    verCandidaturas(
                                                        prestadorModel);
                                                  },
                                                  text: 'Contato do Prestador',
                                                  options: FFButtonOptions(
                                                    width: 237.0,
                                                    height: 35.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color:
                                                        const Color(0xFF05BD7B),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    elevation: 3.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                  ),
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
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verCandidaturas(PrestadorModel prestadorModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PerfilContractorPageWidget(data: prestadorModel)));
  }
}
