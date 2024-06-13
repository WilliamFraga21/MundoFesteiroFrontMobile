import 'package:mundo_festeiro_mobile_app/profissional_events/profissional_events_widget.dart';

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
import 'edit_event_page_model.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../select_edit_event/select_edit_event_widget.dart';
import 'dart:convert';
import '../Helper/helper.dart';
import '../hamburger/hamburger.dart';
import '../datas/eventoModel.dart';

class EditEventPageWidget extends StatefulWidget {
  // const EditEventPageWidget({super.key});

  EventoModel data;

  EditEventPageWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<EditEventPageWidget> createState() => _EditEventPageWidgetState();
}

class Profession {
  int id;
  String name;
  String iconURL;
  int quantidade;

  Profession(this.id, this.name, this.iconURL, this.quantidade);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantidade': quantidade,
    };
  }
}

class _EditEventPageWidgetState extends State<EditEventPageWidget> {
  late EditEventPageModel _model;
  bool _isEditable = false;
  late String _message;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditEventPageModel());

    _model.textController1 ??=
        TextEditingController(text: '${widget.data.evento.tipoEvento}');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??=
        TextEditingController(text: '${widget.data.evento.nomeEvento}');
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??=
        TextEditingController(text: '${widget.data.evento.data}');
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??=
        TextEditingController(text: '${widget.data.evento.quantidadePessoas}');
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(
        text: '${widget.data.evento.quantidadeFuncionarios}');
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??=
        TextEditingController(text: '${widget.data.evento.statusEvento}');
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??=
        TextEditingController(text: '${widget.data.evento.descricaoEvento}');
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??=
        TextEditingController(text: '${widget.data.localidadeEvento.endereco}');
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??=
        TextEditingController(text: '${widget.data.localidadeEvento.bairro}');
    _model.textFieldFocusNode9 ??= FocusNode();

    _model.textController10 ??=
        TextEditingController(text: '${widget.data.localidadeEvento.cidade}');
    _model.textFieldFocusNode10 ??= FocusNode();

    _model.textController11 ??=
        TextEditingController(text: '${widget.data.localidadeEvento.estado}');
    _model.textFieldFocusNode11 ??= FocusNode();

    _model.textController12 ??= TextEditingController();
    _model.textFieldFocusNode12 ??= FocusNode();
    // if (widget.data.profissao != null) {
    //   List<String> professions = [];
    //   for (var i = 0; i < widget.data.profissao.length; i++) {
    //     professions.insert(i, widget.data.profissao[i].profissao);
    //   }

    //   print(professions);
    //   _onMultiSelectChanged(professions);
    // }
    // for (var professionData in widget.data.profissao) {
    //   selectedProfessions = professionData[]
    // }
    _model.textController13 ??= TextEditingController();
    _model.textFieldFocusNode13 ??= FocusNode();

    _message = "";

    dropDownValueController2 = FormFieldController<List<String>>(null);
    _fetchProfessions();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> editEvent() async {
    var url = Uri.parse(apiUrl + '/api/evento/update/${widget.data.evento.id}');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    final List<Map<String, dynamic>> selectedProfessionsData =
        selectedProfessions.map((profession) => profession.toJson()).toList();

    var body = json.encode({
      "nomeEvento": _model.textController2.text,
      "tipoEvento": _model.textController1.text,
      "data": _model.textController3.text,
      "quantidadePessoas": _model.textController4.text,
      "quantidadeFuncionarios": _model.textController5.text,
      "statusEvento": _model.textController6.text,
      "descricaoEvento": _model.textController7.text,
      "endereco": _model.textController8.text,
      "bairro": _model.textController9.text,
      "cidade": _model.textController10.text,
      "estado": _model.textController11.text,
      "professions": selectedProfessionsData
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SelectEditEventWidget()));
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
                'Erro ao editar evento. Status code: ${response.body}'),
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
    // final url = apiUrl + '/profissao/getALL'; // Substitua pelo URL correto
    var url = Uri.parse(apiUrl + '/profissao/getALL');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Profession> fetchedProfessions = [];
        for (var item in data) {
          for (var professionData in item) {
            final profession = Profession(professionData['id'],
                professionData['name'], professionData['iconURL'], 0);
            fetchedProfessions.add(profession);
          }
        }
        setState(() {
          professions = fetchedProfessions;
        });

        if (widget.data.profissao != null) {
          List<String> professions = [];
          for (var i = 0; i < widget.data.profissao.length; i++) {
            professions.insert(i, widget.data.profissao[i].profissao);
          }

          print(professions);
          _onMultiSelectChanged(professions);

          for (var i = 0; i < widget.data.profissao.length; i++) {
            _updateExperience(i, widget.data.profissao[i].quantidade);
          }
        }
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
      selectedProfessions[index].quantidade = value;
    });
  }

  void _onMultiSelectChanged(List<String>? selectedNames) {
    if (selectedNames == null) return;
    setState(() {
      print(selectedNames);
      selectedProfessions = selectedNames.map((name) {
        return professions.firstWhere((profession) => profession.name == name);
      }).toList();
    });
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
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 0.0, 0.0),
                    child: Text(
                      'Detalhes do evento',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SwitchListTile.adaptive(
                      value: _isEditable,
                      onChanged: (newValue) {
                        setState(() {
                          _isEditable = newValue;
                        });
                      },
                      title: Text(
                        'Editar informações',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
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
              // Stack(
              //   children: [
              //     Align(
              //       alignment: const AlignmentDirectional(0.0, 0.0),
              //       child: Container(
              //         width: 390.0,
              //         decoration: const BoxDecoration(),
              //         child: Padding(
              //           padding: const EdgeInsetsDirectional.fromSTEB(
              //               8.0, 16.0, 8.0, 0.0),
              //           child: TextFormField(
              //             controller: _model.textController1,
              //             focusNode: _model.textFieldFocusNode1,
              //             autofocus: true,
              //             obscureText: false,
              //             decoration: InputDecoration(
              //               labelText: 'Adicionar foto',
              //               labelStyle: FlutterFlowTheme.of(context)
              //                   .labelMedium
              //                   .override(
              //                     fontFamily: 'Outfit',
              //                     color: const Color(0xFF05BD7B),
              //                     fontSize: 16.0,
              //                     letterSpacing: 0.0,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //               hintStyle: FlutterFlowTheme.of(context)
              //                   .labelMedium
              //                   .override(
              //                     fontFamily: 'Outfit',
              //                     letterSpacing: 0.0,
              //                   ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide: const BorderSide(
              //                   color: Color(0xFF05BD7B),
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: FlutterFlowTheme.of(context).primary,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //               errorBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: FlutterFlowTheme.of(context).error,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //               focusedErrorBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: FlutterFlowTheme.of(context).error,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //             ),
              //             style:
              //                 FlutterFlowTheme.of(context).bodyMedium.override(
              //                       fontFamily: 'Outfit',
              //
              //                       fontSize: 15.0,
              //                       letterSpacing: 0.0,
              //                       fontWeight: FontWeight.normal,
              //                     ),
              //             validator: _model.textController1Validator
              //                 .asValidator(context),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Align(
              //       alignment: const AlignmentDirectional(0.9, -0.85),
              //       child: Padding(
              //         padding: const EdgeInsetsDirectional.fromSTEB(
              //             0.0, 20.0, 0.0, 0.0),
              //         child: FFButtonWidget(
              //           onPressed: () async {
              //             final selectedMedia = await selectMedia(
              //               maxWidth: 300.00,
              //               maxHeight: 200.00,
              //               includeBlurHash: true,
              //               mediaSource: MediaSource.photoGallery,
              //               multiImage: false,
              //             );
              //             if (selectedMedia != null &&
              //                 selectedMedia.every((m) =>
              //                     validateFileFormat(m.storagePath, context))) {
              //               setState(() => _model.isDataUploading = true);
              //               var selectedUploadedFiles = <FFUploadedFile>[];

              //               try {
              //                 showUploadMessage(
              //                   context,
              //                   'Uploading file...',
              //                   showLoading: true,
              //                 );
              //                 selectedUploadedFiles = selectedMedia
              //                     .map((m) => FFUploadedFile(
              //                           name: m.storagePath.split('/').last,
              //                           bytes: m.bytes,
              //                           height: m.dimensions?.height,
              //                           width: m.dimensions?.width,
              //                           blurHash: m.blurHash,
              //                         ))
              //                     .toList();
              //               } finally {
              //                 ScaffoldMessenger.of(context)
              //                     .hideCurrentSnackBar();
              //                 _model.isDataUploading = false;
              //               }
              //               if (selectedUploadedFiles.length ==
              //                   selectedMedia.length) {
              //                 setState(() {
              //                   _model.uploadedLocalFile =
              //                       selectedUploadedFiles.first;
              //                 });
              //                 showUploadMessage(context, 'Success!');
              //               } else {
              //                 setState(() {});
              //                 showUploadMessage(
              //                     context, 'Failed to upload data');
              //                 return;
              //               }
              //             }
              //           },
              //           text: 'Upload',
              //           options: FFButtonOptions(
              //             height: 40.0,
              //             padding: const EdgeInsetsDirectional.fromSTEB(
              //                 24.0, 0.0, 24.0, 0.0),
              //             iconPadding: const EdgeInsetsDirectional.fromSTEB(
              //                 0.0, 0.0, 0.0, 0.0),
              //             color: const Color(0xFF05BD7B),
              //             textStyle:
              //                 FlutterFlowTheme.of(context).titleSmall.override(
              //                       fontFamily: 'Outfit',
              //                       color: Colors.white,
              //                       letterSpacing: 0.0,
              //                     ),
              //             elevation: 3.0,
              //             borderSide: const BorderSide(
              //               color: Colors.transparent,
              //               width: 1.0,
              //             ),
              //             borderRadius: BorderRadius.circular(6.0),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  autofocus: true,
                  enabled: _isEditable,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Nome',
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
                        //
                        fontSize: 15.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                  validator:
                      _model.textController2Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _model.textController3.text =
                            pickedDate.toString().split(' ')[0];
                      });
                    }
                  },
                  child: AbsorbPointer(
                    absorbing:
                        !_isEditable, // Desativa o GestureDetector se !_isEditable
                    child: TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      enabled: _isEditable,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Data do Evento',
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
                          _model.textController3Validator.asValidator(context),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
              //   child: Text(
              //     '${widget.data.evento.id}',
              //     style: FlutterFlowTheme.of(context).titleLarge.override(
              //           fontFamily: 'Outfit',
              //           letterSpacing: 0.0,
              //         ),
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  enabled: _isEditable,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Evento',
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
                      _model.textController1Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: FlutterFlowDropDown<String>(
                  multiSelectController: _model.dropDownValueController1 ??=
                      FormFieldController<List<String>>(null),
                  options: List<String>.from(['1', '2', '3']),
                  optionLabels: const [
                    'Casamento',
                    'Festa infantil',
                    'Festa de aniversário'
                  ],
                  width: 373.0,
                  height: 56.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: const Color(0xFF05BD7B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                  hintText: 'Tipo de evento',
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
                  margin: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 4.0, 16.0, 4.0),
                  hidesUnderline: true,
                  isOverButton: true,
                  isSearchable: false,
                  isMultiSelect: true,
                  onMultiSelectChanged: (val) =>
                      setState(() => _model.dropDownValue1 = val),
                  labelText: '',
                  labelTextStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                          ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController4,
                  focusNode: _model.textFieldFocusNode4,
                  enabled: _isEditable,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'dwadwadwadwafwad',
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
                  keyboardType: TextInputType.number, // Apenas números
                  validator:
                      _model.textController4Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController6,
                  focusNode: _model.textFieldFocusNode6,
                  enabled: _isEditable,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Status',
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
                      _model.textController6Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  // controller: _model.textController5,
                  // focusNode: _model.textFieldFocusNode5,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'CEP',
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
                  // validator:
                  //     _model.textController5Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController10,
                  focusNode: _model.textFieldFocusNode10,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
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
                      _model.textController10Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController11,
                  focusNode: _model.textFieldFocusNode11,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Estado',
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
                      _model.textController11Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController9,
                  focusNode: _model.textFieldFocusNode9,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
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
                      _model.textController9Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController8,
                  focusNode: _model.textFieldFocusNode8,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Rua',
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
                      _model.textController8Validator.asValidator(context),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
              //   child: TextFormField(
              //     controller: _model.textController10,
              //     focusNode: _model.textFieldFocusNode10,
              //     autofocus: true,
              //     obscureText: false,
              //     decoration: InputDecoration(
              //       labelText: 'Número',
              //       labelStyle:
              //           FlutterFlowTheme.of(context).labelMedium.override(
              //                 fontFamily: 'Outfit',
              //                 color: const Color(0xFF05BD7B),
              //                 fontSize: 16.0,
              //                 letterSpacing: 0.0,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //       hintStyle:
              //           FlutterFlowTheme.of(context).labelMedium.override(
              //                 fontFamily: 'Outfit',
              //                 letterSpacing: 0.0,
              //               ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Color(0xFF05BD7B),
              //           width: 2.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: FlutterFlowTheme.of(context).primary,
              //           width: 2.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       errorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: FlutterFlowTheme.of(context).error,
              //           width: 2.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       focusedErrorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: FlutterFlowTheme.of(context).error,
              //           width: 2.0,
              //         ),
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     style: FlutterFlowTheme.of(context).bodyMedium.override(
              //           fontFamily: 'Outfit',
              //
              //           fontSize: 15.0,
              //           letterSpacing: 0.0,
              //           fontWeight: FontWeight.normal,
              //         ),
              //     validator:
              //         _model.textController10Validator.asValidator(context),
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  // controller: _model.textController11,
                  // focusNode: _model.textFieldFocusNode11,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Complemento',
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
                      _model.textController11Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController7,
                  focusNode: _model.textFieldFocusNode7,
                  enabled: _isEditable,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Descrição do Evento',
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
                      _model.textController7Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                child: TextFormField(
                  controller: _model.textController5,
                  focusNode: _model.textFieldFocusNode5,
                  enabled: _isEditable,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Quantidade de Funcionários',
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
                  keyboardType: TextInputType.number, // Apenas números
                  validator:
                      _model.textController5Validator.asValidator(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
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
                  margin: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 4.0, 16.0, 4.0),
                  hidesUnderline: true,
                  isOverButton: true,
                  isSearchable: false,
                  isMultiSelect: true,
                  onMultiSelectChanged: _onMultiSelectChanged,
                  labelText: '',
                  labelTextStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                          ),
                ),
              ),

              Column(
                children: selectedProfessions.map((Profession profession) {
                  int index = selectedProfessions.indexOf(profession);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Container(
                      width: 373.0,
                      height: 56.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0), // Adicionando padding para margem
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color(0xFF05BD7B),
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              profession.iconURL,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10), // Reduzido de 20 para 10
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedProfessions.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10), // Reduzido de 20 para 10
                          Expanded(
                            child: Text(
                              profession.name,
                              style: const TextStyle(
                                color: Color(0xFF05BD7B),
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10), // Reduzido de 20 para 10
                          const Text('Qtd:'),
                          const SizedBox(width: 10),
                          _buildIconButton(Icons.remove, () {
                            if (profession.quantidade > 0) {
                              _updateExperience(
                                  index, profession.quantidade - 1);
                            }
                          }),
                          Text('${profession.quantidade}'),
                          _buildIconButton(Icons.add, () {
                            _updateExperience(index, profession.quantidade + 1);
                          }),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  constraints: const BoxConstraints(
                    maxHeight: 56.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color(0xFF05BD7B),
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'dwadwadwa',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: const Color(0xFF05BD7B),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
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
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                child: GestureDetector(
                  onTap: () async {
                    verCandidaturas(widget.data);
                  },
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    constraints: const BoxConstraints(
                      maxHeight: 56.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF05BD7B),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFF05BD7B),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 8.0, 12.0, 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Candidaturas',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(1.0, 0.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: FlutterFlowTheme.of(context).alternate,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          28.0, 0.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.safePop();
                        },
                        text: 'Cancelar',
                        options: FFButtonOptions(
                          width: 150.0,
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color(0xFFFF4B26),
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
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          28.0, 0.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          editEvent();
                        },
                        text: 'Atualizar',
                        options: FFButtonOptions(
                          width: 150.0,
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
              ),
            ],
          ),
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

  void verCandidaturas(eventoModel) {
    print(eventoModel);
    print('dwadwkkkkkkkkkkkkkkkkkkkkkkkkkkkk');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfissionalEventsWidget(data: eventoModel)));
  }
}
