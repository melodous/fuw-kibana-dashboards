# Kibana dashboards for visualizing data from IBM Transaction Analysis Workbench for z/OS

This repository contains Kibana dashboards for visualizing data
extracted from IBM z/OS mainframes by IBM Transaction Analysis Workbench for z/OS
("Workbench").

**Note:** The IBM product prefix for Workbench is FUW, hence the repository name prefix "fuw".

The dashboards in this repository are organized into the following sets,
according to the z/OS subsystems and types of data being visualized:

* CICS
* IMS

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

For details on getting data from z/OS into Elasticsearch, see
"[Using Workbench to get data from z/OS into Elasticsearch](#user-content-using-workbench-to-get-data-from-zos-into-elasticsearch)".

## Installation

To load the dashboards into Kibana, run the included `load.sh` shell script
with the Elasticsearch HTTP URL as the only argument:

```console
./load.sh http://localhost:9200
```

To use HTTP authentication for Elasticsearch, specify the credentials as a second argument:

```console
./load.sh http://localhost:9200 'admin:password'
```

## Technical details

The `dashboards` folder contains the JSON files as exported from Kibana, by
using the simple python tool from the `save` directory. The loader is a simple
shell script so that you don't need python installed when loading the
dashboards.

## Screenshots

### CICS dashboards

The CICS dashboards visualize data extracted from CICS monitoring facility (CMF) performance class records
(SMF type 110, subtype 1, class 3).

#### CICS application profiling

  ![CICS application profiling dashboard](screenshots/cics-application-profiling.png)

### IMS dashboards

To be added.

## Using Workbench to get data from z/OS into Elasticsearch

To get the data for these dashboards into Elasticsearch, we
run a z/OS batch job that performs the following steps:

1. Run the Transaction Analysis Workbench report and extract utility.

   The utility extracts selected log records from their original locations,
such as SMF records dumped to MVS data sets, and transforms them into comma-separated values (CSV) format.
Alternatively, we could have used Workbench to transform the records into JSON.

2. Use Dovetailed Technologies Co:Z Co-Processsing Toolkit for z/OS ("Co:Z") to:
   1. Transfer the CSV files (one per record type) to a Linux system running Logstash
   2. Run Logstash on the Linux system, to load the data into Elasticsearch.

For more details, see the
[Workbench product documentation](http://www.ibm.com/support/knowledgecenter/SSKKZM_1.3.0_ims/fuwutsk_big_data_logstash.dita).

## Acknowledgments

With thanks to [Elastic](https://www.elastic.co/), this repository is modeled on the
[elastic/beats-dashboards](https://github.com/elastic/beats-dashboards) repository.

## License

Copyright 2016 Fundi Software

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.