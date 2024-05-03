# MundoFesteiroMobileApp

A new Flutter project.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.



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