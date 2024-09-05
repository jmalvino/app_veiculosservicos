import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_model.dart';
import '../providers/service_provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';

class ServiceFormPage extends StatefulWidget {
  @override
  _ServiceFormPageState createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedVehicleId;
  String? _selectedServiceType;
  final _dateController = TextEditingController();
  final _mileageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = Provider.of<VehicleProvider>(context).vehicles;

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Selecione o Veículo'),
                items: vehicles.map((Vehicle vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id.toString(),
                    child: Text('${vehicle.name} (${vehicle.model})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleId = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione um veículo' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Tipo de Serviço'),
                items: ['Troca de Óleo', 'Manutenção'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceType = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione um tipo de serviço' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Data (Opcional)'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = pickedDate.toString().substring(0, 10);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Quilometragem (Opcional)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newService = Service(
                        vehicleId: int.parse(_selectedVehicleId!),
                        type: _selectedServiceType!,
                        date: _dateController.text.isNotEmpty ? _dateController.text : null,
                        mileage: _mileageController.text.isNotEmpty ? int.parse(_mileageController.text) : null,
                      );
                      Provider.of<ServiceProvider>(context, listen: false).addService(newService);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Salvar Serviço'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
