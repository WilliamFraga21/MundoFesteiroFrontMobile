# Como tratra erro Google do Projeto

```
"client_info": {
        "mobilesdk_app_id": "1:851397253901:android:2744119160339cca30ae44",
        "android_client_info": {
          "package_name": "com.mycompany.travelapp"
        }
      },


Caminho: android/app arquivo 'google-services.json'


```
## Iniciar Projeto

```shell

$ flutter clean

$ flutter pub get

```

## Iniciar Projeto/Backend

```shell

$ ipconfig

coletar o Endereço IPv4. . . . . . . .  . . . . . . . : 192.168.1.26

Colocar ip no arquivo constants.dart caminho 'lib/constants/constants.dart'

importa o constants em todos os arquivos que vai ser usado API

import 'constants/constants.dart';

para usar a ip do constants:  print(apiUrl); // Acessando a variável global

```

## Como Usar API

```

Future<void> createUser() async {
    var url = Uri.http('192.168.1.26:8000', '/api/user/create');
    var response = await http.post(url,
        body: json.encode({
          'name': 'WILLIAM',
          'email': 'williamfragacodadddwdaadawdwawadwanta@gmail.com',
          'contactno': '11970415085',
          'password': 'Mamaco1234@',
          'shippingAddress': 'rua teste',
          'shippingState': 'São Paulo',
          'shippingCity': 'São Paulo',
          'shippingPincode': '55',
          'billingAddress': 'Rua teste',
          'billingCity': 'São paulo',
          'billingState': 'são paulo',
          'billingPincode': '55',
          'regDate': '2000-07-21'
        }));

    if (response.statusCode == 201) {
      setState(() {
        _message = 'Conta criada com sucesso!';
      });
    } else {
      setState(() {
        _message =
            'Erro ao criar a conta. Status code: ${response.statusCode}. Message';
      });
    }
  }

```
