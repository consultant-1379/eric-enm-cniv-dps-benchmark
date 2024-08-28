# !/bin/bash

#
# Usage:
# 1. Copy the JSON from Grafana -> Export as JSON -> Clipboard -> Save as json
# 2. ./prepare_dashboard.sh saved_json.json
# - This will update saved_json.json
#

if [ "$#" -ne 1 ]; then
  echo "Usage: ./prepare_dashboard.sh <name_of_dashboard>"
  exit
fi

# Prepare JSON for Grafana Watcher
newContent=`sed 's/${DS_PROMETHEUS}/prometheus/g' "$1" | sed 's/^/    /g'`
dashboardConfigFile='grafana-dashboard-config.yaml'
dashboardTemplateFile='grafana-dashboard-template.yaml'
directJson='neo4j-dashboard.json'
templateDir='../eric-neo4j-load-test-fwk/charts/monitoring/templates'

echo "{{- if $.Values.global.monitoring.metricsEnabled }}" > $dashboardConfigFile
cat "grafana-dashboard-template.yaml" >> $dashboardConfigFile
echo "$newContent" >> $dashboardConfigFile
echo "{{- end -}}" >> $dashboardConfigFile

printf "What do you want to do??:\n\t1:\tOverwrite template file with new dashboard,\n\t2:\tCreate New YAML file but leave in current directory\n\t3:\tJust Generate JSON for insertion manually into helm template (default)\n:"
read response
case "$response" in
    1)
      echo "{{- if $.Values.global$.monitoring.metricsEnabled }}" > $dashboardConfigFile
      cat $dashboardTemplateFile >> $dashboardConfigFile
      echo "$newContent" >> $dashboardConfigFile
      echo "{{- $end -}}" >> $dashboardConfigFile
      echo "Replacing ${dashboardConfigFile} in ${templateDir}"
      mv -f $dashboardConfigFile $templateDir
        ;;
    2)
      echo "{{- if $.Values.global.monitoring.metricsEnabled }}" > $dashboardConfigFile
      cat $dashboardTemplateFile >> $dashboardConfigFile
      echo "$newContent" >> $dashboardConfigFile
      echo "{{- end -}}" >> $dashboardConfigFile
      echo "${dashboardConfigFile} will be retained in this directory for inspection"
        ;;
    *)
      echo "$newContent" >> $directJson
      echo "Adapted JSON available in ${directJson}"
        ;;
esac

