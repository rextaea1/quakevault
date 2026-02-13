import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 16),
          Text(
            'Monitoring',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // FIXED: Added const
          SwitchListTile(
            title: Text('Enable Earthquake Alerts'),
            subtitle: Text('Receive notifications for earthquakes'),
            value: true,
            onChanged: null,
            secondary: Icon(Icons.notifications_active),
          ),
          Divider(height: 32),
          SwitchListTile(
            title: Text('Tsunami Warnings'),
            subtitle: Text('Critical alerts for tsunami-generating quakes'),
            value: true,
            onChanged: null,
            secondary: Icon(Icons.warning, color: Colors.red),
          ),
          Divider(height: 32),
          ListTile(
            title: Text('Minimum Magnitude'),
            subtitle: Text('Alert me for magnitude 3.0 and above'),
            trailing: Text('3.0'),
            leading: Icon(Icons.star),
          ),
          Divider(height: 32),
          ListTile(
            title: Text('Monitoring Locations'),
            subtitle: Text('Add custom locations to monitor'),
            leading: Icon(Icons.location_on),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(height: 32),
          ListTile(
            title: Text('About QuakeVault'),
            subtitle: Text('Version 1.0.0'),
            leading: Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}