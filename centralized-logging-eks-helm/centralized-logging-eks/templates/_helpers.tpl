{{- define "cl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cl.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "cl.namespace" -}}
{{- .Release.Namespace -}}
{{- end -}}

{{- define "cl.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: centralized-logging
{{- with .Values.global.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "cl.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: centralized-logging
{{- end -}}

{{- define "cl.kafkaName" -}}
{{- default (printf "%s-kafka" (include "cl.fullname" .)) .Values.kafka.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cl.esName" -}}
{{- default (printf "%s-es" (include "cl.fullname" .)) .Values.elasticsearch.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cl.kibanaName" -}}
{{- default (printf "%s-kibana" (include "cl.fullname" .)) .Values.kibana.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cl.vectorName" -}}
{{- default (printf "%s-vector" (include "cl.fullname" .)) .Values.vector.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cl.elasticPasswordSecret" -}}
{{ include "cl.esName" . }}-es-elastic-user
{{- end -}}

{{- define "cl.elasticCaSecret" -}}
{{ include "cl.esName" . }}-es-http-certs-public
{{- end -}}

{{- define "cl.s3SecretName" -}}
{{- if .Values.s3.existingSecret -}}
{{- .Values.s3.existingSecret -}}
{{- else -}}
{{- printf "%s-s3-archive" (include "cl.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
