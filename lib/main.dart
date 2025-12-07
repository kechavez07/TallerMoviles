/*
 * Archivo: main.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es el PUNTO DE ENTRADA de la aplicación y el COMPOSITION ROOT donde se realiza la
 * inyección manual de dependencias. Aquí se ensamblan todas las capas de la arquitectura
 * siguiendo el flujo de dependencias correcto.
 * 
 * Cómo interactúa con otros archivos:
 * - Instancia LocalExpenseDataSource
 * - Crea ExpenseRepositoryImpl inyectando el data source
 * - Crea todos los casos de uso inyectando el repositorio
 * - Crea ExpenseProvider inyectando los casos de uso
 * - Configura MaterialApp con MultiProvider
 * - Establece ExpenseListScreen como pantalla inicial
 * 
 * Descripción del código:
 * El archivo main.dart implementa el patrón de Composición de Dependencias siguiendo
 * el flujo de Clean Architecture desde dentro hacia afuera. La función main construye
 * la cadena de dependencias en orden: primero instancia LocalExpenseDataSource (capa de
 * datos más interna), luego crea ExpenseRepositoryImpl pasándole el data source, después
 * instancia los cuatro casos de uso inyectando el repositorio en cada uno, y finalmente
 * ejecuta la aplicación pasando estos casos de uso a MyApp. La clase MyApp recibe los
 * casos de uso como parámetros y usa MultiProvider para proporcionar el ExpenseProvider
 * a todo el árbol de widgets.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar todas las dependencias
import 'data/data_sources/local_expense_data_source.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'domain/usecases/expense_usecases/get_expenses_usecase.dart';
import 'domain/usecases/expense_usecases/update_expense_usecase.dart';
import 'domain/usecases/expense_usecases/delete_expense_usecase.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/screens/expense_list_screen.dart';

/// Punto de entrada de la aplicación
/// 
/// Esta función inicializa todas las dependencias siguiendo el principio de
/// Inversión de Dependencias de Clean Architecture.
void main() {
  // === COMPOSICIÓN DE DEPENDENCIAS (Dependency Injection Manual) ===
  
  // 1. Inicializar Data Source (La capa más interna - Acceso a datos)
  final localDataSource = LocalExpenseDataSource();
  
  // 2. Inicializar Repositorio (Implementación que conecta dominio con datos)
  // Se inyecta el data source al repositorio
  final expenseRepository = ExpenseRepositoryImpl(localDataSource: localDataSource);

  // 3. Inicializar Casos de Uso (Lógica de negocio - Dependen del Repositorio)
  // Cada caso de uso recibe el repositorio como dependencia
  final addExpenseUseCase = AddExpenseUseCase(expenseRepository);
  final getExpensesUseCase = GetExpensesUseCase(expenseRepository);
  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepository);
  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository);

  // 4. Inicializar la Aplicación con los Casos de Uso inyectados
  runApp(MyApp(
    addExpenseUseCase: addExpenseUseCase,
    getExpensesUseCase: getExpensesUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
  ));
}

/// Widget raíz de la aplicación
/// 
/// Esta clase recibe todos los casos de uso como parámetros y configura
/// el Provider para toda la aplicación.
class MyApp extends StatelessWidget {
  // === CASOS DE USO INYECTADOS ===
  
  /// Caso de uso para agregar gastos
  final AddExpenseUseCase addExpenseUseCase;
  
  /// Caso de uso para obtener gastos
  final GetExpensesUseCase getExpensesUseCase;
  
  /// Caso de uso para actualizar gastos
  final UpdateExpenseUseCase updateExpenseUseCase;
  
  /// Caso de uso para eliminar gastos
  final DeleteExpenseUseCase deleteExpenseUseCase;

  /// Constructor que recibe todos los casos de uso
  /// 
  /// Parámetros:
  /// - [addExpenseUseCase]: Caso de uso para agregar
  /// - [getExpensesUseCase]: Caso de uso para obtener
  /// - [updateExpenseUseCase]: Caso de uso para actualizar
  /// - [deleteExpenseUseCase]: Caso de uso para eliminar
  const MyApp({
    super.key,
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  /// Construye el árbol de widgets de la aplicación
  /// 
  /// Configura el Provider y el MaterialApp con el tema y la pantalla inicial.
  /// 
  /// Parámetros:
  /// - [context]: El BuildContext proporcionado por Flutter
  /// 
  /// Retorna: El widget raíz de la aplicación
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 5. Proporcionar el ExpenseProvider a todo el árbol de widgets
        // El provider depende de los Casos de Uso
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(
            addExpenseUseCase: addExpenseUseCase,
            getExpensesUseCase: getExpensesUseCase,
            updateExpenseUseCase: updateExpenseUseCase,
            deleteExpenseUseCase: deleteExpenseUseCase,
          )..loadExpenses(), // Llama a loadExpenses al iniciar usando sintaxis de cascada
        ),
      ],
      child: MaterialApp(
        title: 'Registro y control de Gastos',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const ExpenseListScreen(), // Pantalla principal de la aplicación
      ),
    );
  }
}