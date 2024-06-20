import 'package:mundo_festeiro_mobile_app/datas/prestadorModel.dart';
import '../configuration_edits/configuration_edits_widget.dart';

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
import 'edit_curriculum_model.dart';
export 'edit_curriculum_model.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;
import '../hamburger/hamburger.dart';
import '../Helper/helper.dart';
import 'dart:convert';

// ignore: must_be_immutable
class EditCurriculumWidget extends StatefulWidget {
  PrestadorModel data;

  EditCurriculumWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<EditCurriculumWidget> createState() => _EditCurriculumWidgetState();
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
  int id;
  String name;
  String iconURL;
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

class _EditCurriculumWidgetState extends State<EditCurriculumWidget> {
  late EditCurriculumModel _model;
  List<Profession> selectedProfessions = [];
  late String _message;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditCurriculumModel());

    _model.textController ??=
        TextEditingController(text: widget.data.prestador.curriculo);
    _model.textFieldFocusNode ??= FocusNode();
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
    _fetchProfessions();
    // dropDownValueController2 = FormFieldController<List<String>>(null);
    // _fetchProfessionsUser();
    // print(widget.data.profession?.length);
    // print('tttttttttttttttttttttttttttttt');
    // Certifique-se de que professions e widget.data.profession não sejam nulos antes de acessar seus elementos
    if (professions == null || widget.data.profession == null) {
      print(
          'Erro ao carregar profissões: professions ou widget.data.profession são nulos');
      return;
    }

    var professionsdata = widget.data.profession?.length ?? 0;

    for (var i = 0; i < professionsdata; i++) {
      var icon = '';

      // Verifica se professions não está vazia e busca o ícone correspondente
      if (professions.isNotEmpty) {
        for (var j = 0; j < professions.length; j++) {
          if (widget.data.profession![i].id == professions[j].id) {
            icon = professions[j].iconURL;
            break; // Encerra o loop interno assim que encontramos o ícone correspondente
          }
        }
      }

      // Adiciona um novo SelectedProfession à lista
      selectedProfessions.add(Profession(
        widget.data.profession![i].id,
        widget.data.profession![i].profissao,
        icon,
        valorDia: widget.data.profession![i].valorDiaServicoProfissao,
        valorHora: widget.data.profession![i].valorHoraServicoProfissao,
        experiencia: widget.data.profession![i].tempoExperiencia,
      ));

      print(selectedProfessions[i].name);
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    }

// Agora você pode usar selectedProfessions como necessário
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> editarCurriculo() async {
    var url = Uri.parse(apiUrl + '/api/prestador/update');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var body = json.encode({
      "promotorEvento": 1,
      "curriculo": _model.textController.text,
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201) {
      setState(() {
        _message = 'Evento criado com sucesso!';
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
                : 'Erro ao Editar curriculo. Status code: ${response.statusCode}'),
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

  Future<void> professionsCad(List<Profession> professions) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    var tokenSQL = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/prestador/updateProfession');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $tokenSQL",
    };

    final List<Map<String, dynamic>> selectedProfessionsData =
        selectedProfessions.map((profession) => profession.toJson()).toList();

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
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfigurationEditsWidget(),
            ),
          );
        });
      } else {
        print('Falha ao enviar dados. Código de status: ${response.body}');
      }
    } catch (e) {
      print('Erro ao enviar dados: ${e}');
    }
  }

  List<Profession> professions = [];
  // List<Profession> selectedProfessions = [];
  // late FormFieldController<List<String>> dropDownValueController2;
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
                  : 'Erro ao fazer login. Status code: ${response.statusCode}'),
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
    } catch (e) {
      print('Erro ao carregar profissões: $e');
    }
  }

  // void _updateValorDia(int index, int value) {
  //   setState(() {
  //     selectedProfessions[index].valorDiaServicoProfissao = value;
  //   });
  // }

  // void _updateValorHora(int index, int value) {
  //   setState(() {
  //     selectedProfessions[index].valorHoraServicoProfissao = value;
  //   });
  // }

  // void _updateExperience(int index, int value) {
  //   setState(() {
  //     selectedProfessions[index].tempoExperiencia = value;
  //   });
  // }

  // void _onMultiSelectChanged(List<String>? selectedNames) {
  //   if (selectedNames == null) return;
  //   setState(() {
  //     print(selectedNames);
  //     selectedProfessions = selectedNames.map((name) {
  //       return professions.firstWhere((profession) => profession.name == name);
  //     }).toList();
  //   });
  // }

  // Future<void> _fetchProfessionsUser() async {
  //   var url = Uri.parse(apiUrl + '/profissao/getALL2');
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       final List<Profession> fetchedProfessions = [];

  //       if (data.containsKey('prestador')) {
  //         final List<dynamic> prestadores = data['prestador'];
  //         for (var prestadorData in prestadores) {
  //           final List<dynamic> prestadorProfessions =
  //               prestadorData['prestadorprofessions'];
  //           for (var professionData in prestadorProfessions) {
  //             final profession = Profession(
  //               professionData['id'],
  //               professionData['profissao'],
  //               '', // Seu endpoint não fornece uma URL de ícone, então deixamos vazio
  //               valorDia:
  //                   professionData['valorDiaServicoProfissao']?.toDouble() ??
  //                       0.0,
  //               valorHora:
  //                   professionData['valorHoraServicoProfissao']?.toDouble() ??
  //                       0.0,
  //               experiencia: professionData['tempoexperiencia'] ?? 0,
  //             );
  //             fetchedProfessions.add(profession);
  //           }
  //         }

  //         setState(() {
  //           professions = fetchedProfessions;
  //         });
  //       }
  //     } else {
  //       print(
  //         'Falha ao carregar profissões. Código de status: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Erro ao carregar profissões: $e');
  //   }
  // }

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
          title: Image.network(
            'https://media.canva.com/v2/image-resize/format:PNG/height:352/quality:100/uri:s3%3A%2F%2Fmedia-private.canva.com%2FvV_9Y%2FMAGIsDvV_9Y%2F1%2Fp.png/watermark:F/width:548?csig=AAAAAAAAAAAAAAAAAAAAAB7HIj0Zqe08fwl-4Wc73k15xXTVYta-i3G8Kcqfc_dN&exp=1718916484&osig=AAAAAAAAAAAAAAAAAAAAAFhQof94P7h-FOvazjHveb-AkmxHsc8OyR2uVlMU2loF&signer=media-rpc&x-canva-quality=thumbnail_large',
            height: 40.0, // Ajuste a altura conforme necessário
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      23.0, 16.0, 0.0, 0.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SwitchListTile.adaptive(
                          value: _model.switchListTileValue ??= false,
                          onChanged: (newValue) async {
                            setState(
                                () => _model.switchListTileValue = newValue);
                          },
                          title: Text(
                            selectedProfessions[0].name,
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          activeTrackColor: const Color(0xFF05BD7B),
                          dense: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 16.0, 8.0, 0.0),
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: true,
                      textCapitalization: TextCapitalization.none,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Currículo',
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
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 16.0, 8.0, 0.0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 12.0, 8.0, 12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                'https://picsum.photos/seed/294/600',
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.15,
                                                height: 56.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                profession.name,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          letterSpacing: 0.0,
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
                                            Icon(
                                              Icons.settings_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Experiencia',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Container(
                                          width: 160,
                                          height: 50,
                                          child: TextFormField(
                                            initialValue: profession.experiencia
                                                .toString(),
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
                                                letterSpacing: 0.0,
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Valor da diaria',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
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
                                  ].divide(const SizedBox(height: 10.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 19.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {},
                          text: 'Cancelar',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0xFFFF1418),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                        FFButtonWidget(
                          onPressed: () async {
                            editarCurriculo();
                          },
                          text: 'Salvar',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0xFF0BD83E),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
