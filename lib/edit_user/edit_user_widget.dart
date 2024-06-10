import 'package:mundo_festeiro_mobile_app/configuration_edits/configuration_edits_widget.dart';
import 'package:mundo_festeiro_mobile_app/datas/userModel.dart';

import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'edit_user_model.dart';
export 'edit_user_model.dart';
import 'dart:convert';
import '../Helper/helper.dart';
import '../hamburger/hamburger.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../datas/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mundo_festeiro_mobile_app/datas/user.dart' as UserData;

// ignore: must_be_immutable
class EditUserWidget extends StatefulWidget {
  UserModel data;

  // ignore: use_super_parameters
  EditUserWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  late EditUserModel _model;
  late String _message;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => EditUserModel());

    _model.textController1 ??=
        TextEditingController(text: widget.data.user.name);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??=
        TextEditingController(text: widget.data.user.email);
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??=
        TextEditingController(text: widget.data.user.contactno);
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??=
        TextEditingController(text: widget.data.localidade.endereco);
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??=
        TextEditingController(text: widget.data.localidade.bairro);
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??=
        TextEditingController(text: widget.data.localidade.cidade);
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??=
        TextEditingController(text: widget.data.localidade.estado);
    _model.textFieldFocusNode8 ??= FocusNode();

    _message = "";
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // Future<User> fetchUser() async {
  //   var url = Uri.parse(apiUrl + '/api/user/me');
  //   final dbHelper = DatabaseHelper();
  //   String? validToken = await dbHelper.getToken();
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': "Bearer $validToken",
  //   };

  //   var response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     return User.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['userinfos'] != null) {
          Map<String, dynamic> userData = jsonResponse['userinfos'][0]['user'];
          int id = userData['id'] ?? 0;
          String name = userData['name'] ?? '';
          // Outros campos de usuário
          Map<String, dynamic> userData2 = jsonResponse['userinfos'][0];
          String photo = userData2['photo'] ?? '';

          UserData.User user =
              UserData.User(id: id, name: name, photoUrl: photo);

          DatabaseHelper dbHelper = DatabaseHelper();
          await dbHelper
              .insertUser(user); // Convertendo User para Map antes de inserir

          Provider.of<UserProvider>(context, listen: false).setUser(user);
          print('Nome: $name');
          print('Photo: $photo');
          // print(userData2["photo"]);
        } else {
          print('Erro: Estrutura de resposta JSON inesperada');
        }
      } catch (e) {
        print('Erro ao decodificar JSON: $e');
      }
    } else {
      print('Error: GetMeUser');
    }
  }

  Future<void> uploadAvatar(FFUploadedFile file) async {
    try {
      var uri = Uri.parse(apiUrl + '/api/user/avatar/create');
      final dbHelper = DatabaseHelper();
      String? validToken = await dbHelper.getToken();
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] =
            'Bearer $validToken' // Adiciona o cabeçalho de autorização com o token
        ..files.add(http.MultipartFile.fromBytes(
          'avatar',
          file.bytes!,
          filename: file.name,
        ));

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Avatar uploaded successfully!');
        await fetchGetMe();
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfigurationEditsWidget(),
            ),
          );
        });
      } else {
        print('Failed to upload avatar: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading avatar: $e');
    }
  }

  Future<void> editUser() async {
    var url = Uri.parse(apiUrl + '/api/user/update');
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    // Definindo os headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var body = json.encode({
      "name": _model.textController1.text,
      "email": _model.textController2.text,
      "contactno": _model.textController3.text,
      "password": _model.textController4.text,
      "endereco": _model.textController5.text,
      "bairro": _model.textController6.text,
      "cidade": _model.textController7.text,
      "estado": _model.textController8.text,
    });

    var response = await http.patch(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfigurationEditsWidget(),
          ),
        );
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
                : 'Erro ao Editar User. Status code: ${response.statusCode}'),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 150.0,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              130.0, 16.0, 0.0, 0.0),
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
                                          'https://images.unsplash.com/photo-1481819613568-3701cbc70156?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxOXx8bmlnaHQlMjBza3l8ZW58MHx8fHwxNzE0NTU3MDA0fDA&ixlib=rb-4.0.3&q=80&w=1080',
                                      fit: BoxFit.contain,
                                    ),
                                    allowRotation: false,
                                    tag: 'circleImageTag',
                                    useHeroAnimation: true,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'circleImageTag',
                              transitionOnUserGestures: true,
                              child: Container(
                                width: 130.0,
                                height: 130.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  widget.data.photo ??
                                      'https://images.unsplash.com/photo-1481819613568-3701cbc70156?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxOXx8bmlnaHQlMjBza3l8ZW58MHx8fHwxNzE0NTU3MDA0fDA&ixlib=rb-4.0.3&q=80&w=1080',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.28, 1.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 8.0,
                            borderWidth: 0.0,
                            buttonSize: 46.0,
                            fillColor: const Color(0xFF018959),
                            icon: Icon(
                              Icons.edit,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              final selectedMedia = await selectMedia(
                                maxWidth: 300.00,
                                maxHeight: 200.00,
                                includeBlurHash: true,
                                mediaSource: MediaSource.photoGallery,
                                multiImage: false,
                              );

                              if (selectedMedia != null &&
                                  selectedMedia.every((m) => validateFileFormat(
                                      m.storagePath, context))) {
                                setState(() => _model.isDataUploading = true);

                                try {
                                  showUploadMessage(
                                    context,
                                    'Uploading file...',
                                    showLoading: true,
                                  );

                                  // Apenas a primeira imagem é enviada
                                  final firstImage = selectedMedia.first;

                                  // Converte a imagem selecionada em FFUploadedFile
                                  final uploadedFile = FFUploadedFile(
                                    name:
                                        firstImage.storagePath.split('/').last,
                                    bytes: firstImage.bytes,
                                    height: firstImage.dimensions?.height,
                                    width: firstImage.dimensions?.width,
                                    blurHash: firstImage.blurHash,
                                  );

                                  // Envia a imagem para o backend
                                  await uploadAvatar(uploadedFile);

                                  showUploadMessage(context, 'Success!');
                                } catch (e) {
                                  print('Error uploading file: $e');
                                  showUploadMessage(
                                      context, 'Failed to upload file');
                                } finally {
                                  setState(
                                      () => _model.isDataUploading = false);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }
                              }
                            },
                          ),
                        ),
                      ],
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
                              'Editar informações',
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
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Nome ',
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
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Número',
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
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController5,
                        focusNode: _model.textFieldFocusNode5,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
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
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                        validator: _model.textController5Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController6,
                        focusNode: _model.textFieldFocusNode6,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
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
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                        validator: _model.textController6Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController7,
                        focusNode: _model.textFieldFocusNode7,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
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
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                        validator: _model.textController7Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController8,
                        focusNode: _model.textFieldFocusNode8,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
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
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                        validator: _model.textController8Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 16.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController4,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Senha',
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
                        validator: _model.textController4Validator
                            .asValidator(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 19.0),
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
                    FFButtonWidget(
                      onPressed: () async {
                        editUser();
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
