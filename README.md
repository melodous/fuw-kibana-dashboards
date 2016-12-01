# z/OS log analysis in Kibana

This repository contains [Kibana](https://www.elastic.co/products/kibana)
dashboards for analyzing operations logs from IBM z/OS mainframes.

The operations logs consist of various record types, including SMF records.

The dashboards analyze operations logs from the following z/OS subsystems:

* CICS
* IMS
* Coming soon: IMS Connect with z/OS Connect

To get the data for these dashboards from z/OS into Elasticsearch,
we used [IBM Transaction Analysis Workbench for z/OS](http://www.ibm.com/support/knowledgecenter/SSKKZM)
("Workbench"). The IBM product prefix for Workbench is FUW, hence the "fuw" prefix in the name of this repository.

## Who we are

[Fundi Software](http://www.fundi.com/) develops Workbench.

## Disclaimer

This repository is not supported by IBM.

## Requirements

To use the dashboards, you will need the Elastic Stack:

- Kibana 4.1.0 or later
- Elasticsearch
- Logstash

To extract data from z/OS for use with the dashboards, you will need:

- IBM Transaction Analysis Workbench for z/OS, V1.3

## Using Workbench to get log data from z/OS into Elastic

The `.jcl` files in this repository contain example z/OS JCL that uses Workbench to extract log data
for use with these dashboards.

The JCL creates a CSV file and a corresponding Logstash configuration file that you can use with Logstash to load the data into Elastic. For example, for the CICS dashboards:

```console
logstash cics-logstash.conf < cics.csv
```

For more information about using Workbench to forward logs to Elastic, including automating data transfer from z/OS and running Logstash, see the
[Workbench product documentation](http://www.ibm.com/support/knowledgecenter/SSKKZM_1.3.0/fuwucon_forward_elastic.htm).

## Logstash configuration

The `.conf` files in this repository contain example Logstash configurations.

## Elasticsearch configuration

As described in the Workbench product documentation, you need to map strings in the `fuw-*` index pattern (or whatever index pattern you use for data from Workbench) so that Elasticsearch does not "analyze" them:
- Elasticsearch 5.0, and later: map strings to the [`keyword`](https://www.elastic.co/guide/en/elasticsearch/reference/master/keyword.html) type
- Earlier versions: map strings to be [`not_analyzed`](http://www.ibm.com/support/knowledgecenter/SSKKZM_1.3.0/fuwucon_forward_elastic_config.htm)

## Kibana configuration

After loading data into Elasticsearch, and before using the dashboards, you need to define the following index patterns in Kibana:

- `fuw-cics-*`
- `fuw-ims-*`

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

To specify a different URL or HTTP authentication credentials, use command-line parameters.

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

This dashboard presents data from CICS monitoring facility (CMF) performance class records
(SMF type 110, subtype 1, class 3).

### IMS general health dashboard

  ![IMS general health dashboard](screenshots/ims-general-health.png)

This dashboard presents data from IMS log records.

### IMS Fast Path buffer usage dashboard

  ![IMS Fast Path buffer usage dashboard](screenshots/ims-fast-path-buffer-usage.png)

This dashboard presents data from IMS log records specific to Fast Path buffer usage.

## Acknowledgments

With thanks to [Elastic](https://www.elastic.co/), this repository reuses portions of
[elastic/beats-dashboards](https://github.com/elastic/beats-dashboards).
