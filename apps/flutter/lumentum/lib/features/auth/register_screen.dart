import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/i18n/locale_provider.dart';
import '../../shared/widgets/auth_error_panel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final auth = context.read<AuthProvider>();
    final locale = context.read<LocaleProvider>().locale?.languageCode ?? 'en';
    final ok = await auth.register(
      email: _email.text.trim(),
      password: _password.text,
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      locale: locale,
    );
    if (ok && mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Chip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text(l10n.trialBadge),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstName,
                    decoration: InputDecoration(labelText: l10n.firstName),
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.errorGeneric : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastName,
                    decoration: InputDecoration(labelText: l10n.lastName),
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.errorGeneric : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: l10n.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || !v.contains('@') ? l10n.errorGeneric : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(labelText: l10n.password),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 8 ? l10n.errorGeneric : null,
                  ),
                  if (auth.failure != null) ...[
                    const SizedBox(height: 12),
                    AuthErrorPanel(failure: auth.failure!),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.startTrial14Days),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
