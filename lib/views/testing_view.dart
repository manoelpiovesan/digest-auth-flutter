import 'package:digest_auth/connection/digest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  http.Response? response;
  DigestAuth digest = DigestAuth(
    url: 'http://192.168.180.3',
    uri: '/!dhost.b',
    username: 'admin',
    password: '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'URL',
                          ),
                          initialValue: digest.url,
                          onChanged: (String? value) {
                            digest.url = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'URI / PATH',
                          ),
                          initialValue: digest.uri,
                          onChanged: (String? value) {
                            digest.uri = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          initialValue: digest.username,
                          onChanged: (String? value) {
                            digest.username = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          initialValue: digest.password,
                          onChanged: (String? value) {
                            digest.password = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              response = null;
                            });
                            response = await digest.get();
                            setState(() {});
                          },
                          child: const Text('Enviar requisição'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: response == null
                      ? const CircularProgressIndicator()
                      : Column(
                          children: <Widget>[
                            const Text('Header'),
                            const Divider(),
                            Text(
                              response == null
                                  ? ''
                                  : response!.headers.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Text('Body'),
                            const Divider(),
                            Text(
                              response == null ? '' : response!.body,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
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
