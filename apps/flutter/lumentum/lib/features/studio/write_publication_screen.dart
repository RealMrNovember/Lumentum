import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import 'content_types.dart';

class WritePublicationScreen extends StatefulWidget {
  const WritePublicationScreen({super.key});

  @override
  State<WritePublicationScreen> createState() => _WritePublicationScreenState();
}

class _WritePublicationScreenState extends State<WritePublicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _body = TextEditingController();
  final _tags = TextEditingController();

  String _contentType = 'novel';
  bool _submitting = false;
  List<int>? _coverBytes;
  String? _coverName;

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    _body.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    setState(() {
      _coverBytes = file.bytes;
      _coverName = file.name;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      final api = context.read<AuthProvider>().api;
      final tags = _tags.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      var pub = await api.createPublication(
        title: _title.text.trim(),
        summary: _summary.text.trim().isEmpty ? null : _summary.text.trim(),
        body: _body.text.trim(),
        contentType: _contentType,
        tags: tags,
      );

      if (_coverBytes != null) {
        pub = await api.uploadPublicationCover(
          publicationId: pub.id,
          bytes: _coverBytes!,
          filename: _coverName ?? 'cover.jpg',
          mimeType: 'image/jpeg',
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.publicationPublished)),
      );
    } on LumentumApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.body)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.writeContent),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.publish),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.selectContentType,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: contentTypeOptions.map((o) {
                final selected = _contentType == o.id;
                return ChoiceChip(
                  label: Text(contentTypeLabel(l10n, o.id)),
                  avatar: Icon(o.icon, size: 18, color: o.color),
                  selected: selected,
                  onSelected: (_) => setState(() => _contentType = o.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _pickCover,
              icon: const Icon(Icons.image_rounded),
              label: Text(
                _coverName ?? l10n.uploadCover,
              ),
            ),
            if (_coverBytes != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  Uint8List.fromList(_coverBytes!),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextFormField(
              controller: _title,
              decoration: InputDecoration(labelText: l10n.documentTitle),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.errorGeneric : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _summary,
              decoration: InputDecoration(labelText: l10n.publicationSummary),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tags,
              decoration: InputDecoration(
                labelText: l10n.publicationTags,
                hintText: l10n.publicationTagsHint,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _body,
              decoration: InputDecoration(labelText: l10n.publicationBody),
              maxLines: 14,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.errorGeneric : null,
            ),
          ],
        ),
      ),
    );
  }
}
