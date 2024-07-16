import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/model/client_report.dart';
import 'package:Trako/model/supply_fields_data.dart';
import 'package:Trako/network/ApiService.dart';


class MyReportScreen extends StatefulWidget {
  @override
  State<MyReportScreen> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  List<String> clientCities = [];
  List<String> clientNames = [];
  List<SupplyClient> clients = [];
  bool _isLoading = false;
  bool _showDetails = false;
  ClientReportResponse? _reportData;
  final ApiService _apiService = ApiService();
  String? selectedClientName;
  String? selectedCityName;
  String? selectedClientId;
  late DateTime _selectedFromDate;
  late DateTime _selectedToDate;

  Future<void> fetchSpinnerData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SupplySpinnerResponse spinnerResponse =
      await _apiService.getSpinnerDetails();
      setState(() {
        clients = spinnerResponse.data.clients;
        clientNames = spinnerResponse.data.clientName;
        clientCities = spinnerResponse.data.clientCity;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching supply spinner details: $e');
      setState(() {
        _isLoading = false;
      });
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedFromDate = DateTime.now();
    _selectedToDate = DateTime.now();
    fetchSpinnerData();
  }

  void _handleFromDateChanged(DateTime date) {
    setState(() {
      _selectedFromDate = date;
    });
  }

  void _handleToDateChanged(DateTime date) {
    setState(() {
      _selectedToDate = date;
    });
  }

  void _fetchReportData() async {
    if (selectedClientId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        ClientReportResponse report = await _apiService.getReport(
          client_id: selectedClientId!,
          from_date: DateFormat('yyyy-MM-dd').format(_selectedFromDate),
          to_date: DateFormat('yyyy-MM-dd').format(_selectedToDate),
        );
        setState(() {
          _reportData = report;
          _showDetails = true;
          _isLoading = false;
        });
      } catch (e) {
        print('Error fetching report data: $e');
        setState(() {
          _isLoading = false;
          _showDetails = false;
        });
        // Handle error as needed
      }
    } else {
      // Show an error message if the client ID is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a client.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reports",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(height: 5),
            ClientNameSpinner(
              onChanged: (SupplyClient? newClient) {
                setState(() {
                  selectedClientName = newClient?.name;
                  selectedCityName = newClient?.city;
                  selectedClientId = newClient?.id.toString();
                });
              },
              clients: clients,
            ),
            const SizedBox(height: 15),
            DatePickerRow(
              onFromDateChanged: _handleFromDateChanged,
              onToDateChanged: _handleToDateChanged,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: GradientButton(
                gradientColors: const [colorFirstGrad, colorSecondGrad],
                height: 45.0,
                width: double.infinity,
                radius: 25.0,
                buttonText: "Get Details",
                onPressed: _fetchReportData,
              ),
            ),
            const SizedBox(height: 15),
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_showDetails && _reportData != null)
              TonerDetails(
                tonerReceived: _reportData!.data.report[0].dispatchCount,
                tonerDistributed: _reportData!.data.report[0].receiveCount,
                client: selectedClientName!,
                machine: _reportData!.data.report[0].reportCount.toString(),
              ),
            if (!_isLoading && !_showDetails)
              Center(child: Text('No data available')),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: GradientButton(
                gradientColors: const [colorFirstGrad, colorSecondGrad],
                height: 45.0,
                width: double.infinity,
                radius: 25.0,
                buttonText: "Get Report on Mail",
                onPressed: _fetchReportData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TonerDetailsPage extends StatefulWidget {
  final String clientId;
  final String fromDate;
  final String toDate;

  TonerDetailsPage({
    required this.clientId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  _TonerDetailsPageState createState() => _TonerDetailsPageState();
}

class _TonerDetailsPageState extends State<TonerDetailsPage> {
  late Future<ClientReportResponse> _tonerDataFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _tonerDataFuture = fetchTonerData(
      clientId: widget.clientId,
      fromDate: widget.fromDate,
      toDate: widget.toDate,
    );
  }

  Future<ClientReportResponse> fetchTonerData({
    required String clientId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      // Call the getReport method with the required parameters
      ClientReportResponse report = await _apiService.getReport(
        client_id: clientId,
        from_date: fromDate,
        to_date: toDate,
      );

      // Debug print to check the fetched report
      print('Fetched report: $report');
      return report;
    } catch (e) {
      // Handle error
      print('Error fetching report: $e');
      throw Exception('Failed to fetch report.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toner Details'),
      ),
      body: Center(
        child: FutureBuilder<ClientReportResponse>(
          future: _tonerDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data.report.isEmpty) {
              return Text('No data available');
            } else {
              var data = snapshot.data!.data.report[0];
              return TonerDetails(
                tonerReceived: data.dispatchCount,
                tonerDistributed: data.receiveCount,
                client: widget.clientId,
                machine: data.reportCount.toString(),
              );
            }
          },
        ),
      ),
    );
  }

}

class TonerDetails extends StatelessWidget {
  final String tonerReceived;
  final String tonerDistributed;
  final String client;
  final String machine;

  TonerDetails({
    required this.tonerReceived,
    required this.tonerDistributed,
    required this.client,
    required this.machine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Match parent width
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Client:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),
            Text(
              client,
              style: TextStyle(
                fontSize: 16,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),

            SizedBox(height: 12),
            Text(
              'Toner Distributed:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),
            Text(
              tonerReceived
              ,
              style: TextStyle(
                fontSize: 16,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Toner Received:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),
            Text(
              tonerDistributed,
              style: TextStyle(
                fontSize: 16,
                color: colorMixGrad, // Use colorMixGrad here
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class DatePickerRow extends StatefulWidget {
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;

  const DatePickerRow({
    super.key,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  _DatePickerRowState createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "From Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              DateInputField(
                initialDate: _fromDate,
                onDateChanged: (date) {
                  setState(() {
                    _fromDate = date;
                    widget.onFromDateChanged(date);
                    // Ensure the toDate is not before fromDate
                    if (_toDate.isBefore(_fromDate)) {
                      _toDate = _fromDate;
                      widget.onToDateChanged(_toDate);
                    }
                  });
                },
                labelText: '',
                firstDate: DateTime(2000), // Set the initial from date range
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "To Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              DateInputField(
                initialDate: _toDate,
                onDateChanged: (date) {
                  setState(() {
                    _toDate = date;
                    widget.onToDateChanged(date);
                  });
                },
                labelText: '',
                firstDate: _fromDate, // Use fromDate as the first date for toDate
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DateInputField extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String labelText;
  final DateTime firstDate;

  DateInputField({
    required this.initialDate,
    required this.onDateChanged,
    required this.labelText,
    required this.firstDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(initialDate);

    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          formattedDate,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class PieChartSample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              color: Colors.green,
              title: 'Toner Receive',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.blue,
              title: 'Toner Distributed',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.orange,
              title: 'Client',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.red,
              title: 'Machine',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientNameSpinner extends StatelessWidget {
  final ValueChanged<SupplyClient?> onChanged;
  final List<SupplyClient> clients;

  const ClientNameSpinner({
    required this.onChanged,
    required this.clients,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SupplyClient>(
      hint: const Text('Select a client'),
      items: clients.map((SupplyClient client) {
        return DropdownMenuItem<SupplyClient>(
          value: client,
          child: Text(client.name),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
          const BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

