# Kibana dashboards for visualizing data from IBM Transaction Analysis Workbench for z/OS

This repository contains Kibana dashboards for visualizing data
extracted from IBM z/OS mainframes by IBM Transaction Analysis Workbench for z/OS
("Workbench").

**Note:** The IBM product prefix for Workbench is FUW, hence the repository name prefix "fuw".

The dashboards in this repository are organized into the following sets,
according to the z/OS subsystems and types of data being visualized:

* CICS
* Coming soon: IMS

## Who we are

[Fundi Software](http://www.fundi.com/) develops Workbench.

## Disclaimer

This repository is not supported by IBM.

## Requirements

To use the dashboards, you will need the ELK stack:

- Elasticsearch
- Logstash
- Kibana 4

To extract data from z/OS for use with the dashboards, you will need:

- IBM Transaction Analysis Workbench for z/OS, V1.3

For details on using Workbench to get data from z/OS into Elasticsearch, see the
[Workbench product documentation](http://www.ibm.com/support/knowledgecenter/SSKKZM_1.3.0_ims/fuwutsk_big_data_logstash.dita).

## Installation

To load the dashboards into Kibana, run the included `load` script.

The `load` script loads the dashboards, and their related visualizations and
searches, from the JSON files in the `dashboards` folder.

On Unix, run the `load.sh` shell script:

```console
./load.sh
```

On Windows, run the `load.ps1` PowerShell script:

```console
.\load.ps1
```

By default, the `load` script loads the dashboards into the Elasticsearch instance at the URL http://localhost:9200,
with no HTTP authentication.

To specify a different URL, or HTTP authentication credentials, use command-line parameters.

On Unix:

```console
./load.sh -url "http://hostname:9200" -user "admin:secret"
```

On Windows:

```console
.\load.ps1 -url "http://hostname:9200" -user "admin:secret"
```

## Screenshots

### CICS application profiling dashboard

  ![CICS application profiling dashboard](screenshots/cics-application-profiling.png)

This dashboard provides insights into delays in CICS transaction processing.

This dashboard visualizes data extracted from CICS monitoring facility (CMF) performance class records
(SMF type 110, subtype 1, class 3).

### IMS dashboards

Coming soon!

## Acknowledgments

With thanks to [Elastic](https://www.elastic.co/), this project is modeled on
[elastic/beats-dashboards](https://github.com/elastic/beats-dashboards),
and reuses portions of that project.