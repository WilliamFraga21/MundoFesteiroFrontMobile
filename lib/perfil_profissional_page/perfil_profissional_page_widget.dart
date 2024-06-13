import 'package:mundo_festeiro_mobile_app/flutter_flow/flutter_flow_drop_down.dart';
import 'package:mundo_festeiro_mobile_app/flutter_flow/form_field_controller.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'perfil_profissional_page_model.dart';
export 'perfil_profissional_page_model.dart';
import '../profissionals_page/profissionals_page_widget.dart';
import '../hamburger/hamburger.dart';
import '../datas/prestadorModel.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Helper/helper.dart';

class PerfilProfissionalPageWidget extends StatefulWidget {
  final PrestadorModel data;

  PerfilProfissionalPageWidget({Key? key, required this.data})
      : super(key: key);

  @override
  State<PerfilProfissionalPageWidget> createState() =>
      _PerfilProfissionalPageWidgetState();
}

class _PerfilProfissionalPageWidgetState
    extends State<PerfilProfissionalPageWidget> {
  late PerfilProfissionalPageModel _model;
  String? _selectedProfession;
  bool _showFinalizaPropostaModal = false;
  bool _showContratarButton = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilProfissionalPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> contrataPrestador() async {
    if (_selectedProfession == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erro'),
          content:
              Text('Selecione uma profissão antes de finalizar a contratação.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/prestador/contratar');

    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var body = json.encode({
      "profession": _selectedProfession,
      "idprestador": widget.data.prestador.id,
    });

    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: const Text('Proposta Enviada'),
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
                : 'Erro ao enviar proposta. Status code: ${response.statusCode}'),
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

  void _onProfileTap() {
    // Lógica para quando o perfil for clicado
    Navigator.pushNamed(context, 'PerfilPage', arguments: {
      'transition': PageTransitionType.fade,
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> professionOptions = widget.data.profession!
        .map((profissao) => profissao.profissao)
        .toList();
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
            scrollDirection: Axis.vertical,
            children: [
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
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                child: InkWell(
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
                            widget.data.photo ??
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
                      width: 200.0,
                      height: 200.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        widget.data.photo ??
                            'https://picsum.photos/seed/760/600',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (widget.data.profession != null)
                          for (var profession in widget.data.profession!)
                            Text(
                              profession
                                  .profissao, // Use o atributo correto da classe Profession2
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Text(
                            '${widget.data.prestador.name}',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF05BD7B),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 33.0, 4.0),
                          child: Text(
                            'Email: ${widget.data.prestador.email}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        if (widget.data.profession != null)
                          Wrap(
                            spacing:
                                8.0, // Espaçamento horizontal entre os itens
                            runSpacing:
                                8.0, // Espaçamento vertical entre as linhas
                            children: widget.data.profession!.map((profession) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profession.profissao,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 75.0, 4.0),
                                      child: Text(
                                        'Valor da hora R\$ ${profession.valorHoraServicoProfissao}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 150.0, 0.0),
                                      child: Text(
                                        'Diária: ${profession.valorDiaServicoProfissao}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.fromSTEB(
                        //       0.0, 0.0, 0.0, 4.0),
                        //   child: Text(
                        //     'Lorem Ipsum: Lorem Ipsum Lorem    ',
                        //     style: FlutterFlowTheme.of(context)
                        //         .bodyMedium
                        //         .override(
                        //           fontFamily: 'Outfit',
                        //           letterSpacing: 0.0,
                        //         ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.fromSTEB(
                        //       0.0, 0.0, 0.0, 4.0),
                        //   child: Text(
                        //     'Lorem Ipsum: Lorem Ipsum Lorem    ',
                        //     style: FlutterFlowTheme.of(context)
                        //         .bodyMedium
                        //         .override(
                        //           fontFamily: 'Outfit',
                        //           letterSpacing: 0.0,
                        //         ),
                        //   ),
                        // ),
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Text(
                            'Curriculo',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Outfit',
                                      color: const Color(0xFF05BD7B),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 12.0),
                            child: Text(
                              '${widget.data.prestador.curriculo}',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              _showContratarButton, // Mostra o botão "Contratar" se verdadeiro
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: FFButtonWidget(
                              onPressed: () {
                                setState(() {
                                  _showFinalizaPropostaModal =
                                      true; // Mostra o modal ao clicar em Contratar
                                  _showContratarButton =
                                      false; // Oculta o botão "Contratar" após clicar
                                });
                              },
                              text: 'Contratar',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFF05BD7B),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),

                        // Modal "Finaliza Proposta"
                        Visibility(
                          visible:
                              _showFinalizaPropostaModal, // Mostra o modal se verdadeiro
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 12),
                                          child: Text(
                                            'Escolha a profissão para qual deseja contratá-lo(a):',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 14,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.data.profession != null)
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 12),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dropDownValueController ??=
                                                FormFieldController<String>(
                                                    _model.dropDownValue ??=
                                                        ''),
                                            options: professionOptions,
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedProfession =
                                                    val; // Atualiza a profissão selecionada
                                              });
                                            },
                                            width: double.infinity,
                                            height: 56,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0,
                                                    ),
                                            hintText: 'Selecione',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 2,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderWidth: 2,
                                            borderRadius: 8,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 4, 16, 4),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                            labelText: '',
                                            labelTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0,
                                                    ),
                                            multiSelectController: null,
                                            onMultiSelectChanged: null,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: _selectedProfession != null
                                          ? Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    child: Text(
                                                      "Finalizar contratação como: $_selectedProfession",
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                'Outfit',
                                                            letterSpacing: 0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'Nenhuma profissão selecionada',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          contrataPrestador();
                                        },
                                        text: 'Finalizar contratação',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 48,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: Color(0xFF05BD7B),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Outfit',
                                                    color: Colors.white,
                                                    letterSpacing: 0,
                                                  ),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
