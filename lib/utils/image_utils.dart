import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> saveImageToLocalStorage(String sourcePath) async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDir = path.join(appDir.path, 'product_images');

    // Create images directory if it doesn't exist
    final Directory imagesDirFile = Directory(imagesDir);
    if (!await imagesDirFile.exists()) {
      await imagesDirFile.create(recursive: true);
    }

    // Generate unique filename using timestamp
    final String fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
    final String destinationPath = path.join(imagesDir, fileName);

    // Copy image file to app's local storage
    await File(sourcePath).copy(destinationPath);

    return destinationPath;
  } catch (e) {
    print('Error saving image: $e');
    return ''; // Return empty string if save fails
  }
}
