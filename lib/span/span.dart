part of '../vectors_and_matrices.dart';

/// The class span represents a set of vectors.
///
/// It has two concerte implementations, [RowSpan] and [ColSpan], depending on whether they carry [RowVector] or [ColVector].
///
/// Although the class acts as a `Set`, few of the properties inherited from the set have been modified. These are:
///
/// * the [contains] property, which check whether the vector lies in the span, not in the set of spanning vectors.
///
/// * the [intersection] property, which returns the intersection of two spans respectively.
///
/// * the [operator ==], which checks whether two spans are the same by computation, not by checking that they point to the same instance of the object.
///
/// Many of these properties rely on converting a span into a [Matrix].
///
/// There are other getters/properties on a span, such as:
///
/// * [toOrthogonalSpan] and [toOrthonormalSpan], which transform the span to form an orthogonal and an orthonormal basis for the spanning space.
///
/// * whether the span [isLinearlyIndependent].
///
/// * the [complementSpan] of the vectors.
///
/// Unlike the classes [Matrix] and [Vector], span doesn't allow for a wild-type. This means that both [int] and [double] components are treated as [num].
/// This is because a span contains both types of vectors.
abstract class Span<V extends Vector> extends DelegatingSet<V> {
  const Span(Set<V> spanningVectors) : super(spanningVectors);

  /// Returns `true` if the span is made up of column vectors.
  bool get containsColVectors;

  /// The length of the vectors present.
  int get vectorLength;

  /// Returns `true` if the vector provided is contained within this span.
  ///
  /// This is calculated by converting the span of vectors into a matrix and reducing it to REF.
  ///
  /// Then, we add the `vector` into the matrix, and perform EROs and try to make every non-zero entry in this vector zero.
  /// If possible, returns `true`. Otherwise, returns `false`.
  ///
  /// If the span is empty, returns `false`.
  @override
  bool contains(covariant V vector) {
    if (isEmpty) return false;
    if (vector.length != vectorLength) return false;
    var col = vector.firstNonZeroIndex();
    // if the vector has no non-zero elt, it's a zero vector. Since we have at least one vector in `this`, the zero vector is in the span.
    if (col == null) return true;
    var matrix = _matrixFromRowVectors;
    matrix = matrix.toREF();
    matrix = _withRowBelow(matrix, vector);
    var row = 0;
    // until we have no zeros in the final row (moving along the column), try to perform EROs to make the first non-zero entry zero.
    while (col != null) {
      // We know that the provided vector has a non-zero value @ index `i`.
      // Now, we aim to get rid of this value, by subtracting it with the final row w/ this value @ that index
      // So, we find the final row in the i-th col with non-zero entry (before the final one)
      final _row = matrix.getCol(col).lastNonZeroIndex(length - 1);
      // if the col doesn't have any non-zero entry, or the row containing the non-zero entry has already been subtracted, return false
      // if i isn't the first non-zero index in the selected row (i.e. there's sth before this val), return false
      if (_row == null ||
          _row < row ||
          matrix.getRow(_row).firstNonZeroIndex() != col) return false;
      // else, subtract a row from the matrix => the last row with non-zero entry in this row
      row = _row;
      // find the
      final ero = ERO.sum([
        EROFragment(length, matrix.getValue(row, col)),
        EROFragment(row, -matrix.getValue(length, col))
      ]);
      matrix = matrix.operateERO(ero);
      // we must move at least one row downward following the iteration
      row++;
      // just in case the value doesn't get fully taken down to zero (rounding error, e.g. 1e-16, not 0)
      col = matrix.getRow(length).firstNonZeroIndex(col + 1);
    }
    return true;
  }

  /// The equality operator.
  ///
  /// A column span can only equal a column span, and a row span can only equal a row span.
  ///
  /// To determine whether two spans are equal, we transform them into matrices and check whether they are row equivalent.
  /// This is done by equating their RREFs.
  @override
  bool operator ==(covariant Span<V> object);

  Iterable<RowVector> get _matrixForOrthogonality {
    var matrix = _matrixFromRowVectors;
    matrix = matrix.withMatrixToTheLeft(matrix * matrix.transpose()).toREF();
    matrix = matrix.subMatrix(0, length);
    return matrix.toRowIterable().where((vector) => vector.isNotZeroVector);
  }

  /// Returns a new span where all the vectors present in the span are mutually orthogonal.
  ///
  /// If the set is linearly dependent, the redundant vectors are removed.
  ///
  /// This is calculated by converting the span into a matrix with row vectors as the vectors from the span. Call this matrix `A`.
  /// We then form the matrix `[AA^T|A]`, reduce it to REF and make a span out of the non-zero row vectors from the right side fo the matrix.
  /// 
  /// The Gram-Schmidt version of this is [orthogonalByGramSchmidt].
  Span toOrthogonalSpan();

  /// Returns a new span where all the vectors present in the span are mutually orthogonal.
  ///
  /// The vectors are also unit vectors.
  ///
  /// Any redundant vector gets removed.
  Span toOrthonormalSpan();

  Iterable<RowVector<T>> _topNonZeroRows<T extends num>(Matrix<T> matrix) {
    final i = matrix.lastIndexOfRowWhere((vector) => vector.isNotZeroVector);
    return matrix.toRowIterable().take(i + 1);
  }

  List<List<double>> get _orthogonalVectorsAsList {
    final matrix = _matrixFromRowVectors.toRREF();
    // no of vectors is vectorLength - 1 - dimension
    final numberOfVectors = vectorLength -
        1 -
        matrix.lastIndexOfRowWhere((vector) => vector.isNotZeroVector);
    if (numberOfVectors == 0) return [];
    final vectors = List.generate(
        numberOfVectors, (index) => List<double>.filled(vectorLength, null));
    final trailing = <int>[];
    final nonTrailing = <int>[];
    var count = 0;
    for (var i = 0; i < vectorLength; i++) {
      final col = matrix.getCol(i);
      // figure out if this row contains a trailing one
      // the first and the last non-zero index in this column is the same, not null, and this is the first non-zero index in this row.
      final index = col.firstNonZeroIndex();
      final hasTrailingOne = index != null &&
          index == col.lastNonZeroIndex() &&
          matrix.getRow(index).firstNonZeroIndex() == i;
      if (hasTrailingOne) {
        trailing.add(i);
      } else {
        // add either 0 or 1, depending on the ## of non-zero ones already added
        for (var j = 0; j < numberOfVectors; j++) {
          vectors[j][i] = count == j ? 1.0 : 0.0;
        }
        nonTrailing.add(i);
        count++;
      }
    }
    // loop again, only on the nonTrailing indices, and add the values from the trailing indices
    for (var i = 0; i < nonTrailing.length; i++) {
      for (var j = 0; j < trailing.length; j++) {
        vectors[i][trailing[j]] = -(matrix.getValue(j, nonTrailing[i]));
      }
    }
    return vectors;
  }

  /// Returns the complement of this span.
  ///
  /// This is calculated by converting the span into a matrix made up of rows using the span. Then, we find the RREF of the matrix, and add appropriate numbers
  /// using the RREF to get all the vectors.
  ///
  /// The vectors may not be orthogonal or normal, but they are linearly independent.
  Span<V> get complementSpan;

  @override
  bool add(V vector) {
    ArgumentError.checkNotNull(vector, 'vector');
    if (vector.length != vectorLength) {
      throw StateError('Incompatible vector to be added!');
    }
    return super.add(vector);
  }

  /// The dimension of the span.
  ///
  /// It is calculated by converting the span into a matrix, and calculating the rank of that matrix.
  int get dimension => toMatrix().rank;

  /// Returns `true` if the set of vectors is linearly independent.
  ///
  /// This is calculated in the following way:
  ///
  /// * If the [length] of the span is greater than the length of the vectors, [vectorLength], returns `false`.
  ///
  /// * If the [length] of the span is 0, returns `true`.
  ///
  /// * If the [length] of the span is 1, returns `true` if the single vector is not the zero vector.
  ///
  /// * If the [length] of the span is 2, returns `true` if one vector is a multiple of the other.
  ///
  /// * In any other case, we check whether the [dimension] of the span is equal to the [length] of the span.
  bool get isLinearlyIndependent {
    if (length > vectorLength) return false;
    switch (length) {
      case 0:
        return true;
      case 1:
        return single.isNotZeroVector;
      case 2:
        final it = iterator;
        it.moveNext();
        final first = it.current;
        it.moveNext();
        final second = it.current;
        return !first.isMultipleOf(second);
      default:
        final matrix = _matrixFromRowVectors.toREF();
        return matrix.lastRow.lastNonZeroIndex() != null;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('Span(');
    final content = toList();
    for (var i = 0; i < content.length; i++) {
      buffer.write(content[i].toList());
      if (i != content.length - 1) {
        buffer.writeln(',');
      }
    }
    buffer.write(')');
    return buffer.toString();
  }

  Matrix get _matrixFromRowVectors;

  Matrix get _matrixFromColVectors;

  Matrix _withRowBelow(Matrix matrix, V vector);

  Set<Vector<double>> get _fromRREF {
    final matrix = _matrixFromRowVectors.toRREF();
    return _topNonZeroRows(matrix).toSet();
  }

  @override
  int get hashCode => SetEquality().hash(_fromRREF);

  /// Converts a span into a matrix.
  ///
  /// Respects the vector type, i.e. keeps row vectors as row vectors, and column vectors as column vectors.
  Matrix toMatrix();

  /// Returns this span as a column space.
  ColSpan toColSpan() =>
      ColSpan._(map((vector) => vector.toColVector()).toSet(), vectorLength);

  /// Returns this span as a row space.
  RowSpan toRowSpan() =>
      RowSpan._(map((vector) => vector.toRowVector()).toSet(), vectorLength);

  /// Returns the intersection of 2 spans.
  ///
  /// We expect the [vectorLength] of the provided `span` to be the same as the [vectorLength] of `this` span.
  ///
  /// If either of the two spans has no vectors, an empty span is returned. Otherwise, we compute the intersection in the following way:
  ///
  /// * Make a matrix with column vectors as the vectors from this span, add the matrix with column vectors as the negative vectors of the provided span to the right.
  ///
  /// * Compute the nullspace of that matrix.
  ///
  /// * For all the vectors in the nullspace, multiply the vectors of the vector at `i`-th position of this span by `vector[i]` and add them.
  ///  This vector will be in the intersection.
  @override
  Span<V> intersection(covariant Span<V> span);

  List<List<double>> _calculateIntersectionVectors(Span<V> span) {
    if (span.vectorLength != vectorLength) {
      throw StateError('The spans cannot be intersected!');
    }
    if (isEmpty || span.isEmpty) return [];
    final matrix = _matrixFromColVectors
        .withMatrixToTheRight(-(span._matrixFromColVectors));
    final nullSpace = matrix.nullSpace;
    final list = <List<double>>[];
    for (final vector in nullSpace) {
      final it = iterator;
      it.moveNext();
      var intersectionVector =
          it.current.toDoubleVector() * vector[0].toDouble();
      var i = 1;
      while (it.moveNext()) {
        intersectionVector +=
            it.current.toDoubleVector() * vector[i].toDouble();
        i++;
      }
      if (intersectionVector.isNotZeroVector) {
        list.add(intersectionVector.toList());
      }
    }
    return list;
  }

  /// Returns the span as an orthogonal one by applying gram schmidt process.
  /// 
  /// This returns an orthogonal basis to the spanning subspace.
  /// 
  /// The non-Gram schmidt version of this method is [toOrthogonalSpan()]
  Span<V> toOrthogonalSpanByGramSchmidt();
  
  Set<V> _applyGramSchmidt() {
    final orthogonalSpan = <V>{};
    for (final vector in this) {
      var vectorToAdd = vector.toDoubleVector();
      for (final vectorInSpan in orthogonalSpan) {
        vectorToAdd -= vectorToAdd.projectOnto(vectorInSpan as Vector<double>);
      }
      if (vectorToAdd.isNotZeroVector) {
        orthogonalSpan.add(vectorToAdd as V);
      }
    }
    return orthogonalSpan;
  }
}
