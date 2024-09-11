# Project Overview:

This project is designed to monitor multiple server services by checking the status of specified systemd services and reporting their statuses to Node Exporter. This enables visualization in Grafana and the creation of alerts in Prometheus. The script returns the status of services coded as follows:

Active (running): 1
Active (exited): 2
Inactive (dead): 3
Failed: 4
No match: 0

The main goal of this project is to provide a clear and concise way to monitor and manage the health and status of services across multiple servers, ensuring efficient alerting and visualization.

