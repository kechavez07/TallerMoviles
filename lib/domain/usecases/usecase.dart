/*
 * Archivo: usecase.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Este archivo define las CLASES BASE GENÉRICAS para todos los Casos de Uso del sistema.
 * En Clean Architecture, los casos de uso encapsulan la lógica de aplicación específica
 * y orquestan el flujo de datos entre entidades y repositorios.
 * 
 * Cómo interactúa con otros archivos:
 * - Es extendida por todos los casos de uso específicos del sistema
 * - Proporciona una estructura uniforme para implementar casos de uso
 * - Define el patrón común de entrada/salida para todos los casos de uso
 * 
 * Descripción del código:
 * Se definen dos clases abstractas genéricas: UseCase<T, P> para casos de uso que retornan
 * un valor de tipo T y reciben parámetros de tipo P, y VoidUseCase<P> para casos de uso
 * que no retornan nada pero reciben parámetros. Ambas clases definen un método call que
 * retorna un Future, estableciendo el patrón de que todos los casos de uso son operaciones
 * asincrónicas invocables mediante la sintaxis de llamada de función.
 */

/// Clase base para cualquier Caso de Uso que retorna un valor.
/// 
/// Parámetros genéricos:
/// - T: El tipo de dato que el caso de uso retornará (ej. List<Expense>)
/// - P: El tipo de dato de los parámetros que el caso de uso recibirá (ej. Expense)
/// 
/// El método call permite invocar el caso de uso como si fuera una función.
abstract class UseCase<T, P> {
  /// Ejecuta el caso de uso con los parámetros proporcionados
  /// 
  /// Parámetros:
  /// - [params]: Los parámetros necesarios para ejecutar el caso de uso
  /// 
  /// Retorna: Future<T> con el resultado de la operación
  Future<T> call(P params);
}

/// Clase base para Casos de Uso que no retornan nada (void).
/// 
/// Parámetro genérico:
/// - P: El tipo de dato de los parámetros que el caso de uso recibirá
/// 
/// Útil para operaciones como agregar, actualizar o eliminar donde solo
/// se necesita confirmación de éxito mediante el Future.
abstract class VoidUseCase<P> {
  /// Ejecuta el caso de uso con los parámetros proporcionados
  /// 
  /// Parámetros:
  /// - [params]: Los parámetros necesarios para ejecutar el caso de uso
  /// 
  /// Retorna: Future<void> que completa cuando la operación termina
  Future<void> call(P params);
}