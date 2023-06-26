import 'package:flutter/material.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key? key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  @override
  String selectedValue = 'Materi Perkuliahan';
  List<String> dropdownItems = [
    'Materi Perkuliahan',
    'Siakad',
    'E-learning',
    'Jadwal Kuliah',
    'Biaya Kuliah',
  ];

  String inputValue = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tanya Helpdesk"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kategori"),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedValue,
                    items: dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Judul"),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        inputValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deskripsi"),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        inputValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      // Perform an action when the button is pressed
                      print('Text button pressed');
                    },
                    child: Text(
                      'Ajukan Pertanyaan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // Perform an action when the button is pressed
                      print('Text button pressed');
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
