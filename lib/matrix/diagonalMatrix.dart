part of '../vectors_and_matrices.dart';

class _DiagonalMatrix<T extends num> extends SquareMatrix<T> {
  final List<T> diagonalEntries;

  const _DiagonalMatrix(this.diagonalEntries);

  @override
  int get n => diagonalEntries.length;

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, n, 'i');

    return RowVector.singleNonZero(n, diagonalEntries[i], i);
  }

  @override
  ColVector<T> getCol(int j) {
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n, 'j');

    return ColVector.singleNonZero(n, diagonalEntries[j], j);
  }

  @override
  T getValue(int i, int j) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, n, 'i');
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n, 'j');

    return i == j ? diagonalEntries[i] : _intAsT(0);
  }

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  SquareMatrix<T> toREF() {
    final copy = diagonalEntries.toList();
    copy.sort((i, j) {
      if (i == 0) return 1;
      return 0;
    });

    return _DiagonalMatrix(copy);
  }

  @override
  SquareMatrix<double> toRREF() {
    final copy = diagonalEntries.toList();
    copy.sort((i, j) {
      if (i == 0) return 1;
      return 0;
    });

    return _DiagonalMatrix(copy.map((i) => i == 0 ? 0.0 : 1.0).toList());
  }

  @override
  int get rank {
    var rank = 0;
    for (var i = 0; i < diagonalEntries.length; i++) {
      if (diagonalEntries[i] != 0) rank++;
    }
    return rank;
  }

  @override
  SquareMatrix<double> invert() {
    final list = <double>[];
    for (var i = 0; i < diagonalEntries.length; i++) {
      if (diagonalEntries[i] == 0) return null;
      list.add(1 / diagonalEntries[i]);
    }
    return _DiagonalMatrix(list);
  }

  @override
  SquareMatrix<double> operator ^(int i) {
    final list = <double>[];
    for (var j = 0; j < diagonalEntries.length; j++) {
      if (i.isNegative && diagonalEntries[j] == 0) return null;
      list.add(pow(diagonalEntries[j], i).toDouble());
    }
    return _DiagonalMatrix(list);
  }

  @override
  T get determinant => diagonalEntries.product;

  @override
  SquareMatrix<T> operator -() =>
      _DiagonalMatrix(diagonalEntries.map((elt) => -elt).toList());

  @override
  SquareMatrix<T> scalarMultiply(T scalar) =>
      _DiagonalMatrix(diagonalEntries.map((elt) => elt * scalar).toList());

  @override
  Matrix<T> operator *(Matrix<T> matrix) {
    if (matrix.m != n) {
      throw StateError('The matrices cannot be multiplied!');
    }
    return matrix.mapRow((vector, i) => vector * diagonalEntries[i]);
  }
}
