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
import '../Helper/helper.dart';

class ProvideServicesPageWidget extends StatefulWidget {
  const ProvideServicesPageWidget({super.key});

  @override
  State<ProvideServicesPageWidget> createState() =>
      _ProvideServicesPageWidgetState();
}

class SelectedProfession {
  final int id;
  final String name;
  final String iconURL;
  final double valorDia;
  final double valorHora;
  final int experiencia;

  SelectedProfession({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.valorDia,
    required this.valorHora,
    required this.experiencia,
  });
}

class Profession {
  final int id;
  final String name;
  final String iconURL;
  double valorDia;
  double valorHora;
  int experiencia;

  Profession(
    this.id,
    this.name,
    this.iconURL, {
    this.valorDia = 00.00, // Valor padrão para valorDia
    this.valorHora = 00.00, // Valor padrão para valorHora
    this.experiencia = 0, // Valor padrão para experiencia
  });

  @override
  String toString() {
    return 'Profession{id: $id, name: $name, iconURL: $iconURL, valorDia: $valorDia, valorHora: $valorHora, experiencia: $experiencia}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconURL': iconURL,
    };
  }
}

class _ProvideServicesPageWidgetState extends State<ProvideServicesPageWidget> {
  late ProvideServicesPageModel _model;
  late String _message;
  List<Profession> selectedProfessions = [];

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
    DatabaseHelper dbHelper = DatabaseHelper();
    var tokenSQL = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/prestador/create');

    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $tokenSQL",
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
      final List<dynamic> errorMessages = responseData['error']['message'];

      // Concatenar as mensagens de erro em uma única string
      final errorMessage = errorMessages.join('\n');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(errorMessage.isNotEmpty
                ? errorMessage
                : 'Erro ao Cadastrar curriculo. Status code: ${response.statusCode}'),
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

  Future<void> createProfessions(List<Profession> professions) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    var tokenSQL = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/prestador/createProfession');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $tokenSQL",
    };

    var body = json.encode({
      'profession': professions.map((profession) {
        return {
          'prestador_id': 1, // Altere conforme necessário
          'profissao_id': profession.id,
          'valorDiaServicoProfissao': profession.valorDia,
          'valorHoraServicoProfissao': profession.valorHora,
          'tempoexperiencia': profession.experiencia,
        };
      }).toList(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
      } else {
        print('Falha ao enviar dados. Código de status: ${response.body}');
      }
    } catch (e) {
      print('Erro ao enviar dados: ${e}');
    }
  }

  List<Profession> professions = [];
  // List<Profession> selectedProfessions = [];
  late FormFieldController<List<String>> dropDownValueController2;
  Future<void> _fetchProfessions() async {
    var url = Uri.parse(apiUrl + '/profissao/getALL');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Profession> fetchedProfessions = [];
        // final List<Profession> fetchedProfessions =
        //     data.map<Profession>((json) => Profession.fromJson(json)).toList();

        for (var item in data) {
          for (var professionData in item) {
            final profession = Profession(professionData['id'],
                professionData['name'], professionData['iconURL']);
            fetchedProfessions.add(profession);
          }
        }
        setState(() {
          professions = fetchedProfessions;
        });
        // print(professions);
        // print("professionsssssssssssssssssssssssssssssssssssssssssss");
      } else {
        print(
            'Falha ao carregar profissões. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar profissões: $e');
    }
  }

  void _onProfileTap() {
    // Lógica para quando o perfil for clicado
    Navigator.pushNamed(context, 'PerfilPage', arguments: {
      'transition': PageTransitionType.fade,
    });
  }

  // Função para lidar com a seleção de uma profissão
  // void _onProfessionSelected(Profession profession) {
  //   setState(() {
  //     // Crie uma instância de SelectedProfession com os dados da profissão selecionada
  //     SelectedProfession selectedProfession = SelectedProfession(
  //       id: profession.id,
  //       name: profession.name,
  //       iconURL: profession.iconURL,
  //       valorDia: 0.0, // Valor inicial, você pode definir como desejar
  //       valorHora: 0.0, // Valor inicial, você pode definir como desejar
  //       experiencia: 0, // Valor inicial, você pode definir como desejar
  //     );

  //     // Adicione a SelectedProfession à lista de profissões selecionadas
  //     selectedProfessions.add(selectedProfession);
  //   });
  // }

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
          body: ListView(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(23, 16, 0, 0),
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
                              size: 24,
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
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Curriculo',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF05BD7B),
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF05BD7B),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
                            child: DropdownButtonFormField<Profession>(
                              items: professions.map((profession) {
                                return DropdownMenuItem<Profession>(
                                  value: profession,
                                  child: Text(profession.name),
                                );
                              }).toList(),
                              onChanged: (Profession? value) {
                                setState(() {
                                  if (value != null &&
                                      !selectedProfessions.contains(value)) {
                                    selectedProfessions.add(value);
                                    print(selectedProfessions);
                                    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Selecionar profissões',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var profession in selectedProfessions)
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            profession
                                                .iconURL, // Substitua pela URL real da imagem
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: 56,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 0, 0),
                                          child: Text(
                                            profession.name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  color: Color(0xFF05BD7B),
                                                  fontFamily: 'Outfit',
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              // Função para deletar a profissão selecionada
                                              setState(() {
                                                selectedProfessions
                                                    .remove(profession);
                                              });
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Campo de Experiência
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Experiência',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0,
                                          ),
                                    ),
                                    Container(
                                      width: 160,
                                      height: 50,
                                      child: TextFormField(
                                        initialValue:
                                            profession.experiencia.toString(),
                                        onChanged: (value) {
                                          // Atualize o valor da experiência quando o usuário digitar
                                          profession.experiencia =
                                              int.tryParse(value) ?? 0;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Experiência',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                // Campo de Valor da Hora
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valor da hora',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0,
                                          ),
                                    ),
                                    Container(
                                      width: 160,
                                      height: 50,
                                      child: TextFormField(
                                        initialValue:
                                            profession.valorHora.toString(),
                                        onChanged: (value) {
                                          // Atualize o valor da hora quando o usuário digitar
                                          profession.valorHora =
                                              double.tryParse(value) ?? 0.0;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Valor da hora',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                // Campo de Valor da Diária
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valor da diária',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0,
                                          ),
                                    ),
                                    Container(
                                      width: 160,
                                      height: 50,
                                      child: TextFormField(
                                        initialValue:
                                            profession.valorDia.toString(),
                                        onChanged: (value) {
                                          // Atualize o valor da diária quando o usuário digitar
                                          profession.valorDia =
                                              double.tryParse(value) ?? 0.0;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Valor da diária',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(95, 16, 0, 16),
                    child: FFButtonWidget(
                      onPressed: () async {
                        createPrestador();
                        createProfessions(selectedProfessions);
                      },
                      text: 'Cadastrar',
                      options: FFButtonOptions(
                        width: 200,
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFF05BD7B),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
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
