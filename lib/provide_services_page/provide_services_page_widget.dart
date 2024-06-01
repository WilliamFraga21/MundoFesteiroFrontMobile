import 'dart:convert';

import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'provide_services_page_model.dart';
export 'provide_services_page_model.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;
import '../hamburger/hamburger.dart';

class ProvideServicesPageWidget extends StatefulWidget {
  const ProvideServicesPageWidget({super.key});

  @override
  State<ProvideServicesPageWidget> createState() =>
      _ProvideServicesPageWidgetState();
}

class Profession {
  int id;
  String name;
  int experience;

  Profession(this.id, this.name, this.experience);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tempoexperiencia': experience,
    };
  }
}

class _ProvideServicesPageWidgetState extends State<ProvideServicesPageWidget> {
  late ProvideServicesPageModel _model;
  late String _message;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProvideServicesPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    _message = '';

    dropDownValueController2 = FormFieldController<List<String>>(null);
    _fetchProfessions();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> createPrestador() async {
    var url = Uri.parse(apiUrl + '/api/prestador/create');

    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };

    var body = json.encode({
      "promotorEvento": 1,
      "curriculo": _model.textController1.text,
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201) {
      setState(() {
        _message = 'Curriculo cadastrado com sucesso!';
        GoRouter.of(context).go('/homePage');
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
                'Erro ao criar a conta. Status code: ${response.body}'),
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

  Future<void> createProfession() async {
    var url = Uri.parse(apiUrl + '/api/prestador/createProfession');

    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final List<Map<String, dynamic>> selectedProfessionsData =
        selectedProfessions.map((profession) => profession.toJson()).toList();

    var body = json.encode({
      "valorDiaServicoProfissao": _model.textController2.text,
      "valorHoraServicoProfissao": _model.textController3.text,
      'tempoexperiencia': _model.textController4.text,
      "professions": selectedProfessionsData,
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201) {
      setState(() {
        _message = 'Profissões cadastradas com sucesso!';
        GoRouter.of(context).go('/homePage');
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
                'Erro ao cadastrar profissões. Status code: ${response.body}'),
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

  List<Profession> professions = [];
  List<Profession> selectedProfessions = [];
  late FormFieldController<List<String>> dropDownValueController2;

  Future<void> _fetchProfessions() async {
    var url = Uri.parse(apiUrl + '/profissao/getALL');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Profession> fetchedProfessions = [];
        for (var item in data) {
          for (var professionData in item) {
            final profession =
                Profession(professionData['id'], professionData['name'], 0);
            fetchedProfessions.add(profession);
          }
        }
        setState(() {
          professions = fetchedProfessions;
        });
      } else {
        print(
            'Falha ao carregar profissões. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar profissões: $e');
    }
  }

  void _updateExperience(int index, int value) {
    setState(() {
      selectedProfessions[index].experience = value;
    });
  }

  void _onMultiSelectChanged(List<String>? selectedNames) {
    if (selectedNames == null) return;
    setState(() {
      selectedProfessions = selectedNames.map((name) {
        return professions.firstWhere((profession) => profession.name == name);
      }).toList();
    });
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
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      23.0, 16.0, 0.0, 0.0),
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
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(1.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
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
                              'https://picsum.photos/seed/760/600',
                              fit: BoxFit.contain,
                            ),
                            allowRotation: false,
                            tag: 'circleImageTag1',
                            useHeroAnimation: true,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'circleImageTag1',
                      transitionOnUserGestures: true,
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/760/600',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
              child: TextFormField(
                controller: _model.textController1,
                focusNode: _model.textFieldFocusNode1,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Escreva um texto resumindo  sua carreira.',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: const Color(0xFF05BD7B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        letterSpacing: 0.0,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: Colors.black,
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                    ),
                validator: _model.textController1Validator.asValidator(context),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FlutterFlowDropDown<String>(
                multiSelectController: _model.dropDownValueController2 ??=
                    FormFieldController<List<String>>(null),
                options:
                    professions.map((profession) => profession.name).toList(),
                optionLabels:
                    professions.map((profession) => profession.name).toList(),
                width: 373.0,
                height: 56.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: const Color(0xFF05BD7B),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                hintText: 'Selecionar Serviços',
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF05BD7B),
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).alternate,
                elevation: 2.0,
                borderColor: const Color(0xFF05BD7B),
                borderWidth: 2.0,
                borderRadius: 8.0,
                margin:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                hidesUnderline: true,
                isOverButton: true,
                isSearchable: false,
                isMultiSelect: true,
                onMultiSelectChanged: _onMultiSelectChanged,
                labelText: '',
                labelTextStyle:
                    FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.black,
                          letterSpacing: 0.0,
                        ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Profissões Selecionadas:'),
            Column(
              children: selectedProfessions.map((Profession profession) {
                int index = selectedProfessions.indexOf(profession);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        width: 395.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xFF05BD7B),
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(width: 20),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedProfessions.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            // const SizedBox(width: 10),
                            Text(
                              profession.name,
                              style: const TextStyle(color: Color(0xFF05BD7B)),
                            ),
                            const SizedBox(width: 10),
                            const Text('Experiência:'),
                            // const SizedBox(width: 10),
                            _buildIconButton(Icons.remove, () {
                              if (profession.experience > 0) {
                                _updateExperience(
                                    index, profession.experience - 1);
                              }
                            }),
                            Text('${profession.experience}'),
                            _buildIconButton(Icons.add, () {
                              _updateExperience(
                                  index, profession.experience + 1);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 0.0, 8.0, 0.0),
                    child: TextFormField(
                      controller: _model.textController2,
                      focusNode: _model.textFieldFocusNode2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText:
                            'Valor da Diaria. Coloque somente os números, sem acentos ou pontos',
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF05BD7B),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF05BD7B),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.black,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                      validator:
                          _model.textController2Validator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 0.0, 8.0, 0.0),
                    child: TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText:
                            'Valor da Hora. Coloque somente os números, sem acentos ou pontos',
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF05BD7B),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF05BD7B),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.black,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                      validator:
                          _model.textController3Validator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      95.0, 16.0, 0.0, 16.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await createPrestador();
                      await createProfession();
                    },
                    text: 'Cadastrar',
                    options: FFButtonOptions(
                      width: 200.0,
                      height: 40.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color(0xFF05BD7B),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      elevation: 3.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: const Color(0xFF05BD7B),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.white,
        ),
      ),
    );
  }
}
