import 'package:mundo_festeiro_mobile_app/event_details_page/event_details_page_widget.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'applied_events_model.dart';
export 'applied_events_model.dart';
import '../hamburger/hamburger.dart';
import '../datas/EventosAPModel.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Helper/helper.dart';
import '../datas/eventoModel.dart';

class AppliedEventsWidget extends StatefulWidget {
  const AppliedEventsWidget({super.key});

  @override
  State<AppliedEventsWidget> createState() => _AppliedEventsWidgetState();
}

class _AppliedEventsWidgetState extends State<AppliedEventsWidget> {
  late AppliedEventsModel _model;
  late Future<List<EventoAPModel>> futureEventos;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureEventos = fetchEventosAP();

    _model = createModel(context, () => AppliedEventsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<EventoModel> fetchPrestadoByID(int id) async {
    var url = Uri.parse(apiUrl + '/evento/find/$id');

    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['Evento'] != null) {
        // Supondo que a resposta JSON contém uma lista de prestadores
        List<dynamic> prestadorList = jsonResponse['Evento'];
        if (prestadorList.isNotEmpty) {
          return EventoModel.fromJson(prestadorList[0]);
        } else {
          throw Exception('Prestador não encontrado');
        }
      } else {
        throw Exception('Prestador não encontrado');
      }
    } else {
      print(response.body);
      throw Exception('Falha ao carregar prestador');
    }
  }

  Future<List<EventoAPModel>> fetchEventosAP() async {
    var url = Uri.parse(apiUrl + '/api/prestador/eventos');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData != null && responseData['eventos'] != null) {
        print(responseData);
        print("responseData");
        List<dynamic> eventosJson = responseData['eventos'];
        print(eventosJson);
        print("eventosJson");
        print("Print Return");
        print(eventosJson
            .map((evento) => EventoAPModel.fromJson(evento))
            .toList());
        return eventosJson
            .map((evento) => EventoAPModel.fromJson(evento))
            .toList();
      } else {
        return []; // Retorna uma lista vazia se 'eventos' for nulo ou se a resposta do servidor não contiver dados
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Text(
                  'Eventos Aplicados',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 25.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<EventoAPModel>>(
                  future: futureEventos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Se a Future ainda estiver esperando, exiba um indicador de progresso
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Se ocorrer um erro, exiba uma mensagem de erro
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
                    } else {
                      // Se a Future estiver concluída com sucesso, construa a lista de eventos
                      List<EventoAPModel> eventos = snapshot.data!;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: eventos.length,
                        itemBuilder: (context, index) {
                          EventoAPModel evento = eventos[index];
                          // Aqui você pode criar o widget para exibir cada evento
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
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
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: const Color(0xFF05BD7B),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  child: Image.network(
                                    evento.eventoAP.evento_imagem ?? imgEvent,
                                    height: 179.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${evento.eventoAP.nomeEvento}",
                                    textAlign: TextAlign.justify,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Outfit',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors
                                              .black, // Defina a cor do texto como preto
                                        ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 1.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 10.0, 0.0, 20.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              // Navegue para a página de detalhes do evento
                                              try {
                                                EventoModel prestadorModel =
                                                    await fetchPrestadoByID(
                                                        evento.eventoAP
                                                            .evento_id);
                                                verEvento(prestadorModel);
                                              } catch (e) {
                                                print(
                                                    'Erro ao buscar prestador: $e');
                                                // Exibir um aviso ao usuário
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Erro'),
                                                      content: Text(
                                                          'Erro ao carregar perfil do prestador.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            text: 'Acessar detalhes do evento',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color: const Color(0xFF05BD7B),
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
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
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verEvento(EventoModel eventoModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EventDetailsPageWidget(data: eventoModel)));
  }
}
