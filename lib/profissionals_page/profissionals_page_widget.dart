import 'dart:ffi';

import 'package:mundo_festeiro_mobile_app/index.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'profissionals_page_model.dart';
export 'profissionals_page_model.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../hamburger/hamburger.dart';

class ProfissionalsPageWidget extends StatefulWidget {
  const ProfissionalsPageWidget({super.key});

  @override
  State<ProfissionalsPageWidget> createState() =>
      _ProfissionalsPageWidgetState();
}

class Prestador {
  final int id;
  final int usersId;
  final int promotorEvento;
  final String name;
  final String email;
  final String contactNo;
  final String shippingAddress;
  final String shippingState;
  final String shippingCity;
  final String createdAt;
  final String curriculo;
  final int localidadeId;
  final String? status;

  Prestador({
    required this.id,
    required this.usersId,
    required this.promotorEvento,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.shippingAddress,
    required this.shippingState,
    required this.shippingCity,
    required this.createdAt,
    required this.curriculo,
    required this.localidadeId,
    this.status,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'],
      usersId: json['users_id'],
      promotorEvento: json['promotorEvento'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactno'].toString(),
      shippingAddress: json['shippingAddress'],
      shippingState: json['shippingState'],
      shippingCity: json['shippingCity'],
      createdAt: json['created_at'],
      curriculo: json['curriculo'],
      localidadeId: json['localidade_id'],
      status: json['Status'],
    );
  }
}

class Profession {
  final int id;
  final String profissao;
  final int tempoExperiencia;
  final double valorDiaServicoProfissao;
  final double valorHoraServicoProfissao;

  Profession({
    required this.id,
    required this.profissao,
    required this.tempoExperiencia,
    required this.valorDiaServicoProfissao,
    required this.valorHoraServicoProfissao,
  });

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id'],
      profissao: json['profissao'],
      tempoExperiencia: json['tempoexperiencia'],
      valorDiaServicoProfissao: json['valorDiaServicoProfissao'].toDouble(),
      valorHoraServicoProfissao: json['valorHoraServicoProfissao'].toDouble(),
    );
  }
}

class LocalidadePrestador {
  final int id;
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;
  final String createdAt;
  final String updatedAt;

  LocalidadePrestador({
    required this.id,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalidadePrestador.fromJson(Map<String, dynamic> json) {
    return LocalidadePrestador(
      id: json['id'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PrestadorModel {
  final Prestador prestador;
  final List<Profession>? profession;
  final LocalidadePrestador localidadePrestador;
  final String? photo;

  PrestadorModel({
    required this.prestador,
    required this.profession,
    required this.localidadePrestador,
    required this.photo,
  });

  factory PrestadorModel.fromJson(Map<String, dynamic> json) {
    // Extrair dados do prestador
    final prestadorInfo = json['prestadorInfo'] as Map<String, dynamic>;
    final prestador = Prestador.fromJson(prestadorInfo);

    // Extrair dados da localidade do prestador
    final infoPrestadorEnd = json['infoPrestadorEnd'] as Map<String, dynamic>;
    final localidadePrestador = LocalidadePrestador.fromJson(infoPrestadorEnd);

    // Extrair dados das profissões (se disponível)
    final prestadorProfessions = json['prestadorprofessions'] as List<dynamic>?;

    List<Profession>? profession;
    if (prestadorProfessions != null) {
      profession = prestadorProfessions
          .map((professionJson) => Profession.fromJson(professionJson))
          .toList();
    }

    // Extrair dados da foto (se disponível)
    final photo = json['photo'] as String?;

    return PrestadorModel(
      prestador: prestador,
      profession: profession,
      localidadePrestador: localidadePrestador,
      photo: photo,
    );
  }
}

class _ProfissionalsPageWidgetState extends State<ProfissionalsPageWidget> {
  late ProfissionalsPageModel _model;
  late Future<List<PrestadorModel>> futurePrestadores;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futurePrestadores = fetchPrestados();
    _model = createModel(context, () => ProfissionalsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<PrestadorModel>> fetchPrestados() async {
    var url = Uri.parse(apiUrl + '/prestador/getALL/22');

    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['prestador'] != null) {
        // List<dynamic> eventsJson = jsonResponse['Evento'];
        // var la = jsonResponse['Evento'];
        List jsonResponse = json.decode(response.body)['prestador'];
        return jsonResponse
            .map((evento) => PrestadorModel.fromJson(evento))
            .toList();
        // throw Exception(la.user);
        // return eventsJson.map((event) => Event.fromJson(event)).toList();
      } else {
        throw Exception('Eventos não encontrados');
      }
    } else {
      throw Exception('Falha ao carregar eventos');
    }
  }
  // final scaffoldKey = GlobalKey<ScaffoldState>();

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
            imageUrl: 'https://picsum.photos/seed/398/600',
            name: 'Nome do Prestador',
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
            child: Column(children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 16.0, 320.0, 16.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 10.0),
                child: Text(
                  'Profissionais',
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        fontSize: 35.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<PrestadorModel>>(
                  future: futurePrestadores,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final prestador = snapshot.data![index];
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        '${prestador.photo}',
                                        width: 70.0,
                                        height: 70.0,
                                        fit: BoxFit.cover,
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
                                              prestador.prestador.name,
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
                                              '${prestador.photo}', // Use a propriedade de idade real aqui
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
                                              '${prestador.localidadePrestador.cidade} - ${prestador.localidadePrestador.estado}', // Use as propriedades de cidade e estado reais aqui
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
                                                  verPrestador(prestador);
                                                },
                                                text: 'Ver perfil completo',
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
                    } else {
                      return const Center(
                          child: Text('Nenhum prestador encontrado'));
                    }
                  },
                ),
              )
            ]),
          ),
        ));
  }

  verPrestador(PrestadorModel prestadorModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                PerfilProfissionalPageWidget(data: prestadorModel)));
  }
}
