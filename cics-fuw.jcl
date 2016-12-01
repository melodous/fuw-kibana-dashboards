//FUWCICS  JOB ,NOTIFY=&SYSUID
//*
//* z/OS JCL
//*
//* Description
//* -----------
//* Extracts CICS (CMF) performance class records for use with Kibana
//* dashboards: writes selected fields to a CSV file,
//* with a corresponding Logstash configuration.
//*
//* Requirements
//* ------------
//*
//* - IBM Transaction Analysis Workbench for z/OS ("FUW")
//*
//* Instructions
//* ------------
//* Before submitting this JCL, replace the following placeholders
//* with actual values:
//*
//* Placeholder                 | Example actual value
//* --------------------------- | --------------------
//* <FUW HLQ>                   | FUW.PROD
//* <input dumped SMF records>  | SMF.TYPE110
//* <output zFS directory path> | u/myid/logs
//*
//FUWBATCH EXEC PGM=FUWBATCH
//STEPLIB  DD  DISP=SHR,
//             DSN=<FUW HLQ>.SFUWLINK
//SYSPRINT DD  SYSOUT=*
//SMFIN001 DD  DISP=SHR,
//             DSN=<input dumped SMF records>
//CSV      DD  PATH='/<output zFS directory path>/cics.csv',
//             PATHOPTS=(OWRONLY,OCREAT,OEXCL),
//             PATHDISP=(KEEP,DELETE),
//             PATHMODE=(SIRUSR,SIWUSR,SIRGRP)
//LSCONF   DD  PATH='/<output zFS directory path>/cics-logstash.conf',
//             PATHOPTS=(OWRONLY,OCREAT,OEXCL),
//             PATHDISP=(KEEP,DELETE),
//             PATHMODE=(SIRUSR,SIWUSR,SIRGRP)
//SYSIN    DD  *
CSV CODE(CMF) +
  OUTPUT(CSV) +
  LOGSTASHCONFIG(LSCONF) +
  FIELDCASE(LOWER) +
  LOGSTASHINDEX(fuw-cics-%{+YYYY.MM.dd}) +
  NOLABELS +
  THM ZONE CODEPAGE(1047) NL
FIELDS(
  applid
  tran
  usrdispt
  usrcput
  susptime
  trannum
  dispwtt
  rmitime
  stop
  response
  userid
  fciowtt
  fcamct
  pgmname
  synctime
  jciowtt
  pcstghwm
  term
  iriowtt
  tdiowtt
)
/*
