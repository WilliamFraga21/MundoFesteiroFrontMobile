import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'select_edit_event_model.dart';
export 'select_edit_event_model.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../edit_event_page/edit_event_page_widget.dart';
import '../hamburger/hamburger.dart';
import '../Helper/helper.dart';
import '../datas/eventoModel.dart';

class SelectEditEventWidget extends StatefulWidget {
  const SelectEditEventWidget({super.key});

  @override
  State<SelectEditEventWidget> createState() => _SelectEditEventWidgetState();
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? pushNamed(String routeName,
      {required Map<String, dynamic> extras}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: extras);
  }
}

class EventosScreen extends StatefulWidget {
  @override
  _SelectEditEventWidgetState createState() => _SelectEditEventWidgetState();
}

class _SelectEditEventWidgetState extends State<SelectEditEventWidget> {
  late SelectEditEventModel _model;
  late Future<List<EventoModel>> futureEventos;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureEventos = fetchEventos();
    _model = createModel(context, () => SelectEditEventModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<EventoModel>> fetchEventos() async {
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/evento/me');
    print(validToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // print(response.body);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['Evento'] != null) {
        // List<dynamic> eventsJson = jsonResponse['Evento'];
        // var la = jsonResponse['Evento'];
        List jsonResponse = json.decode(response.body)['Evento'];
        print(jsonResponse);
        return jsonResponse
            .map((evento) => EventoModel.fromJson(evento))
            .toList();
        // throw Exception(la.user);
        // return eventsJson.map((event) => Event.fromJson(event)).toList();
      } else {
        throw Exception('Eventos não encontrados');
      }
    } else {
      print(response.body);
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
          child: FutureBuilder<List<EventoModel>>(
            future: futureEventos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final eventoModel = snapshot.data![index];
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 0.0),
                            child: Container(
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
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: const Color(0xFF05BD7B),
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
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
                                      eventoModel.photo ??
                                          'https://static.vecteezy.com/ti/vetor-gratis/p1/9169455-ceu-dourado-por-do-sol-na-costa-natureza-paisagem-vetor.jpg',
                                      width: 300.0,
                                      height: 179.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          5), // Adiciona um espaçamento de 5 pixels
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          capitalizeFirstLetter(
                                              eventoModel.evento.nomeEvento),
                                          textAlign: TextAlign.justify,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                color: Colors.black,
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(13.0, 4.0, 5.0, 4.0),
                                          child: Text(
                                            eventoModel.photo.toString(),
                                            textAlign: TextAlign.justify,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  color: Colors.black,
                                                  fontFamily: 'Outfit',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                                verEvento(eventoModel);
                                              },
                                              text:
                                                  'Acessar detalhes do evento',
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
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Text('Nenhum dado encontrado');
              }
            },
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  verEvento(EventoModel eventoModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditEventPageWidget(data: eventoModel)));
  }
}
