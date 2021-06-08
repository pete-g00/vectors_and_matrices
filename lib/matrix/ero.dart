part of '../vectors_and_matrices.dart';

/// The class ERO represents an elementary row operation.
///
/// We construct the 3 types of operations as:
///
/// * [ERO.scale], which scales a particular row.
///
/// * [ERO.swap], which swaps two rows.
///
/// * [ERO.sum], which sums many rows into a single row. Every row/scalar multiple component is represented as an [EROFragment].
///
/// The change that an ERO provides to a matrix is established by the [getValue] method, which provides the ERO-operated value for some entry in the matrix.
abstract class ERO<T extends num> {
  const ERO();

  /// Creates an elementary row operation that scales the `changingRow` by the provided `scale`.
  const factory ERO.scale(int changingRow, T scale) = _ScaleERO;

  /// Creates an elementary row operation that swaps `row1` and `row2`.
  const factory ERO.swap(int row1, int row2) = _SwapERO;

  /// Creates an elementary row operation that adds the rows present in the `fragment` to the first row in the fragment.
  ///
  /// An [EROFragment] has a row that we are dealing with, along with a scalar that affects the row.
  const factory ERO.sum(List<EROFragment<T>> fragment) = _SumERO;

  /// The row to which the change is being applied.
  int get changingRow;

  /// Returns the value of the matrix with the ERO applied at the `i`-th row in the `j`-th column.
  T getValue(Matrix<T> matrix, int i, int j);

  /// Validates that the ERO applies to the matrix.
  ///
  /// If not valid, an error is thrown.
  void validate(Matrix<T> matrix);

  /// Transforms an elementary row operation into a matrix of an `n` by `n` matrix.
  // SquareMatrix<T> toElementaryMatrix(int n);
}

class _ScaleERO<T extends num> extends ERO<T> {
  @override
  String toString() => scale.toString() + 'R_' + changingRow.toString();

  @override
  final int changingRow;

  /// The scale by which the row is being multiplied.
  final T scale;

  const _ScaleERO(this.changingRow, this.scale);

  @override
  void validate(Matrix<T> matrix) {
    ArgumentError.checkNotNull(changingRow, 'changingRow');
    // changing row must be between [0, matrix.m)
    RangeError.checkValueInInterval(
        changingRow, 0, matrix.m - 1, 'changingRow');
    ArgumentError.checkNotNull(scale, 'scale');
  }

  @override
  T getValue(Matrix<T> matrix, int i, int j) {
    if (i == changingRow) {
      return matrix.getValue(i, j) * scale;
    } else {
      return matrix.getValue(i, j);
    }
  }
}

class _SwapERO<T extends num> extends ERO<T> {
  @override
  String toString() =>
      'R_' + changingRow.toString() + ' <-> R_' + otherChangingRow.toString();

  @override
  final int changingRow;

  /// The other row with which the [changingRow] is being swapped.
  final int otherChangingRow;

  const _SwapERO(this.changingRow, this.otherChangingRow);

  @override
  void validate(Matrix<T> matrix) {
    ArgumentError.checkNotNull(changingRow, 'changingRow');
    // changing row must be between [0, matrix.m)
    RangeError.checkValueInInterval(
        changingRow, 0, matrix.m - 1, 'changingRow');
    ArgumentError.checkNotNull(otherChangingRow, 'otherChangingRow');
    // changing row must be between [0, matrix.m)
    RangeError.checkValueInInterval(
        otherChangingRow, 0, matrix.m - 1, 'otherChangingRow');
  }

  @override
  T getValue(Matrix<T> matrix, int i, int j) {
    if (i == changingRow) {
      return matrix.getValue(otherChangingRow, j);
    } else if (i == otherChangingRow) {
      return matrix.getValue(changingRow, j);
    } else {
      return matrix.getValue(i, j);
    }
  }
}

class _SumERO<T extends num> extends ERO<T> {
  @override
  String toString() {
    final buffer = StringBuffer(fragments[0]);
    for (var i = 1; i < fragments.length; i++) {
      final string = fragments[i].toString();
      if (!string.startsWith('-')) {
        buffer.write('+');
      }
      buffer.write(string);
    }
    return buffer.toString();
  }

  /// The fragments that make up the sum.
  final List<EROFragment<T>> fragments;

  @override
  int get changingRow => fragments.first.row;

  const _SumERO(this.fragments);

  @override
  void validate(Matrix<T> matrix) {
    if (fragments.length < 2) {
      throw StateError('The ERO has less than 2 rows!');
    }
    final rows = <int>{};
    for (var i = 0; i < fragments.length; i++) {
      if (fragments[i].row < 0 || fragments[i].row >= matrix.m) {
        throw StateError(
            'One of the ERO fragment isn\'t in the range of the matrix!');
      }
      if (!rows.add(fragments[i].row)) {
        throw StateError('One of the ERO rows appears twice on the list!');
      }
    }
  }

  @override
  T getValue(Matrix<T> matrix, int i, int j) {
    if (i == changingRow) {
      return fragments.fold<num>(
          0,
          (previousValue, element) =>
              previousValue + element.scalar * matrix.getValue(element.row, j));
    } else {
      return matrix.getValue(i, j);
    }
  }
}

/// Represents an elementary row operation fragment.
///
/// There are 2 properties here- the [row] we are operating on, the [scalar] at which this is being raised.
class EROFragment<T extends num> {
  /// The row which the ERO is about
  final int row;

  /// The scalar to which the ERO is being raised
  final T scalar;

  /// Creates an elementary row operation fragment.
  const EROFragment(this.row, this.scalar);

  @override
  String toString() => scalar.toString() + 'R_$row';
}
