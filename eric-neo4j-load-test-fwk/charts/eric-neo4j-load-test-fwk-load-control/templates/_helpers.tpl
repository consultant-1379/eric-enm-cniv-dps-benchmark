{{/*
Create group label

CNIV registers benchmarks based on what is configured for its global sequence:
global:
  sequence:
    groupName:
      benchmarkChartName
The 'groupName' parameter is used by CNIV to install and manage all relevant components of a specific benchmark.
*/}}
{{- define "eric-neo4j-load-test-fwk.benchmarkGroup.label" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.cnivAgent.enabled -}}
      {{- range $groupmap := .Values.global.sequence -}}
        {{- range $group, $benchlist := $groupmap -}}
          {{- range $bench := $benchlist -}}
            {{- if eq "eric-neo4j-load-test-fwk" $bench -}}
              {{- $label := print $group -}}
              {{- $label | lower | trunc 54 | trimSuffix "-" -}}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- else }}
      {{- $label := print .Chart.Name -}}
      {{- $label | lower | trunc 54 | trimSuffix "-" -}}
    {{- end }}
  {{- end }}
{{- end }}