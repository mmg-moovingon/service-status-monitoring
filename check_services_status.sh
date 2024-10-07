#!/bin/bash

# Initialize the metrics output
echo "# HELP service_status Status of various services (1=active running, 2=active exited, 3=inactive dead, 4=failed, 0=no match)"
echo "# TYPE service_status gauge"

# Read each service from the services file
SERVICES_FILE="/opt/service-status-monitoring/services_list.txt"
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
        PROMETHEUS_SERVICE_NAME=$(echo "$SERVICE_NAME" | sed "s/\./_/g")

        # Write the custom metric to stdout
        echo "service_status{service=\"$PROMETHEUS_SERVICE_NAME\"} $METRIC_VALUE"
    fi
done < "$SERVICES_FILE"
