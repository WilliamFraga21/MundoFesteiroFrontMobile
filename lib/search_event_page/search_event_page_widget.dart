import 'package:mundo_festeiro_mobile_app/event_details_page/event_details_page_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'search_event_page_model.dart';
export 'search_event_page_model.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../hamburger/hamburger.dart';
import '../datas/eventoModel.dart';
import '../select_category_service/select_category_service_widget.dart';

class SearchEventPageWidget extends StatefulWidget {
  // const SearchEventPageWidget({super.key});

  Profession data;

  SearchEventPageWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<SearchEventPageWidget> createState() => _SearchEventPageWidgetState();
}

class _SearchEventPageWidgetState extends State<SearchEventPageWidget> {
  late SearchEventPageModel _model;
  late Future<List<EventoModel>> futureEventos;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureEventos = fetchEventos();
    _model = createModel(context, () => SearchEventPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<EventoModel>> fetchEventos() async {
    var url = Uri.parse(apiUrl + '/evento/${widget.data.idProfessionEvento}');
    var headers = {'Content-Type': 'application/json'};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['Evento'] != null) {
        List jsonResponse = json.decode(response.body)['Evento'];
        return jsonResponse
            .map((evento) => EventoModel.fromJson(evento))
            .toList();
      } else {
        throw Exception('Eventos não encontrados');
      }
    } else {
      throw Exception('Falha ao carregar eventos');
    }
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
          title: Image.network(
            'https://media.canva.com/v2/image-resize/format:PNG/height:352/quality:100/uri:s3%3A%2F%2Fmedia-private.canva.com%2FvV_9Y%2FMAGIsDvV_9Y%2F1%2Fp.png/watermark:F/width:548?csig=AAAAAAAAAAAAAAAAAAAAAB7HIj0Zqe08fwl-4Wc73k15xXTVYta-i3G8Kcqfc_dN&exp=1718916484&osig=AAAAAAAAAAAAAAAAAAAAAFhQof94P7h-FOvazjHveb-AkmxHsc8OyR2uVlMU2loF&signer=media-rpc&x-canva-quality=thumbnail_large',
            height: 40.0, // Ajuste a altura conforme necessário
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: buildFutureEventos(),
        ),
      ),
    );
  }

  Widget buildFutureEventos() {
    return FutureBuilder<List<EventoModel>>(
      future: futureEventos,
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
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final eventoModel = snapshot.data![index];
              return buildEventoCard(eventoModel);
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
    );
  }

  Widget buildEventoCard(EventoModel eventoModel) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
      child: Container(
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
          border: Border.all(color: const Color(0xFF05BD7B), width: 2.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                eventoModel.photo ?? imgEvent,
                width: 300.0,
                height: 179.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Text(
                capitalizeFirstLetter(eventoModel.evento.nomeEvento),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: Colors.black,
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
              ),
            ),
            if (eventoModel.profissao != null)
              Text(
                eventoModel.profissao!
                    .map((profession) => profession.profissao)
                    .join(', '),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: Colors.black,
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(13.0, 4.0, 5.0, 4.0),
              child: Text(
                '${eventoModel.localidadeEvento.estado},${eventoModel.localidadeEvento.cidade},${eventoModel.localidadeEvento.bairro}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: Colors.black,
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
              child: FFButtonWidget(
                onPressed: () => verEvento(eventoModel),
                text: 'Acessar detalhes do evento',
                options: FFButtonOptions(
                  height: 40.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  color: const Color(0xFF05BD7B),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ],
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

  void verEvento(EventoModel eventoModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsPageWidget(data: eventoModel),
      ),
    );
  }
}
