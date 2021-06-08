import 'dart:math' show sqrt, pow;
import 'dart:collection' show IterableBase;

import 'package:collection/collection.dart'
    show DelegatingSet, SetEquality, IterableEquality;
import 'package:corextensions/corextensions.dart';

part 'span/span.dart';
part 'span/colSpan.dart';
part 'span/rowSpan.dart';

part 'vector/rowVector.dart';
part 'vector/colVector.dart';
part 'vector/unitVector.dart';
part 'vector/vector.dart';
part 'vector/generatedVector.dart';
part 'vector/summedVector.dart';
part 'vector/filledVector.dart';
part 'vector/standardVector.dart';
part 'vector/mappedVector.dart';
part 'vector/singleNonZeroValuedVector.dart';
part 'vector/followedByValue.dart';
part 'vector/precededByValue.dart';
part 'vector/twoVectorsAsOne.dart';
part 'vector/subVector.dart';

part 'matrix/ero.dart';
part 'matrix/matrix.dart';
part 'matrix/squareMatrix.dart';
part 'matrix/eroOperatedMatrix.dart';
part 'matrix/sumMatrix.dart';
part 'matrix/transposedMatrix.dart';
part 'matrix/multipliedMatrix.dart';
part 'matrix/standardRowMatrix.dart';
part 'matrix/multipliedWithColVectorVector.dart';
part 'matrix/multipliedWithRowVectorVector.dart';
part 'matrix/fromRowVectorsMatrix.dart';
part 'matrix/fromColVectorsMatrix.dart';
part 'matrix/generatedMatrix.dart';
part 'matrix/filledMatrix.dart';
part 'matrix/rowMappedMatrix.dart';
part 'matrix/colMappedMatrix.dart';
part 'matrix/valueMappedMatrix.dart';
part 'matrix/matrixIterator.dart';
part 'matrix/followedByRowMatrix.dart';
part 'matrix/followedByColMatrix.dart';
part 'matrix/precededByRowMatrix.dart';
part 'matrix/precededByColMatrix.dart';
part 'matrix/twoMatricesCombinedWRTRow.dart';
part 'matrix/twoMatricesCombinedWRTCol.dart';
part 'matrix/toSquareMatrix.dart';
part 'matrix/diagonalMatrix.dart';
part 'matrix/scalarMatrix.dart';
part 'matrix/subMatrix.dart';

mixin _IteratorMixin<T> on Iterator<T> {
  /// The current location of the iterator.
  int i = -1;

  /// The length of the iterable on which we are iterating.
  int get length;

  /// The current value of the iterable.
  ///
  /// There will be no range errors raised when this method is called, as opposed to the [current] method.
  ///
  /// That is, this method is only run if when i is between 0 (inclusive) and length (exclusive).
  T get value;

  @override
  bool moveNext() => i++ < length - 1;

  @override
  T get current => i >= 0 && i < length ? value : null;
}

void main() {
  final p = SquareMatrix.fromRows([
    [1, -1, -1],
    [0, 0, 1],
    [1, 1, 0],
  ]);
  print(p.invert());
}