import 'dart:ffi';

import 'package:mundo_festeiro_mobile_app/index.dart';
import '../perfil_profissional_page/perfil_profissional_page_widget.dart';
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
import '../services_page/services_page_widget.dart';
import '../datas/prestadorModel.dart';

class ProfissionalsPageWidget extends StatefulWidget {
  // const ProfissionalsPageWidget({super.key});

  Profession data;

  ProfissionalsPageWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<ProfissionalsPageWidget> createState() =>
      _ProfissionalsPageWidgetState();
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
    var url = Uri.parse(
        apiUrl + '/prestador/getALL/${widget.data.idProfessionPrestador}');
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
                      return const Center(
                        // child: Text('Erro: ${snapshot}')
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
                                        // prestador.photo ??
                                        'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
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
                                              '${prestador.prestador.id} Anos', // Use a propriedade de idade real aqui
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
                                              '${prestador.localidadePrestador.estado},${prestador.localidadePrestador.cidade},${prestador.localidadePrestador.bairro}', // Use as propriedades de cidade e estado reais aqui
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
