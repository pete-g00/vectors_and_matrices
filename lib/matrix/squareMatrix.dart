part of '../vectors_and_matrices.dart';

/// The class SquareMatrix represents a square matrix.
/// 
/// The difference between [Matrix] and square matrix is that the dimensions [m] and [n] are equal. 
/// This further implies that there is only one choice for [length]. We set [m] to equal [n], and let [n] be defined on a concrete class.
/// 
/// Like matrix, the class square matrix is based on the following 4 properties:
/// 
/// * the number of rows and columns in the matrix, [n].
/// 
/// * getting a particular column from the matrix, [getCol].
/// 
/// * getting a particular row from the matrix, [getRow].
/// 
/// * getting a particular value from the matrix, [getValue].
/// 
/// We also need to define the [iterator], which is either the [rowIterator] or the [colIterator].
/// 
/// Along with properties defined on a matrix, a square matrix has other properties, such as:
/// 
/// * the getter [determinant],
/// 
/// * the getter [isInvertible],
/// 
/// * the property [invert], and
/// 
/// * the value [operator ^].
abstract class SquareMatrix<T extends num> extends Matrix<T>{
  const SquareMatrix();

  /// Generates an `n` by `n` matrix using the provided `generateFunction`.
  const factory SquareMatrix.generate(int n, T Function(int i, int j) generateFunction) = _GeneratedSquareMatrix;

  /// Generates an `n` by `n` matrix where all the entries are `fill`.
  const factory SquareMatrix.filled(int n, T fill) = _FilledSquareMatrix;

  /// Generates an `n` by `n` matrix with diagonal entries as the ones provided.
  const factory SquareMatrix.diagonal(List<T> diagonalEntries) = _DiagonalMatrix;

  /// Generates an `n` by `n` matrix with diagonal entries as the `scalar` provided
  const factory SquareMatrix.scalar(int n, T scalar) = _ScalarMatrix;

  /// Generates an `n` by `n` identity matrix.
  static SquareMatrix<int> identity(int n) => SquareMatrix.scalar(n, 1);

  /// Creates a square matrix from a list of entries.
  /// 
  /// The internal lists are treated as row vectors.
  factory SquareMatrix.fromRows(List<List<T>> value){
    for (var i = 0; i < value.length; i++) {
      if (value[i].length != value.length){
        throw StateError('The length of all the rows and the columns isn\'t the same!');
      }
    }
    return _StandardSquareRowMatrix(value);
  }

  // factory SquareMatrix.fromCols

  /// Creates a square matrix from a list of row vectors.
  factory SquareMatrix.fromRowVectors(List<RowVector<T>> vectors){
    for (var i = 0; i < vectors.length; i++) {
      if (vectors[i].length != vectors.first.length){
        throw StateError('The rows don\'t have the same size!');
      }
    }
    return _FromRowVectorsSquareMatrix(vectors.toList());
  }

  /// Creates a square matrix from a list of row vectors.
  factory SquareMatrix.fromColVectors(List<ColVector<T>> value){
    for (var i = 0; i < value.length; i++) {
      if (value[i].length != value.length){
        throw StateError('The length of all the rows and the columns isn\'t the same!');
      }
    }
    return _FromColVectorsSquareMatrix(value);
  }

  static SquareMatrix<double> fromDiagonalised(SquareMatrix<double> invertibleMatrix, SquareMatrix<double> diagonalMatrix) => 
    _ToSquareMatrix(invertibleMatrix * diagonalMatrix * invertibleMatrix.invert());

  @override
  int get m => n;

  @override
  int get length => n;

  @override  
  SquareMatrix<T> transpose() => _ToSquareMatrix(super.transpose());

  @override  
  SquareMatrix<T> operator +(Matrix<T> matrix) => _ToSquareMatrix(super + matrix);

  @override  
  SquareMatrix<T> operator -() => _ToSquareMatrix(-super);

  @override
  SquareMatrix<T> operator -(Matrix<T> matrix) => this + (-matrix);

  @override
  SquareMatrix<T> scalarMultiply(T scalar) => _ToSquareMatrix(super.scalarMultiply(scalar));

  @override
  SquareMatrix<T> operateERO(ERO<T> ero) => _ToSquareMatrix(super.operateERO(ero));

  @override
  SquareMatrix<T> toREF() => super.toREF().toSquareMatrix();

  @override
  SquareMatrix<double> toRREF() => super.toRREF().toSquareMatrix();

  /// Returns `true` if this matrix can be inverted.
  /// 
  /// This is calculated by checking whether the [rank] is equal to the size of the matrix, [n]. 
  bool get isInvertible => rank == n;

  /// The determinant of the square matrix.
  /// 
  /// We calculate it as follows:
  /// 
  /// * If the matrix is a `0` by `0` matrix, return `0`.
  /// 
  /// * If the matrix is a `1` by `1` matrix, return the sole value present.
  /// 
  /// * If the matrix is a `2` by `2` matrix, return the determinant by the base case of Laplace expansion.
  /// 
  /// * For a matrix of higher `n`, calculate the row echelon form, keeping track of the elementary row operations performed.
  ///   If the final row of the matrix is a zero row, return `0`. Otherwise, multiply the diagonal values and multiply the product by the scalar corresponding to
  ///   each elementary row operation.
  T get determinant{
    switch (n) {
      case 0:
        return _intAsT(0);
      case 1:
        return getValue(0, 0);
      case 2:
        return getValue(0, 0) * getValue(1, 1) - getValue(0, 1) * getValue(1, 0);
      default:
        var scalar = 1.0;
        List<RowVector<T>> content;
        Matrix<T> matrix = this;
        for (var i = 1; i < m; i++) {
          content = matrix.toRowIterable().toList();
          content = content.sublist(0, i) + content.sublist(i)..sort((vector1, vector2){
            final compare = _sortRowsForREF(vector1, vector2);
            // swapping 2 rows if compare == 1
            if (compare == 1){
              scalar = -scalar;
            }
            return compare;
          });
          matrix = Matrix<T>.fromRowVectors(content);
          final col = matrix.getRow(i-1).firstNonZeroIndex(i-1);
          // if no col, no non-zero entry left (TODO: might as well return 0)
          if (col == null) break;
          for (var j = i; j < m; j++) {
            // only make the change if the value in concern isn't 0
            if (matrix.getValue(j, col) != 0){
              final value = matrix.getValue(i-1, col);
              final ero = ERO<T>.sum([EROFragment(j, value), EROFragment(i-1, -matrix.getValue(j, col))]);
              scalar *= 1/value;
              matrix = matrix.operateERO(ero);
            }
          }
        }
        // if the final row is all 0, return 0 (we know any entry before the final one in that row must be 0); the matrix isn't invertible
        if (matrix.getValue(n-1, n-1) == 0) return _intAsT(0);
        for (var i = 0; i < n; i++) {
          scalar *= matrix.getValue(i, i); 
        }
        // assumption: int won't be contaminated into a double (true since determinant calc can also be represented as multiplication)
        // nonetheless, we may round into .99999.. when dealing with a double, so double.round() used instead of double.toInt().
        return T == double ? scalar as T : scalar.round() as T;
    }
  }

  /// Returns the inverse of this matrix.
  /// 
  /// If the matrix isn't invertible, returns `null`.
  /// 
  /// This is calculated by attaching the `n` by `n` identity matrix to the right, reducing the matrix to RREF and returning 
  /// a submatrix, starting from the `n`-th column.
  SquareMatrix<double> invert(){
    final withIdentity = withMatrixToTheRight(_ScalarMatrix(n, _intAsT(1)));
    final reduced = withIdentity.toRREF();
    // if matrix.getValue(n-1, n-1) == 0 & not 1, return null (couldn't reduce to identity), else return the other side
    return reduced.getValue(n-1, n-1) == 0 ? null :  _ToSquareMatrix(reduced.subMatrix(0, n));
  }

  static SquareMatrix<double> _raiseToPower(SquareMatrix<double> matrix, int i) {
    final multiples = [matrix];
    var power = 2;
    while (power <= i) {
      multiples.add(_ToSquareMatrix(multiples.last * multiples.last));
      power *= 2;
    }
    Matrix<double> mulitpliedMatrix = _ScalarMatrix(matrix.n, 1.0);
    for (var j = multiples.length-1; j >= 0; j--) {
      if (i >= pow(2, j)) {
        mulitpliedMatrix *= multiples[j];
        i -= pow(2, j);
      }
    }
    return _ToSquareMatrix(mulitpliedMatrix);
  }

  /// Raises the matrix to the `i`-th power.
  /// 
  /// * If `i` is 0, the `n` by `n` identity matrix is returned.
  /// 
  /// * If `i` is positive, the matrix is multiplied `i` times.
  /// 
  /// * If `i` is negative, the inverted matrix is multiplied `-i` times. If not invertible, an error is raised.
  SquareMatrix<double> operator ^(int i){
    if (i == 0){
      // return the identity matrix
      return SquareMatrix.scalar(n, 1.0);
    } else if (i > 0){
      return _raiseToPower(toDoubleMatrix(), i);
    } else {
      Matrix<double> matrix = invert();
      if (matrix == null){
        throw StateError('The matrix isn\'t invertible!');
      }
      return _raiseToPower(matrix, -i);
    }
  }

  // /// Returns the eigenvalues of the matrix.
  // Set<Eigenvalue> get eigenvalues;

  /// Returns the eigenspace for a particular eigenvalue of the matrix.
  ///
  /// This is done by calculating the null space of this matrix with the eigenvalue scalar matrix subtracted.
  /// 
  /// If the provided `eigenvalue` isn't an actual eigenvalue, throws an error.
  ColSpan eigenspaceFor(double eigenvalue){
    final matrix = toDoubleMatrix() - _ScalarMatrix(n, eigenvalue);
    final space = matrix.nullSpace;
    if (space.isEmpty){
      throw StateError('The value $eigenvalue isn\'t an eigenvalue for the matrix!');
    }
    return space;
  }

  /// Returns `true` if the provided eigenvalue is an eigenvalue of the matrix
  bool isEigenvalue(double eigenvalue) {
    final matrix = toDoubleMatrix() - _ScalarMatrix(n, eigenvalue);
    final space = matrix.nullSpace;
    return space.isNotEmpty;
  }

  /// Returns `true` if the provided eigenvector is an eigenvector of the matrix
  bool isEigenvector(ColVector<T> eigenvector) {
    final matrixMultiplied = rightMultiplied(eigenvector);
    if (eigenvector.isEmpty) return true;
    // find the quotient of the first value
    final multiple = matrixMultiplied.first / eigenvector.first;
    for (var i = 1; i < eigenvector.length; i++) {
      if (matrixMultiplied[i] / eigenvector[i] != multiple) {
        return false;
      }
    }
    return true;
  }
  
  /// Returns the eigenvalue corresponding to the eigenvector.
  double eigenvalueFor(ColVector<T> eigenvector) {
    final matrixMultiplied = rightMultiplied(eigenvector);
    if (eigenvector.isEmpty) return 0.0;
    // find the quotient of the first value
    final multiple = (matrixMultiplied.first / eigenvector.first).toDouble();
    for (var i = 1; i < eigenvector.length; i++) {
      if (matrixMultiplied[i] / eigenvector[i] != multiple) {
        throw StateError('The vector isn\'t an eigenvector!');
      }
    }
    return multiple;
  }

  // /// Returns `true` if the matrix is diagonalisable.
  // /// 
  // /// This is determined by checking that the algebraic multiplicity and the geometric multiplicity of all the eigenvalues is the same.
  // bool get isDiagonalisable => eigenvalues.every((value) => value.algebraicMultiplicity == value.geometricMultiplicity);

  /// Returns `true` if this matrix is similar to the provided `similarToMatrix`, with respect to the `similarByMatrix`.
  bool isSimilarTo(SquareMatrix<double> similarToMatrix, SquareMatrix<double> similarByMatrix){
    return similarByMatrix.isInvertible && 
      similarByMatrix * toDoubleMatrix() == similarToMatrix * similarByMatrix;
  }

  @override
  Matrix<double> toDoubleMatrix() => super.toDoubleMatrix().toSquareMatrix();
}