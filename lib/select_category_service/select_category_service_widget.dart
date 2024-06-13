import 'package:mundo_festeiro_mobile_app/profissionals_page/profissionals_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/search_event_page/search_event_page_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'select_category_service_model.dart';
export 'select_category_service_model.dart';
import '../hamburger/hamburger.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectCategoryServiceWidget extends StatefulWidget {
  const SelectCategoryServiceWidget({super.key});

  @override
  State<SelectCategoryServiceWidget> createState() =>
      _SelectCategoryServiceWidgetState();
}

class Profession {
  final int idProfessionEvento;
  final String name;
  final String iconURL;
  final int quantidade;

  Profession({
    required this.idProfessionEvento,
    required this.name,
    required this.iconURL,
    required this.quantidade,
  });

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      idProfessionEvento: json['idProfessionEvento'] ?? 0,
      name: json['name'] ?? 'Unknown', // Valor padrão se name for null
      iconURL: json['iconURL'] ?? '', // Valor padrão se iconURL for null
      quantidade: json['quantidade'] ?? '',
    );
  }
}

class _SelectCategoryServiceWidgetState
    extends State<SelectCategoryServiceWidget> {
  late SelectCategoryServiceModel _model;

  late Future<List<Profession>> futureProfessions;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureProfessions = fetchProfessions();
    _model = createModel(context, () => SelectCategoryServiceModel());
  }

  Future<List<Profession>> fetchProfessions() async {
    var url = Uri.parse(apiUrl + '/profissao/getALLEventos');

    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> professionsJson = jsonResponse['professions'];
      return professionsJson.map((json) => Profession.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar profissões');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onProfileTap() {
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
            child: FutureBuilder<List<Profession>>(
              future: futureProfessions,
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
                      final profession = snapshot.data![index];
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            verServicos(profession);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Color(0x20000000),
                                  offset: Offset(0.0, 1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF05BD7B),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 12, 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      profession.iconURL,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                            Icons.error); // ícone de erro
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 0, 0, 0),
                                          child: Text(
                                            profession.name,
                                            style: TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Colors.black,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 4, 0, 0),
                                          child: Text(
                                            'Número de vagas: ${profession.quantidade}', // Substitua por número real de prestadores
                                            style: TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF05BD7B),
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Align(
                                      alignment: AlignmentDirectional(1, 0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFFB9BEC1),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
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
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void verServicos(Profession profession) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchEventPageWidget(data: profession),
      ),
    );
  }
}
