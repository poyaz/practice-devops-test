{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wordpress.fullname" -}}
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
{{- define "wordpress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "wordpress.clusterDomain" -}}
{{- if empty .Values.clusterDomain }}
{{- printf "cluster.local" }}
{{- else }}
{{- .Values.clusterDomain }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wordpress.labels" -}}
helm.sh/chart: {{ include "wordpress.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
<-- Start root password secret -->
*/}}

{{- define "wordpress.mysql.rootPasswordSecret" -}}
{{- if empty .Values.mysql.config.rootPassword.secretRef }}
{{- printf "mysql-root-pass" }}
{{- else }}
{{- .Values.mysql.config.rootPassword.secretRef }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.rootPasswordSecretKey" -}}
{{- if empty .Values.mysql.config.rootPassword.secretRefKey }}
{{- printf "password" }}
{{- else }}
{{- .Values.mysql.config.rootPassword.secretRefKey }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.rootPassword" -}}
{{- randAlphaNum 32 | b64enc }}
{{- end }}

{{/*
<-- End root password secret -->
*/}}

{{/*
<-- Start auth secret -->
*/}}

{{- define "wordpress.mysql.authSecret" -}}
{{- if empty .Values.mysql.config.dbAuth.secretRef }}
{{- printf "mysql-auth" }}
{{- else }}
{{- .Values.mysql.config.dbAuth.secretRef }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.authUserSecretKey" -}}
{{- if empty .Values.mysql.config.dbAuth.userSecretRefKey }}
{{- printf "username" }}
{{- else }}
{{- .Values.mysql.config.dbAuth.userSecretRefKey }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.authPassSecretKey" -}}
{{- if empty .Values.mysql.config.dbAuth.passSecretRefKey }}
{{- printf "password" }}
{{- else }}
{{- .Values.mysql.config.dbAuth.passSecretRefKey }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.authUsername" -}}
{{- randAlphaNum 6 | b64enc }}
{{- end }}

{{- define "wordpress.mysql.authPassword" -}}
{{- randAlphaNum 32 | b64enc }}
{{- end }}

{{/*
<-- End auth secret -->
*/}}

{{/*
<-- Start db configmap -->
*/}}

{{- define "wordpress.mysql.dbConfigmap" -}}
{{- if empty .Values.mysql.config.dbName.configmapRef }}
{{- printf "mysql-db-name" }}
{{- else }}
{{- .Values.mysql.config.dbName.configmapRef }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.dbConfigmapKey" -}}
{{- if empty .Values.mysql.config.dbName.configmapRefKey }}
{{- printf "db" }}
{{- else }}
{{- .Values.mysql.config.dbName.configmapRefKey }}
{{- end }}
{{- end }}

{{- define "wordpress.mysql.dbName" -}}
{{- if empty .Values.mysql.config.dbName.name }}
{{- printf "my_db" }}
{{- else }}
{{- .Values.mysql.config.dbName.name }}
{{- end }}
{{- end }}

{{/*
<-- End db configmap -->
*/}}

{{/*
<-- Start wordpress auth secret -->
*/}}

{{- define "wordpress.wp.authSecret" -}}
{{- printf "wp-auth" }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.authUserSecret" -}}
{{- if empty .Values.wordpress.config.wordpressUsername.secretRef }}
{{- include "wordpress.wp.authSecret" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressUsername.secretRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.authUserSecretKey" -}}
{{- if empty .Values.wordpress.config.wordpressUsername.secretKey }}
{{- printf "username" }}
{{- else }}
{{- .Values.wordpress.config.wordpressUsername.secretKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.authUsername" -}}
{{- if empty .Values.wordpress.config.wordpressUsername.value }}
{{- printf "admin" | b64enc }}
{{- else }}
{{- .Values.wordpress.config.wordpressUsername.value | b64enc }}
{{- end }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.authPassSecret" -}}
{{- if empty .Values.wordpress.config.wordpressPassword.secretRef }}
{{- include "wordpress.wp.authSecret" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressPassword.secretRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.authPassSecretKey" -}}
{{- if empty .Values.wordpress.config.wordpressPassword.secretKey }}
{{- printf "password" }}
{{- else }}
{{- .Values.wordpress.config.wordpressPassword.secretKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.authPassword" -}}
{{- if empty .Values.wordpress.config.wordpressPassword.value }}
{{- randAlphaNum 10 | b64enc }}
{{- else }}
{{- .Values.wordpress.config.wordpressPassword.value | b64enc }}
{{- end }}
{{- end }}

{{/*
<-- End wordpress secret -->
*/}}

{{/*
<-- Start wordpress conifg -->
*/}}

{{- define "wordpress.wp.configConfigmap" -}}
{{- printf "wp-config" }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.configEmailConfigmap" -}}
{{- if empty .Values.wordpress.config.wordpressEmail.configmapRef }}
{{- include "wordpress.wp.configConfigmap" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressEmail.configmapRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configEmailConfigmapKey" -}}
{{- if empty .Values.wordpress.config.wordpressEmail.configmapKey }}
{{- printf "email_address" }}
{{- else }}
{{- .Values.wordpress.config.wordpressEmail.configmapKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configEmail" -}}
{{- if empty .Values.wordpress.config.wordpressEmail.value }}
{{- printf "user@example.com" }}
{{- else }}
{{- .Values.wordpress.config.wordpressEmail.value }}
{{- end }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.configFirstNameConfigmap" -}}
{{- if empty .Values.wordpress.config.wordpressFirstName.configmapRef }}
{{- include "wordpress.wp.configConfigmap" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressFirstName.configmapRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configFirstNameConfigmapKey" -}}
{{- if empty .Values.wordpress.config.wordpressFirstName.configmapKey }}
{{- printf "first_name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressFirstName.configmapKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configFirstName" -}}
{{- if empty .Values.wordpress.config.wordpressFirstName.value }}
{{- printf "User's first name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressFirstName.value }}
{{- end }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.configLastNameConfigmap" -}}
{{- if empty .Values.wordpress.config.wordpressLastName.configmapRef }}
{{- include "wordpress.wp.configConfigmap" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressLastName.configmapRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configLastNameConfigmapKey" -}}
{{- if empty .Values.wordpress.config.wordpressLastName.configmapKey }}
{{- printf "last_name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressLastName.configmapKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configLastName" -}}
{{- if empty .Values.wordpress.config.wordpressLastName.value }}
{{- printf "User's last name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressLastName.value }}
{{- end }}
{{- end }}

{{/*
-------------------------
*/}}

{{- define "wordpress.wp.configBlogNameConfigmap" -}}
{{- if empty .Values.wordpress.config.wordpressBlogName.configmapRef }}
{{- include "wordpress.wp.configConfigmap" . }}
{{- else }}
{{- .Values.wordpress.config.wordpressBlogName.configmapRef }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configBlogNameConfigmapKey" -}}
{{- if empty .Values.wordpress.config.wordpressBlogName.configmapKey }}
{{- printf "blog_name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressBlogName.configmapKey }}
{{- end }}
{{- end }}

{{- define "wordpress.wp.configBlogName" -}}
{{- if empty .Values.wordpress.config.wordpressBlogName.value }}
{{- printf "User's blog name" }}
{{- else }}
{{- .Values.wordpress.config.wordpressBlogName.value }}
{{- end }}
{{- end }}

{{/*
<-- End wordpress conifg -->
*/}}