import 'package:mundo_festeiro_mobile_app/provide_services_page/provide_services_page_widget.dart';
import 'package:mundo_festeiro_mobile_app/select_category_service/select_category_service_widget.dart';
import 'package:mundo_festeiro_mobile_app/services_page/services_page_widget.dart';
import '../perfil_page/perfil_page_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'home_page_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../hamburger/hamburger.dart';
import '../Helper/helper.dart';
import '../constants/constants.dart';
import '../datas/user_provider.dart';
import '../datas/user.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => HomePageModel());
    fetchGetMe();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onProfileTap() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PerfilPageWidget()));
  }

  Future<void> fetchGetMe() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    var tokenSQL = await dbHelper.getToken();
    print('validToken');
    var url = Uri.parse(apiUrl + '/api/user/me');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $tokenSQL",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['userinfos'] != null) {
          Map<String, dynamic> userData = jsonResponse['userinfos'][0]['user'];
          int id = userData['id'] ?? 0;
          String name = userData['name'] ?? '';
          // Outros campos de usuário
          Map<String, dynamic> userData2 = jsonResponse['userinfos'][0];
          String photo = userData2['photo'] ?? '';

          if (photo.isEmpty) {
            var photo2 = null;
            User user = User(id: id, name: name, photoUrl: photo2);
            DatabaseHelper dbHelper = DatabaseHelper();
            await dbHelper
                .insertUser(user); // Convertendo User para Map antes de inserir

            Provider.of<UserProvider>(context, listen: false).setUser(user);
            print('Nome: $name');
            print('Photo1: ${photo}');
          } else {
            User user = User(id: id, name: name, photoUrl: photo);

            DatabaseHelper dbHelper = DatabaseHelper();
            await dbHelper
                .insertUser(user); // Convertendo User para Map antes de inserir

            Provider.of<UserProvider>(context, listen: false).setUser(user);
            print('Nome: $name');
            print('Photo2: ${photo}');
          }
          // print(userData2["photo"]);
        } else {
          print('Erro: Estrutura de resposta JSON inesperada');
        }
      } catch (e) {
        print('Erro ao decodificar JSON: $e');
      }
    } else {
      print('Error: GetMeUser');
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteToken();
      await dbHelper.deleteUser();
    }
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 180.0,
              child: CarouselSlider(
                items: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://picsum.photos/seed/655/600',
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://picsum.photos/seed/908/600',
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://picsum.photos/seed/180/600',
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 16.0, 0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://picsum.photos/seed/173/600',
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                carouselController: _model.carouselController ??=
                    CarouselController(),
                options: CarouselOptions(
                  initialPage: 1,
                  viewportFraction: 0.5,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, _) =>
                      setState(() => _model.carouselCurrentIndex = index),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: FlutterFlowIconButton(
                        buttonSize: 40.0,
                        icon: const Icon(
                          Icons.person,
                          color: Color(0xFF05BD7B),
                          size: 24.0,
                        ),
                        onPressed: () async {
                          procurarPrestador();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: FlutterFlowIconButton(
                        buttonSize: 40.0,
                        icon: const Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 24.0,
                        ),
                        onPressed: () async {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: FlutterFlowIconButton(
                        buttonSize: 40.0,
                        icon: const Icon(
                          Icons.celebration_sharp,
                          color: Color(0xFF05BD7B),
                          size: 24.0,
                        ),
                        onPressed: () async {
                          procurarEvento();
                        },
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
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      procurarPrestador();
                    },
                    child: Text(
                      'Contrate um\nprofissional',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      38.0, 0.0, 52.0, 0.0),
                  child: Text(
                    'Contratação de\n emergência',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Text(
                  'Procurar \nEvento',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        46.0, 32.0, 0.0, 0.0),
                    child: Text(
                      'Deseja ser um colaborador?\n Clique no botão abaixo e cadastre seu currículo.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  DatabaseHelper dbHelper = DatabaseHelper();
                  var tokenSQL = await dbHelper.getToken();
                  if (tokenSQL != null) {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                    createCurriculum(context);
                  } else {
                    GoRouter.of(context).go('/LoginPage');
                  }
                },
                text: 'Cadastrar-se',
                options: FFButtonOptions(
                  height: 40.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void procurarEvento() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const SelectCategoryServiceWidget()));
  }

  void procurarPrestador() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ServicesPageWidget()));
  }

  void createCurriculum(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProvideServicesPageWidget(),
      ),
    );
  }
}
