import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veiculos_servicos/screens/widgts/custon_button.dart';
import 'vehicle_form_page.dart';
import 'service_form_page.dart';
import 'service_list_page.dart';
import '../models/vehicle_model.dart';
import '../providers/vehicle_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Vehicle? _selectedVehicle;
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = Provider.of<VehicleProvider>(context).vehicles;

    // Verifique se o veículo selecionado ainda existe na lista de veículos
    if (_selectedVehicle != null && !vehicles.contains(_selectedVehicle)) {
      _selectedVehicle = null;
    }

    return Scaffold(
      // appBar: AppBar(title: Text('Home')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                color: Colors.red[600]!,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Image.asset('assets/logo_simb.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          icon: Icons.directions_car,
                          text: 'Veículos',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VehicleFormPage()),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomButton(
                          icon: Icons.list_alt_outlined,
                          text: 'Serviços',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceFormPage()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceListPage())),
                            child: Text('Serviços Cadastrados'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (vehicles.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[700]!,
                  border: Border(top: BorderSide(color: Colors.red[800]!)),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<Vehicle>(
                                  isDense: true,
                                  hint: Text('Selecione um veículo'),
                                  value: _selectedVehicle,
                                  onChanged: (Vehicle? newValue) {
                                    setState(() {
                                      _selectedVehicle = newValue;
                                    });
                                  },
                                  items: vehicles
                                      .map<DropdownMenuItem<Vehicle>>(
                                          (Vehicle vehicle) {
                                    return DropdownMenuItem<Vehicle>(
                                      value: vehicle,
                                      child: Text(
                                          '${vehicle.name} (${vehicle.model})'),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: TextField(
                          controller: _valueController,
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Insira a quilometragem',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _compareValues,
                          child: Text('Verificar Revisão'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _compareValues() {
    if (_selectedVehicle == null || _valueController.text.isEmpty) {
      _showDialog('Erro', 'Selecione um veículo e insira um valor.', null);
      return;
    }

    int inputValue = int.parse(_valueController.text);
    int mileage = _selectedVehicle!.mileage;
    int scheduledMaintenance = _selectedVehicle!.scheduledMaintenance;

    if (inputValue == mileage) {
      int remaining = scheduledMaintenance - inputValue;
      _showDialog(
        'Quilometragem Igual',
        'O valor informado é igual à quilometragem atual. Faltam $remaining km para a revisão.',
        null,
      );
    } else if (inputValue < scheduledMaintenance) {
      int remaining = scheduledMaintenance - inputValue;
      _showDialog(
        'Revisão Não Necessária',
        'Faltam $remaining km para a revisão.',
        inputValue,
      );
    } else {
      _showMaintenanceDialog(inputValue, mileage, scheduledMaintenance);
    }

    // Limpar o campo de texto após a comparação
    _valueController.clear();
  }

  void _showDialog(String title, String content, int? inputValue) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              if (inputValue != null && inputValue != _selectedVehicle!.mileage)
                SizedBox(height: 10),
              if (inputValue != null && inputValue != _selectedVehicle!.mileage)
                Text(
                    'Deseja atualizar a quilometragem do veículo para $inputValue km?'),
            ],
          ),
          actions: [
            if (inputValue != null && inputValue != _selectedVehicle!.mileage)
              ElevatedButton(
                onPressed: () {
                  _updateMileage(inputValue);
                  Navigator.of(context).pop();
                },
                child: Text('ATUALIZAR'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('SAIR'),
            ),
          ],
        );
      },
    );
  }

  void _showMaintenanceDialog(
      int inputValue, int mileage, int scheduledMaintenance) {
    final _nextMaintenanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Revisão Necessária'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('O veículo deve ser levado para manutenção.'),
              TextField(
                controller: _nextMaintenanceController,
                decoration: InputDecoration(
                  labelText: 'Digite o valor da próxima revisão (Km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateMileageAndMaintenance(
                  inputValue,
                  int.tryParse(_nextMaintenanceController.text) ??
                      scheduledMaintenance,
                );
                Navigator.of(context).pop();
              },
              child: Text('Atualizar e Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _updateMileage(int newMileage) {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    _selectedVehicle = Vehicle(
      id: _selectedVehicle!.id,
      name: _selectedVehicle!.name,
      model: _selectedVehicle!.model,
      mileage: newMileage,
      licensePlate: _selectedVehicle!.licensePlate,
      scheduledMaintenance: _selectedVehicle!.scheduledMaintenance,
    );
    vehicleProvider.addVehicle(_selectedVehicle!);
  }

  void _updateMileageAndMaintenance(
      int newMileage, int newScheduledMaintenance) {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    _selectedVehicle = Vehicle(
      id: _selectedVehicle!.id,
      name: _selectedVehicle!.name,
      model: _selectedVehicle!.model,
      mileage: newMileage,
      licensePlate: _selectedVehicle!.licensePlate,
      scheduledMaintenance: newScheduledMaintenance,
    );
    vehicleProvider.addVehicle(_selectedVehicle!);
  }
}
