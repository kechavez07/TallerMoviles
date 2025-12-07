/*
 * Archivo: edit_expense_screen.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es la PANTALLA DE FORMULARIO para editar gastos existentes. Pertenece a la capa de
 * presentación y maneja la modificación de datos del usuario.
 * 
 * Cómo interactúa con otros archivos:
 * - Consume ExpenseProvider usando Provider.of con listen: false
 * - Llama al método updateExpense del provider al enviar el formulario
 * - Recibe un objeto Expense existente para pre-llenar el formulario
 * - Usa controladores de TextField para capturar input del usuario
 * - Se cierra automáticamente después de guardar
 * 
 * Descripción del código:
 * La clase EditExpenseScreen es un widget con estado (StatefulWidget) que implementa un
 * formulario para editar datos de un gasto existente. Similar a AddExpenseScreen pero
 * pre-llena los campos con los datos del gasto a editar. Mantiene estado local con
 * controladores de texto para descripción y monto, la fecha y categoría del gasto original.
 * El método _submitData valida que los datos ingresados sean correctos y usa el método
 * copyWith de Expense para crear una nueva instancia con los datos actualizados.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/presentation/providers/expense_provider.dart';

/// Pantalla de formulario para editar un gasto existente
/// 
/// Esta pantalla recibe un gasto y permite modificar sus datos.
class EditExpenseScreen extends StatefulWidget {
  /// El gasto a editar
  final Expense expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  // === CONTROLADORES Y ESTADO LOCAL ===
  
  /// Controlador para el campo de texto de descripción
  late final TextEditingController _descriptionController;
  
  /// Controlador para el campo de texto de monto
  late final TextEditingController _amountController;
  
  /// Fecha seleccionada para el gasto
  late DateTime _selectedDate;
  
  /// Categoría seleccionada para el gasto
  late String _selectedCategory;
  
  /// Lista de categorías disponibles
  final List<String> _categories = ['Comida', 'Transporte', 'Servicios', 'Otros'];

  /// Inicializa el estado con los datos del gasto a editar
  @override
  void initState() {
    super.initState();
    
    // Pre-llena los controladores con los datos existentes del gasto
    _descriptionController = TextEditingController(text: widget.expense.description);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
    _selectedCategory = widget.expense.category;
  }

  /// Muestra el selector de fecha nativo
  /// 
  /// Permite al usuario seleccionar una fecha entre hace un año y hoy.
  /// Actualiza _selectedDate con la fecha seleccionada.
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Valida y envía los datos del formulario para actualizar el gasto
  /// 
  /// Este método realiza las siguientes operaciones:
  /// 1. Valida que el monto sea un número válido y mayor a 0
  /// 2. Valida que la descripción no esté vacía
  /// 3. Muestra un diálogo de error si las validaciones fallan
  /// 4. Crea un nuevo objeto Expense con los datos actualizados usando copyWith
  /// 5. Llama al método updateExpense del provider
  /// 6. Cierra la pantalla después de guardar
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

    // Crea un nuevo objeto Expense con los datos actualizados
    // Mantiene el mismo ID pero actualiza los demás campos
    final updatedExpense = widget.expense.copyWith(
      description: _descriptionController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    // Llama al Provider usando .read para no reconstruir el widget
    // listen: false evita que este widget se reconstruya cuando el provider cambie
    Provider.of<ExpenseProvider>(context, listen: false).updateExpense(updatedExpense);

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

  /// Construye la interfaz de usuario del formulario de edición
  /// 
  /// Retorna: Scaffold con el formulario de edición de datos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Campo de descripción
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLength: 50,
            ),
            
            // Campo de monto
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            
            // Selector de fecha
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
            
            // Selector de categoría
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
            
            // Botón de guardar cambios
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
