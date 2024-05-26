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

class SelectEditEventWidget extends StatefulWidget {
  const SelectEditEventWidget({super.key});

  @override
  State<SelectEditEventWidget> createState() => _SelectEditEventWidgetState();
}

class User {
  final int id;
  final String name;
  final String email;
  final String contactNo;
  final String shippingAddress;
  final String shippingState;
  final String shippingCity;
  final int shippingPincode;
  final String? status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.shippingAddress,
    required this.shippingState,
    required this.shippingCity,
    required this.shippingPincode,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactno'].toString(),
      shippingAddress: json['shippingAddress'],
      shippingState: json['shippingState'],
      shippingCity: json['shippingCity'],
      shippingPincode: json['shippingPincode'],
      status: json['Status'],
    );
  }
}

class Evento {
  final int id;
  final String nomeEvento;
  final String tipoEvento;
  final String data;
  final int quantidadePessoas;
  final int quantidadeFuncionarios;
  final String statusEvento;
  final String descricaoEvento;
  final int usersId;
  final int localidadeId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Evento({
    required this.id,
    required this.nomeEvento,
    required this.tipoEvento,
    required this.data,
    required this.quantidadePessoas,
    required this.quantidadeFuncionarios,
    required this.statusEvento,
    required this.descricaoEvento,
    required this.usersId,
    required this.localidadeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nomeEvento: json['nomeEvento'],
      tipoEvento: json['tipoEvento'],
      data: json['data'],
      quantidadePessoas: json['quantidadePessoas'],
      quantidadeFuncionarios: json['quantidadeFuncionarios'],
      statusEvento: json['statusEvento'],
      descricaoEvento: json['descricaoEvento'],
      usersId: json['users_id'],
      localidadeId: json['localidade_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class LocalidadeEvento {
  final int id;
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;
  final String createdAt;
  final String updatedAt;

  LocalidadeEvento({
    required this.id,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalidadeEvento.fromJson(Map<String, dynamic> json) {
    return LocalidadeEvento(
      id: json['id'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Profissao {
  final String profissao;
  final int profissaoId;

  Profissao({
    required this.profissao,
    required this.profissaoId,
  });

  factory Profissao.fromJson(Map<String, dynamic> json) {
    return Profissao(
      profissao: json['profissao'],
      profissaoId: json['profissao_id'],
    );
  }
}

class EventoModel {
  final User user;
  final Evento evento;
  final LocalidadeEvento localidadeEvento;
  final List<Profissao> profissao;

  EventoModel({
    required this.user,
    required this.evento,
    required this.localidadeEvento,
    required this.profissao,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    var list = json['profissao'] as List;
    List<Profissao> profissaoList =
        list.map((i) => Profissao.fromJson(i)).toList();

    return EventoModel(
      user: User.fromJson(json['user']),
      evento: Evento.fromJson(json['evento']),
      localidadeEvento: LocalidadeEvento.fromJson(json['localidadeEvento']),
      profissao: profissaoList,
    );
  }
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
    var url = Uri.parse(apiUrl + '/api/evento/me');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['Evento'] != null) {
        // List<dynamic> eventsJson = jsonResponse['Evento'];
        // var la = jsonResponse['Evento'];
        List jsonResponse = json.decode(response.body)['Evento'];
        return jsonResponse
            .map((evento) => EventoModel.fromJson(evento))
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
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<EventoModel>>(
            future: futureEventos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
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
                                      'https://picsum.photos/seed/874/600',
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
                                            eventoModel.evento.descricaoEvento,
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
