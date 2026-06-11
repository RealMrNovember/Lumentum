import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';

import 'picked_pdf_file.dart';

/// Tarayıcıda doğrudan `<input type="file">` — güvenilir PDF seçimi.
Future<PickedPdfFile?> pickPdfFile() async {
  final completer = Completer<PickedPdfFile?>();
  final input = HTMLInputElement()
    ..type = 'file'
    ..accept = 'application/pdf,.pdf'
    ..style.display = 'none';

  var completed = false;
  Timer? cancelTimer;

  void finish(PickedPdfFile? value) {
    if (completed) return;
    completed = true;
    cancelTimer?.cancel();
    input.remove();
    if (!completer.isCompleted) completer.complete(value);
  }

  input.addEventListener(
    'change',
    ((Event event) {
      final files = input.files;
      if (files == null || files.length == 0) {
        finish(null);
        return;
      }
      final file = files.item(0);
      if (file == null) {
        finish(null);
        return;
      }

      final reader = FileReader();
      reader.addEventListener(
        'loadend',
        ((Event _) {
          final buffer = (reader.result as JSArrayBuffer?)?.toDart;
          if (buffer == null) {
            finish(null);
            return;
          }
          finish(
            PickedPdfFile(
              name: file.name,
              bytes: buffer.asUint8List(),
            ),
          );
        }).toJS,
      );
      reader.readAsArrayBuffer(file);
    }).toJS,
  );

  document.body?.appendChild(input);
  input.click();

  cancelTimer = Timer(const Duration(minutes: 2), () => finish(null));

  return completer.future;
}
