import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../models/service_model.dart';

class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<ServiceProvider>(context, listen: false).fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ServiceProvider>(context).services.where((service) {
      return service.vehicleName!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.vehicleLicensePlate!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.type.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Serviços Cadastrados'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar por nome, modelo, placa...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: services.isEmpty
          ? Center(
        child: Text(
          'Não há serviços cadastrados no momento.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            title: Text('Serviço: ${service.type}'),
            subtitle: Text('Veículo: ${service.vehicleName} | Placa: ${service.vehicleLicensePlate} | Km: ${service.mileage}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editService(context, service),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteService(context, service.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editService(BuildContext context, Service service) {
    final _dateController = TextEditingController(text: service.date);
    final _mileageController = TextEditingController(text: service.mileage?.toString());
    String _selectedServiceType = service.type;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Serviço'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedServiceType,
                  decoration: InputDecoration(labelText: 'Tipo de Serviço'),
                  items: ['Troca de Óleo', 'Manutenção'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value!;
                    });
                  },
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Data'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _dateController.text = pickedDate.toString().substring(0, 10);
                    }
                  },
                ),
                TextField(
                  controller: _mileageController,
                  decoration: InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedService = Service(
                  id: service.id,
                  vehicleId: service.vehicleId,
                  type: _selectedServiceType,
                  date: _dateController.text,
                  mileage: int.tryParse(_mileageController.text),
                );
                Provider.of<ServiceProvider>(context, listen: false).addService(updatedService);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(BuildContext context, int serviceId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Serviço'),
          content: Text('Tem certeza que deseja excluir este serviço?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Provider.of<ServiceProvider>(context, listen: false).deleteService(serviceId);
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
}
