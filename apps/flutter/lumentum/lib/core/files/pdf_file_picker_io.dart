import 'package:file_picker/file_picker.dart';

import 'picked_pdf_file.dart';

Future<PickedPdfFile?> pickPdfFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf'],
    withData: true,
    allowMultiple: false,
  );
  if (result == null || result.files.isEmpty) return null;

  final file = result.files.first;
  final bytes = file.bytes;
  if (bytes == null || bytes.isEmpty) {
    throw StateError('PDF dosyası okunamadı.');
  }

  final name = file.name.toLowerCase().endsWith('.pdf')
      ? file.name
      : '${file.name}.pdf';
  return PickedPdfFile(name: name, bytes: bytes);
}
