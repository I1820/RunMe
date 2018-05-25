#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node-exporter.sh
#
# [] Creation Date : 25-05-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
version="0.16.0"

curl -# -L "https://github.com/prometheus/node_exporter/releases/download/v${version}/node_exporter-${version}.linux-amd64.tar.gz" -o node_exporter.tar.gz
tar xvfz node_exporter.tar.gz
rm node_exporter.tar.gz
chmod +x node_exporter-${version}.linux-amd64/node_exporter
