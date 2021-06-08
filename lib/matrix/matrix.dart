part of '../vectors_and_matrices.dart';

/// The class matrix represents a 2D iterable of a class that extends `num`, i.e. `int` or `double`. It represents a mathematical matrix.
///
/// It extends an iterable collection of [Vector], which itself is an iterable collection of a `num` extension.
/// The vectors may be either [RowVector] or [ColVector], although the use of [RowVector] is more common and favoured whenever we have a choice.
///
/// This class is heavily based on the bare class iterable, as opposed to a list.
/// This implies that we don't expect to make `void` changes to any matrix.
/// The use of an iterable compensates for this heavily and is more efficient when making a lot of computations.
///
/// All of the methods/getters of a matrix are based on the following 5 properties that any concrete class must implement:
///
/// * the number of rows of the matrix, [m].
///
/// * the number of columns of the matrix, [n].
///
/// * getting a particular row from the matrix, [getRow].
///
/// * getting a particular column from the matrix, [getCol].
///
/// * getting a particular value from the matrix, [getValue].
///
/// On top of these 5 properties, we also expect the getters [iterator] and [length] to be overwritten,
/// depending on whether the iterable stores row or column vectors.
///
/// Therefore, these 2 getters must be used in one of the following way:
///
/// * If the matrix is an iterable collection of row vectors, the [iterator] should be [rowIterator], and the [length] should be [m], the number of rows.
///
/// * If the matrix is an iterable collection of column vectors, the [iterator] should be [colIterator], and the [length] should be [n], the number of columns.
///
/// The equality ([operator ==]) is modifed for a matrix such that two matrices are equal if they have the same list of row vectors.
abstract class Matrix<T extends num> extends Iterable<Vector<T>> {
  const Matrix();

  /// Generates an `m` times `n` matrix using the provided `generateFunction`.
  const factory Matrix.generate(
          int m, int n, T Function(int i, int j) generateFunction) =
      _GeneratedMatrix<T>;

  /// Generates an `m` times `n` matrix where all the entries are `fill`.
  const factory Matrix.filled(int m, int n, T fill) = _FilledMatrix<T>;

  /// Creates a matrix from a list of list.
  ///
  /// The internal lists are treated as row vectors.
  factory Matrix.fromRows(List<List<T>> value) {
    for (var i = 0; i < value.length; i++) {
      if (value[i].length != value.first.length) {
        throw StateError('The rows don\'t have the same size!');
      }
    }
    return _StandardRowMatrix(value);
  }

  /// Creates a matrix from a list of row vectors.
  factory Matrix.fromRowVectors(List<RowVector<T>> vectors) {
    for (var i = 0; i < vectors.length; i++) {
      if (vectors[i].length != vectors.first.length) {
        throw StateError('The rows don\'t have the same size!');
      }
    }
    return _FromRowVectorsMatrix(vectors.toList());
  }

  /// Creates a matrix from a list of row vectors.
  factory Matrix.fromColVectors(List<ColVector<T>> vectors) {
    for (var i = 0; i < vectors.length; i++) {
      if (vectors[i].length != vectors.first.length) {
        throw StateError('The columns don\'t have the same size!');
      }
    }
    return _FromColVectorsMatrix(vectors.toList());
  }

  /// The number of columns that a matrix has.
  ///
  /// We expect this to be calculated efficiently, i.e. either the value is already known, or can be calculated by the length of a list.
  int get n;

  /// The number of rows that a matrix has.
  ///
  /// We expect this to be calculated efficiently, i.e. either the value is already known, or can be calculated by the length of a list.
  int get m;

  /// Returns the `i`-th row from the matrix.
  RowVector<T> getRow(int i);

  /// Returns the `j`-th column from the matrix.
  ColVector<T> getCol(int j);

  /// Returns the value at the specified index.
  T getValue(int i, int j);

  @override
  String toString() {
    final buffer = StringBuffer('Matrix(');
    for (var i = 0; i < m; i++) {
      if (i == m - 1) {
        buffer.write(getRow(i).toList());
      } else {
        buffer.writeln(getRow(i).toList());
      }
    }
    buffer.write(')');
    return buffer.toString();
  }

  @override
  int get hashCode => IterableEquality().hash(toRowIterable());

  @override
  bool operator ==(covariant Matrix matrix) =>
      IterableEquality().equals(toRowIterable(), matrix.toRowIterable());

  /// Maps all the rows of this matrix by the function provided.
  ///
  /// The function has access to the row `vector`, along with the index at which the vector is.
  Matrix<V> mapRow<V extends num>(
          RowVector<V> Function(RowVector<T> vector, int i) fn) =>
      _RowMappedMatrix(this, fn);

  /// Maps all the cols of this matrix by the function provided.
  ///
  /// The function has access to the column `vector`, along with the index at which the vector is.
  Matrix<V> mapCol<V extends num>(
          ColVector<V> Function(ColVector<T> vector, int j) fn) =>
      _ColMappedMatrix(this, fn);

  /// Maps all the entries in the matrix by the provided function.
  ///
  /// The function has access to the `value` at the `i`-th row, `j`-th column, along with the `i` and `j` values themselves.
  Matrix<V> mapValue<V extends num>(V Function(T value, int i, int j) fn) =>
      _ValueMappedMatrix(this, fn);

  /// The iterator for this matrix that iterates via the rows.
  ///
  /// Every call of [rowIterator] returns a new iterator.
  Iterator<RowVector<T>> get rowIterator => _RowIterator(this);

  /// The iterator for this matrix that iterates via the columns.
  ///
  /// Every call of [colIterator] returns a new iterator.
  Iterator<ColVector<T>> get colIterator => _ColIterator(this);

  /// Returns this matrix as an iterable collection of row vectors.
  Iterable<RowVector<T>> toRowIterable() =>
      Iterable.generate(m, (i) => getRow(i));

  /// Returns this matrix as an iterable collection of column vectors.
  Iterable<ColVector<T>> toColIterable() =>
      Iterable.generate(n, (j) => getCol(j));

  /// Returns the matrix with integer entries.
  Matrix<int> toIntMatrix() => mapValue((value, i, j) => value.toInt());

  /// Returns the matrix with integer entries.
  Matrix<double> toDoubleMatrix() =>
      mapValue((value, i, j) => value.toDouble());

  /// Returns this matrix with the provided row `vector` to the end.
  Matrix<T> withRowBelow(RowVector<T> vector) {
    if (vector.length != n) {
      throw StateError(
          'The row vector is not the right size to the rows in the matrix!');
    }

    return _FollowedByRowMatrix(this, vector);
  }

  /// Returns this matrix with the other matrix below.
  Matrix<T> withMatrixBelow(Matrix<T> matrix) {
    if (matrix.n != n) {
      throw StateError('The matrices cannot be attached together!');
    }

    return _TwoMatricesCombinedWRTRow(this, matrix);
  }

  /// Returns this matrix with the provided column `vector` to the right.
  Matrix<T> withColToTheRight(ColVector<T> vector) {
    if (vector.length != m) {
      throw StateError(
          'The column vector is not the right size to the columns in the matrix!');
    }

    return _FollowedByColMatrix(this, vector);
  }

  /// Returns this matrix with the other matrix to the right.
  Matrix<T> withMatrixToTheRight(Matrix<T> matrix) {
    if (matrix.m != m) {
      throw StateError('The matrices cannot be attached together!');
    }

    return _TwoMatricesCombinedWRTColMatrix(this, matrix);
  }

  /// Returns this matrix with the provided row `vector` to the top.
  Matrix<T> withRowAbove(RowVector<T> vector) {
    if (vector.length != n) {
      throw StateError(
          'The row vector is not the right size to the other row vectors!');
    }

    return _PrecededByRowMatrix(this, vector);
  }

  /// Returns this matrix with the other matrix above.
  Matrix<T> withMatrixAbove(Matrix<T> matrix) {
    if (matrix.n != n) {
      throw StateError('The matrices cannot be attached together!');
    }

    return _TwoMatricesCombinedWRTRow(matrix, this);
  }

  /// Returns this matrix with the col `vector` to the left.
  Matrix<T> withColToTheLeft(ColVector<T> vector) {
    if (vector.length != m) {
      throw StateError(
          'The column vector is not the right size to the columns in the matrix!');
    }

    return _PrecededByColMatrix(this, vector);
  }

  /// Returns this matrix with the other matrix to the left.
  Matrix<T> withMatrixToTheLeft(Matrix<T> matrix) {
    if (matrix.m != m) {
      throw StateError('The matrices cannot be attached together!');
    }

    return _TwoMatricesCombinedWRTColMatrix(matrix, this);
  }

  /// Returns a subsection of this matrix.
  ///
  /// The `i1` and `i2` refer to the subrows in the matrix.
  /// The `j1` and `j2` refer to the subcolumns in the matrix.
  ///
  /// Leaving `i2` and `j2` will make the submatrix continue to the end of this matrix.
  Matrix<T> subMatrix(int i1, int j1, {int i2, int j2}) {
    ArgumentError.checkNotNull(i1, 'i1');
    i2 = RangeError.checkValidRange(i1, i2, m);
    ArgumentError.checkNotNull(i2, 'i2');
    j2 = RangeError.checkValidRange(j1, j2, n);

    return _SubMatrix(this, i1, i2, j1, j2);
  }

  /// Returns `true` if this the vector is found in the matrix.
  bool containsRow(RowVector<T> vector) {
    for (var i = 0; i < m; i++) {
      if (getRow(i) == vector) return true;
    }
    return false;
  }

  /// Returns `true` if the column vector is found in the matrix.
  bool containsCol(ColVector<T> vector) {
    for (var j = 0; j < n; j++) {
      if (getCol(j) == vector) return true;
    }
    return false;
  }

  /// Returns `true` if the matrix has an entry with the value.
  bool containsValue(T value) {
    for (var i = 0; i < m; i++) {
      for (var j = 0; j < n; j++) {
        if (getValue(i, j) == value) return true;
      }
    }
    return false;
  }

  /// Returns the first row of the matrix.
  ///
  /// If the matrix doesn't have any entries, throws an error.
  RowVector<T> get firstRow => getRow(0);

  /// Returns the first column of the matrix.
  ///
  /// If the matrix doesn't have any entries, throws an error.
  ColVector<T> get firstCol => getCol(0);

  /// Returns the last row of the matrix.
  ///
  /// If the matrix doesn't have any entries, throws an error.
  RowVector<T> get lastRow => getRow(m - 1);

  /// Returns the last column of the matrix.
  ///
  /// If the matrix doesn't have any entries, throws an error.
  ColVector<T> get lastCol => getCol(n - 1);

  /// Returns the index of the first row which returns true for the `fn` provided.
  ///
  /// If no index matches, returns -1.
  int firstIndexOfRowWhere(bool Function(RowVector<T> vector) fn) {
    for (var i = 0; i < m; i++) {
      if (fn(getRow(i))) return i;
    }
    return -1;
  }

  /// Returns the index of the last row which returns true for the `fn` provided.
  ///
  /// If no index matches, returns -1
  int lastIndexOfRowWhere(bool Function(RowVector<T> vector) fn) {
    for (var i = m - 1; i > -1; i--) {
      if (fn(getRow(i))) return i;
    }
    return -1;
  }

  /// Returns the index of the first column which returns true for the `fn` provided.
  ///
  /// If no index matches, returns -1.
  int firstIndexOfColWhere(bool Function(ColVector<T> vector) fn) {
    for (var j = 0; j < n; j++) {
      if (fn(getCol(j))) return j;
    }
    return -1;
  }

  /// Returns the index of the last column which returns true for the `fn` provided.
  ///
  /// If no index matches, returns -1
  int lastIndexOfColWhere(bool Function(ColVector<T> vector) fn) {
    for (var j = n - 1; j > -1; j--) {
      if (fn(getCol(j))) return j;
    }
    return -1;
  }

  /// Multiplies two matrices together.
  ///
  /// We expect the two matrices to be multiplication-compatible.
  Matrix<T> operator *(Matrix<T> matrix) {
    if (n != matrix.m) {
      throw StateError('The matrices cannot be multiplied!');
    }
    return _MultipliedMatrix(this, matrix);
  }

  /// Returns the transposed version of this matrix.
  Matrix<T> transpose() => _TransposedMatrix(this);

  /// Adds the content of this matrix with another one.
  Matrix<T> operator +(Matrix<T> matrix) {
    if (m != matrix.m || n != matrix.n) {
      throw StateError('The matrices cannot be added!');
    }
    return _SumMatrix(this, matrix);
  }

  /// Inverts the sign of all the entries within the matrix.
  Matrix<T> operator -() => mapValue((value, i, j) => -value);

  /// Subtracts the content of this matrix with another one.
  Matrix<T> operator -(Matrix<T> matrix) => this + (-matrix);

  /// Multiplies the content of this matrix with a scalar.
  Matrix<T> scalarMultiply(T scalar) =>
      mapValue((value, i, j) => value * scalar);

  /// Right multiplies this matrix with the column vector.
  ColVector<T> rightMultiplied(ColVector<T> vector) {
    if (n != vector.length) {
      throw StateError('The vector cannot be multiplied with the matrix!');
    }
    return _MultipliedWithColVector(this, vector);
  }

  /// Left multiplies this matrix with the row vector.
  RowVector<T> leftMultiplied(RowVector<T> vector) {
    if (m != vector.length) {
      throw StateError('The vector cannot be multiplied with the matrix!');
    }
    return _MultipliedWithRowVector(this, vector);
  }

  /// Operates an elementary row operation on the matrix.
  Matrix<T> operateERO(ERO<T> ero) {
    ero.validate(this);
    return _EROOperatedMatrix(this, ero);
  }

  int _sortRowsForREF(Vector<T> vector1, Vector<T> vector2) {
    final vector1Index = vector1.firstNonZeroIndex();
    if (vector1Index.isNull) return 1;
    final vector2Index = vector2.firstNonZeroIndex();
    if (vector2Index.isNull) return -1;
    return vector1Index.compareTo(vector2Index);
  }

  /// Reduces the matrix to row echelon form.
  Matrix<T> toREF() {
    // sort the matrix with respect to the first-non zero index
    List<RowVector<T>> content;
    var matrix = this;
    for (var i = 1; i < m; i++) {
      content = matrix.toRowIterable().toList();
      content = content.sublist(0, i) + content.sublist(i)
        ..sort(_sortRowsForREF);
      matrix = Matrix<T>.fromRowVectors(content);
      // find the first non-zero index in this row (note anything below this may have a zero in this col, but there cannot be any non-zero entry before this col)
      // that is because we sort before every iteration (partially).
      final col = matrix.getRow(i - 1).firstNonZeroIndex(i - 1);
      if (col.isNull) continue;
      for (var j = i; j < m; j++) {
        // only make the change if the value in concern isn't 0
        if (matrix.getValue(j, col) != 0) {
          final ero = ERO<T>.sum([
            EROFragment(j, matrix.getValue(i - 1, col)),
            EROFragment(i - 1, -matrix.getValue(j, col))
          ]);
          matrix = matrix.operateERO(ero);
        }
      }
    }
    return matrix;
  }

  /// Reduces the matrix to reduced row echelon form.
  Matrix<double> toRREF() {
    var matrix = toREF().toDoubleMatrix();
    for (var i = m - 1; i > 0; i--) {
      // try to locate the first non-zero entry here (index & value)
      final index = matrix.getRow(i).firstNonZeroIndex(i - 1);
      // if no nonZero entry, go to the next iteration (not break since the indices are flipped)
      if (index.isNull) continue;
      final value = matrix.getValue(i, index);
      if (value != null && value != 1) {
        matrix = matrix.operateERO(ERO.scale(i, 1 / value));
      }
      // if at this place, the rows above it have a non-zero entry, make it zero.
      for (var j = i; j > 0; j--) {
        final value = matrix.getValue(j - 1, index);
        if (value != 0) {
          final ero =
              ERO.sum([EROFragment(j - 1, 1.0), EROFragment(i, -value)]);
          matrix = matrix.operateERO(ero);
        }
      }
    }
    // scale down the first non-zero entry in the first row.
    final value = matrix.getRow(0).firstNonZeroValue();
    if (value != null && value != 1) {
      return matrix.operateERO(ERO.scale(0, 1 / value));
    }
    return matrix;
  }

  /// The rank of the matrix.
  ///
  /// This is calculating by counting the number of non-zero rows in the REF of the matrix.
  int get rank {
    final matrix = toREF();
    var zeroRows = 0;
    // since the REF places all the zero rows at the end, count from the bottom all the rows that are zero rows.
    // if any row has a non-zero entry, it won't have a zero row above it.
    while (matrix.getRow(m - 1 - zeroRows).firstNonZeroIndex().isNull) {
      zeroRows++;
    }
    return m - zeroRows;
  }

  /// The nullity of the matrix.
  ///
  /// This is calculated by subtracting the [rank] from the number of columns [n].
  int get nullity => n - rank;

  /// The column space of the matrix.
  ColSpan get colSpace => ColSpan.fromMatrix(this);

  /// The row space of the matrix.
  RowSpan get rowSpace => RowSpan.fromMatrix(this);

  /// The null space of the matrix.
  ///
  /// This is the complement span of the row space.
  ColSpan get nullSpace => rowSpace.complementSpan.toColSpan();

  /// Returns the top non-zero rows from the matrix.
  ///
  /// That is, any rows at the end that are zero row vectors will be skipped.
  Iterable<RowVector<T>> topNonZeroRows() {
    // find from the end the last row that has a non-zero entry
    final i = lastIndexOfRowWhere((vector) => vector.isNotZeroVector);
    return toRowIterable().take(i + 1);
  }

  T _intAsT(int i) {
    switch (T) {
      case double:
        return i.toDouble() as T;
      default:
        return i as T;
    }
  }

  /// Converts the matrix into a square matrix.
  /// 
  /// The values [m] and [n] must be the same for this to happen. Otherwise, a [StateError] is raised.
  SquareMatrix<T> toSquareMatrix() {
    if (m != n) {
      throw StateError('The matrix isn\'t a square matrix!');
    }
    return _ToSquareMatrix(this);
  }
}
