import 'package:mundo_festeiro_mobile_app/constants/constants.dart';
import 'package:mundo_festeiro_mobile_app/edit_curriculum/edit_curriculum_widget.dart';
import 'package:mundo_festeiro_mobile_app/edit_user/edit_user_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'configuration_edits_model.dart';
export 'configuration_edits_model.dart';
import '../hamburger/hamburger.dart';
import '../datas/userModel.dart';
import '../Helper/helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../datas/prestadorModel.dart';

class ConfigurationEditsWidget extends StatefulWidget {
  const ConfigurationEditsWidget({Key? key});

  @override
  State<ConfigurationEditsWidget> createState() =>
      _ConfigurationEditsWidgetState();
}

class _ConfigurationEditsWidgetState extends State<ConfigurationEditsWidget> {
  late ConfigurationEditsModel _model;
  Future<List<UserModel>> futureUsers = Future.value([]);
  Future<List<PrestadorModel>> futurePrestadores = Future.value([]);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfigurationEditsModel());
    futureUsers = fetchUser();
    futurePrestadores = fetchPrestador(); // Inicializa futurePrestadores aqui
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<UserModel>> fetchUser() async {
    var url = Uri.parse(apiUrl + '/api/user/me');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['userinfos'] != null) {
        List jsonResponse = json.decode(response.body)['userinfos'];

        return jsonResponse.map((user) => UserModel.fromJson(user)).toList();
      } else {
        print(response.body);
        return []; // Retorna uma lista vazia se a solicitação falhar;
      }
    } else {
      print(response.body);
      return []; // Retorna uma lista vazia se a solicitação falhar
    }
  }

  Future<List<PrestadorModel>> fetchPrestador() async {
    var url = Uri.parse(apiUrl + '/api/prestador/me');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['prestador'] != null) {
        List jsonResponse = json.decode(response.body)['prestador'];

        return jsonResponse
            .map((prestador) => PrestadorModel.fromJson(prestador))
            .toList();
      } else {
        print(response.body);
        return []; // Retorna uma lista vazia se a solicitação falhar;
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            context.pushNamed(
              'CreateEventPage',
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            );
          },
          backgroundColor: Color(0xFF018959),
          elevation: 8,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).alternate,
            size: 24,
          ),
        ),
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
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([futureUsers, futurePrestadores]),
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
                final List<UserModel> users = snapshot.data![0];
                final List<PrestadorModel> prestadores = snapshot.data![1];

                return ListView.builder(
                  itemCount: users.length + prestadores.length,
                  itemBuilder: (context, index) {
                    if (index < users.length) {
                      final userModel = users[index];
                      return _buildUserTile(userModel);
                    } else {
                      final prestadorModel = prestadores[index - users.length];
                      return _buildPrestadorTile(prestadorModel);
                    }
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
    );
  }

  Widget _buildUserTile(UserModel userModel) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          editUser(userModel);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x20000000),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: const Color(0xFF05BD7B),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 12.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Editar informacoes de usuario',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Outfit',
                          color: Colors.black,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                const Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFB9BEC1),
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrestadorTile(PrestadorModel prestadorModel) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          // Inicializar a lista vazia de Professions
          editPrestador(prestadorModel);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x20000000),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: const Color(0xFF05BD7B),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 12.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Editar Curriculo',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Outfit',
                          color: Colors.black,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                const Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFB9BEC1),
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editUser(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserWidget(data: userModel),
      ),
    );
  }

  void editPrestador(PrestadorModel prestadorModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCurriculumWidget(data: prestadorModel),
      ),
    );
  }
}
