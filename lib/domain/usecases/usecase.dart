/// Clase base para cualquier Caso de Uso.
/// T es el tipo de dato que el caso de uso retornará (ej. List<Expense>).
/// P es el tipo de dato de los parámetros que el caso de uso recibirá (ej. Expense).
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Clase base para Casos de Uso que no retornan nada (void).
abstract class VoidUseCase<P> {
  Future<void> call(P params);
}