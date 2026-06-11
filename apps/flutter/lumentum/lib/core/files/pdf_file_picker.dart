import 'picked_pdf_file.dart';

import 'pdf_file_picker_io.dart'
    if (dart.library.js_interop) 'pdf_file_picker_web.dart' as picker;

Future<PickedPdfFile?> pickPdfFile() => picker.pickPdfFile();
