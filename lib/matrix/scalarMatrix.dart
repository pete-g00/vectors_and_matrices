part of '../vectors_and_matrices.dart';

class _ScalarMatrix<T extends num> extends SquareMatrix<T>{
  @override
  final int n;

  final T scalar;

  const _ScalarMatrix(this.n, this.scalar);

  @override
  RowVector<T> getRow(int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, n, 'i');

    return RowVector.singleNonZero(n, scalar, i);
  }

  @override
  ColVector<T> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n, 'j');

    return ColVector.singleNonZero(n, scalar, j);
  }

  @override
  T getValue(int i, int j){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, n, 'i');
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n, 'j');

    return i == j ? scalar : _intAsT(0);
  }

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  SquareMatrix<T> toREF() => this;

  @override
  SquareMatrix<double> toRREF() => scalar == 0 ? _ScalarMatrix(n, 0.0) : _ScalarMatrix(n, 1.0);

  @override
  int get rank => scalar == 0 ? 0 : n;

  @override
  bool get isInvertible => scalar != 0;

  @override
  SquareMatrix<double> invert() => scalar == 0 ? null : _ScalarMatrix(n, 1/scalar);

  @override
  SquareMatrix<double> operator ^(int i) => i.isNegative && scalar == 0 ? null : _ScalarMatrix(n, pow(scalar, i).toDouble());

  @override
  T get determinant => pow(scalar, n);

  @override
  SquareMatrix<T> scalarMultiply(T scalar) => _ScalarMatrix(n, scalar * this.scalar);

  @override
  Matrix<T> operator * (Matrix<T> matrix){
    if (matrix.m != n){
      throw StateError('The matrices cannot be multiplied!');
    }
    return matrix.scalarMultiply(scalar);
  }

  @override
  SquareMatrix<T> operator - () => _ScalarMatrix(n, -scalar);
}