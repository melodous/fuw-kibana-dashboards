//FUWIMS   JOB ,NOTIFY=&SYSUID
//*
//* z/OS JCL
//*
//* Description
//* -----------
//* Extracts IMS log records for use with Kibana dashboards:
//* consolidates IMS SLDS records into IMS transaction index records, 
//* and then writes selected fields from the index records to a
//* CSV file, with a corresponding Logstash configuration.
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
//* <input IMS SLDS>            | IMS1.SLDS
//* <output zFS directory path> | u/myid/logs
//*
///FUWBATCH EXEC PGM=FUWBATCH
//STEPLIB  DD  DISP=SHR,
//             DSN=<FUW HLQ>.SFUWLINK
//SYSPRINT DD  SYSOUT=*
//LOGIN001 DD  DISP=SHR,
//             DSN=<input IMS SLDS>
//CSV      DD  PATH='/<output zFS directory path>/ims.csv',
//             PATHOPTS=(OWRONLY,OCREAT,OEXCL),
//             PATHDISP=(KEEP,DELETE),
//             PATHMODE=(SIRUSR,SIWUSR,SIRGRP)
//LSCONF   DD  PATH='/<output zFS directory path>/ims-logstash.conf',
//             PATHOPTS=(OWRONLY,OCREAT,OEXCL),
//             PATHDISP=(KEEP,DELETE),
//             PATHMODE=(SIRUSR,SIWUSR,SIRGRP)
//SYSIN    DD  *
IMSVRM=<vrm>
IMSINDEX
CSV CODE(IMS:CA01) +
  OUTPUT(CSV) +
  LOGSTASHCONFIG(LSCONF) +
  FIELDCASE(LOWER) +
  LOGSTASHINDEX(fuw-ims-%{+YYYY.MM.dd}) +
  NOLABELS +
  THM ZONE CODEPAGE(1047) NL +
  TOKENS(IMS)
FIELDS(
  trancode
  program
  userid
  regtype
  inputq
  process
  outputq
  totaltm
  respims
  cputime
  fpwaits
  fpnba#
  fpoba#
  fpovfn
  fpbfwt
  fpbstl
  fpnba
  fpothr
  fpnrdb
  compcode
)
/*
