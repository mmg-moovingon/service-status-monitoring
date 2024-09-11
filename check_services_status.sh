#!/bin/bash

# Define the output file for custom metrics
METRICS_FILE="/var/lib/node_exporter/textfile_collector/services_status.prom"
SERVICES_FILE="/opt/service-status-monitoring/services_list.txt"

# Initialize the metrics file
echo "# HELP service_status Status of various services (1=active running, 2=active exited, 3=inactive dead, 4=failed, 0=no match)" > "$METRICS_FILE"
echo "# TYPE service_status gauge" >> "$METRICS_FILE"

# Read each service from the services file
while IFS= read -r SERVICE_NAME; do
    if [ -n "$SERVICE_NAME" ]; then
        # Get the status of the service
        SERVICE_STATUS=$(systemctl is-active "$SERVICE_NAME")

        # Determine the metric value based on the service status
        case "$SERVICE_STATUS" in
            "active")
                METRIC_VALUE=1
                ;;
            "exited")
                METRIC_VALUE=2
                ;;
            "inactive")
                METRIC_VALUE=3
                ;;
            "failed")
                METRIC_VALUE=4
                ;;
            *)
                METRIC_VALUE=0
                ;;
        esac

        # Format the service name to be Prometheus-compatible (replace dots with underscores)
        PROMETHEUS_SERVICE_NAME=$(echo "$SERVICE_NAME" | sed 's/\./_/g')

        # Write the custom metric to the metrics file
        echo "service_status{service=\"$PROMETHEUS_SERVICE_NAME\"} $METRIC_VALUE" >> "$METRICS_FILE"
    fi
done < "$SERVICES_FILE"
