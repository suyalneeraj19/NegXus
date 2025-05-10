import 'package:NegXus/Pages/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          // <-- added scroll view here
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          Row(
                            children: [
                              Text("Personal Info", style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Name", style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              hintText: 'Jon Snow',
                              fillColor: Theme.of(context).colorScheme.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Email Id", style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                              filled: true,
                              hintText: 'JonSnow@gmail.com',
                              fillColor: Theme.of(context).colorScheme.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Phone Number", style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              filled: true,
                              hintText: '876523XXXX',
                              fillColor: Theme.of(context).colorScheme.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            PrimaryButton(btnName: "Save", icon: Icons.save, ontap: () {}),
                          ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
