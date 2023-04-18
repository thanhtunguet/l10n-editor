import 'package:flutter/material.dart';
import 'package:l10n_manipulator/manipulator_app.dart';
import 'package:truesight_flutter/truesight_flutter.dart';

@reflector
@UsePageRoute('/figma')
class FigmaConfigPage extends StatefulWidget {
  const FigmaConfigPage({super.key});

  @override
  State<FigmaConfigPage> createState() => _FigmaConfigPageState();
}

class _FigmaConfigPageState extends State<FigmaConfigPage> {
  // Define a TextEditingController to retrieve the value of the text field.
  final apiKeyController = TextEditingController();

  _onSaveApiKey() {

  }

  String? _validateApiKey(String? apiKey) {
    if (apiKey == null) {
      // return AppLocalizations.of(context)
      return 'API key can not be null';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.figma_config_page),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.enter_figma_api_key,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: apiKeyController,
              validator: _validateApiKey,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.figma_api_key,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onSaveApiKey,
              child: Text(AppLocalizations.of(context)!.action_save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the TextEditingController to avoid memory leaks.
    apiKeyController.dispose();
    super.dispose();
  }
}
