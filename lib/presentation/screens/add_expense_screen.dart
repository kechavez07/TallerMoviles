/*
 * Archivo: add_expense_screen.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es la PANTALLA DE FORMULARIO para agregar nuevos gastos. Pertenece a la capa de
 * presentación y maneja la captura de datos del usuario.
 * 
 * Cómo interactúa con otros archivos:
 * - Consume ExpenseProvider usando Provider.of con listen: false
 * - Llama al método addExpense del provider al enviar el formulario
 * - Usa controladores de TextField para capturar input del usuario
 * - Se cierra automáticamente después de guardar
 * 
 * Descripción del código:
 * La clase AddExpenseScreen es un widget con estado (StatefulWidget) que implementa un
 * formulario para capturar datos de un nuevo gasto. Mantiene estado local con controladores
 * de texto para descripción y monto, una fecha seleccionada inicialmente en DateTime.now(),
 * y una categoría con valor predeterminado 'Comida'. El método _presentDatePicker muestra
 * un selector de fecha nativo. El método _submitData valida que los datos ingresados sean
 * correctos, muestra un diálogo de error si la validación falla, y si pasa, usa Provider.of
 * con listen: false para llamar a addExpense del provider. El método dispose libera los
 * controladores para evitar memory leaks.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_session/presentation/providers/expense_provider.dart';

/// Pantalla de formulario para agregar un nuevo gasto
/// 
/// Esta pantalla captura los datos necesarios para crear un gasto.
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // === CONTROLADORES Y ESTADO LOCAL ===
  
  /// Controlador para el campo de texto de descripción
  final _descriptionController = TextEditingController();
  
  /// Controlador para el campo de texto de monto
  final _amountController = TextEditingController();
  
  /// Fecha seleccionada para el gasto (por defecto hoy)
  DateTime _selectedDate = DateTime.now();
  
  /// Categoría seleccionada para el gasto (por defecto 'Comida')
  String _selectedCategory = 'Comida';
  
  /// Lista de categorías disponibles
  final List<String> _categories = ['Comida', 'Transporte', 'Servicios', 'Otros'];

  /// Muestra el selector de fecha nativo
  /// 
  /// Permite al usuario seleccionar una fecha entre hace un año y hoy.
  /// Actualiza _selectedDate con la fecha seleccionada.
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Valida y envía los datos del formulario
  /// 
  /// Este método realiza las siguientes operaciones:
  /// 1. Valida que el monto sea un número válido y mayor a 0
  /// 2. Valida que la descripción no esté vacía
  /// 3. Muestra un diálogo de error si las validaciones fallan
  /// 4. Llama al método addExpense del provider si todo es válido
  /// 5. Cierra la pantalla después de guardar
  void _submitData() {
    // Intenta convertir el texto del monto a un número decimal
    final enteredAmount = double.tryParse(_amountController.text);
    
    // Valida que el monto sea válido (no nulo y mayor a 0)
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // Valida que la descripción no esté vacía
    if (_descriptionController.text.trim().isEmpty || amountIsInvalid) {
      // Muestra un diálogo de error si las validaciones fallan
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Entrada Inválida'),
          content: const Text('Asegúrate de ingresar una descripción y un monto válido (> 0).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Llama al Provider usando .read para no reconstruir el widget
    // listen: false evita que este widget se reconstruya cuando el provider cambie
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
      description: _descriptionController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    // Cierra la pantalla y regresa a la pantalla anterior
    Navigator.of(context).pop();
  }

  /// Libera los recursos de los controladores cuando el widget se destruye
  /// 
  /// Este método es importante para evitar memory leaks.
  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Construye la interfaz de usuario del formulario
  /// 
  /// Retorna: Scaffold con el formulario de captura de datos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nuevo Gasto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLength: 50,
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Fecha Seleccionada: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Guardar Gasto'),
            ),
          ],
        ),
      ),
    );
  }
}