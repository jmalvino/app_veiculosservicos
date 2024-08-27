import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle_model.dart';
import '../providers/vehicle_provider.dart';

class VehicleFormPage extends StatefulWidget {
  @override
  _VehicleFormPageState createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _mileageController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _scheduledMaintenanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = Provider.of<VehicleProvider>(context).vehicles;

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                  ),
                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(labelText: 'Modelo'),
                    validator: (value) => value!.isEmpty ? 'Informe o modelo' : null,
                  ),
                  TextFormField(
                    controller: _mileageController,
                    decoration: InputDecoration(labelText: 'Quilometragem'),
                    validator: (value) => value!.isEmpty ? 'Informe a quilometragem' : null,
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(labelText: 'Placa'),
                    validator: (value) => value!.isEmpty ? 'Informe a placa' : null,
                  ),
                  TextFormField(
                    controller: _scheduledMaintenanceController,
                    decoration: InputDecoration(labelText: 'Revisão Programada (Km)'),
                    validator: (value) => value!.isEmpty ? 'Informe a revisão programada' : null,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newVehicle = Vehicle(
                          name: _nameController.text,
                          model: _modelController.text,
                          mileage: int.parse(_mileageController.text),
                          licensePlate: _licensePlateController.text,
                          scheduledMaintenance: int.parse(_scheduledMaintenanceController.text),
                        );
                        Provider.of<VehicleProvider>(context, listen: false).addVehicle(newVehicle);
                        _clearForm();
                      }
                    },
                    child: Text('Salvar Veículo'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return ListTile(
                    title: Text('${vehicle.name} (${vehicle.model})'),
                    subtitle: Text('Placa: ${vehicle.licensePlate} | Km: ${vehicle.mileage} | Revisão Programada: ${vehicle.scheduledMaintenance} Km'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editVehicle(context, vehicle),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteVehicle(context, vehicle.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editVehicle(BuildContext context, Vehicle vehicle) {
    final _editNameController = TextEditingController(text: vehicle.name);
    final _editModelController = TextEditingController(text: vehicle.model);
    final _editMileageController = TextEditingController(text: vehicle.mileage.toString());
    final _editLicensePlateController = TextEditingController(text: vehicle.licensePlate);
    final _editScheduledMaintenanceController = TextEditingController(text: vehicle.scheduledMaintenance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Veículo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editNameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _editModelController,
                  decoration: InputDecoration(labelText: 'Modelo'),
                ),
                TextField(
                  controller: _editMileageController,
                  decoration: InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _editLicensePlateController,
                  decoration: InputDecoration(labelText: 'Placa'),
                ),
                TextField(
                  controller: _editScheduledMaintenanceController,
                  decoration: InputDecoration(labelText: 'Revisão Programada (Km)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedVehicle = Vehicle(
                  id: vehicle.id,
                  name: _editNameController.text,
                  model: _editModelController.text,
                  mileage: int.parse(_editMileageController.text),
                  licensePlate: _editLicensePlateController.text,
                  scheduledMaintenance: int.parse(_editScheduledMaintenanceController.text),
                );
                Provider.of<VehicleProvider>(context, listen: false).addVehicle(updatedVehicle);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(BuildContext context, int vehicleId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Veículo'),
          content: Text('Tem certeza que deseja excluir este veículo?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Provider.of<VehicleProvider>(context, listen: false).deleteVehicle(vehicleId);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _modelController.clear();
    _mileageController.clear();
    _licensePlateController.clear();
    _scheduledMaintenanceController.clear();
  }
}
