import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_session/presentation/providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Comida'; 
  final List<String> _categories = ['Comida', 'Transporte', 'Servicios', 'Otros'];

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

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_descriptionController.text.trim().isEmpty || amountIsInvalid) {
      // Mostrar un mensaje de error o SnackBar
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

    // Llama al Provider (Usa .read para no reconstruir el widget)
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
      description: _descriptionController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    // Cerrar la pantalla
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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