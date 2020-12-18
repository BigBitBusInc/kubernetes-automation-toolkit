{{/*
Expand the name of the chart.
*/}}
{{- define "bigbitbus-dj-py-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bigbitbus-dj-py-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bigbitbus-dj-py-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bigbitbus-dj-py-api.labels" -}}
helm.sh/chart: {{ include "bigbitbus-dj-py-api.chart" . }}
{{ include "bigbitbus-dj-py-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bigbitbus-dj-py-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bigbitbus-dj-py-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bigbitbus-dj-py-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bigbitbus-dj-py-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "helpers.list-env-variables"}}
{{- range $key, $val := .Values.env_in_secret }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Values.appsecrets.name }}
      key: {{ $key }}
{{- end}}
{{- range $key, $val := .Values.env_in_plaintext }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end}}
{{- end }}

