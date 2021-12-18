import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:pi_papers_2021_2/utils/image_utils.dart';
import 'package:pi_papers_2021_2/utils/list_utils.dart';
import 'package:pi_papers_2021_2/utils/spatial_enum.dart';

typedef SpatialFilter = int Function(List<int> neighborhood);

int laplaceFilter(List<int> neighborhood) {
  final product = neighborhood * laplaceMask;
  return product.reduce(sum);
}

List<int>? _gaussianMask;
int gaussianFilter(List<int> neighborhood) {
  final product = neighborhood * _gaussianMask!;
  return product.reduce(sum);
}

List<int>? _detectorMask;
int robertsSobelFilter(List<int> neighborhood) {
  final product = neighborhood * _detectorMask!;
  return product.reduce(sum);
}

List<SpatialFilter> _processInput(Map<SpatialFilters, bool> allFilters) {
  final filters = {...allFilters}..removeWhere((key, value) => !value);
  return filters.keys.map((e) => e.asOperation()).toList();
}

Uint8List? operate(
  Uint8List? image,
  Map<SpatialFilters, bool>? allFilters,
  double? sigma,
  DetectorOptions? detector,
) {
  if (image == null ||
      allFilters == null ||
      sigma == null ||
      detector == null) {
    return null;
  }

  _gaussianMask = laplacianOfGaussian(sigma).flat;
  _detectorMask = getDetectorMask(detector.asText());

  final selectedFilters = _processInput(allFilters);

  final decodedImage = decodeImage(image)!;

  var initialPixels = convertListToMatrix(
    decodedImage.getBytes(format: Format.luminance),
    decodedImage.width,
  ).map((e) => e.toList()).toList();

  var stepPixels = List.generate(
    initialPixels.length,
    (row) => [...initialPixels[row]],
  );

  for (final filter in selectedFilters) {
    final threeNeighborhood =
        (filter == laplaceFilter || filter == robertsSobelFilter);
    final imageLuminanceMatrix =
        initialPixels.map((e) => Uint8List.fromList(e)).toList();

    for (var y = 0; y < initialPixels.length; y++) {
      for (var x = 0; x < initialPixels[0].length; x++) {
        final neighborhood = getNeighborhood(
          imageLuminanceMatrix: imageLuminanceMatrix,
          yPosition: y,
          xPosition: x,
          neighborhoodSize: threeNeighborhood ? 3 : 9,
          isConvolution: true,
        );

        stepPixels[y][x] = max(0, min(filter(neighborhood), 255));
      }
    }

    initialPixels = stepPixels;
  }

  return reformat(
    width: decodedImage.width,
    height: decodedImage.height,
    processedImage: Uint8List.fromList(initialPixels.flat),
    format: Format.luminance,
  );
}