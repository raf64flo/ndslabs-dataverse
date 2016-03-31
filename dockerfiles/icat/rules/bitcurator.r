bcExtractFeatureFilesRule {

# expects a working directory, currently /tmp/bcworking specified below,
# to exist and be writable by the user running the script.
  *Cmd="bulk_extractor";
  *now = double (time());
  msiGetSystemTime(*reportTimeStamp,"human");
# Now Make a query to get the path to the image and the resource name
# DATA_PATH: Physical path name for digital object in resource
# DATA_RESC_NAME: Logical name of storage resource
  *Query = select DATA_NAME,DATA_PATH,DATA_RESC_NAME,COLL_NAME,DATA_CREATE_TIME where COLL_NAME like '*Coll%';
  foreach (*row in *Query) {
    *Path = *row.DATA_PATH;
    *CollPath = *row.COLL_NAME;
    *Resource = *row.DATA_RESC_NAME;
    *File = *row.DATA_NAME;
    *CreateTime = *row.DATA_CREATE_TIME;

    if ( int(*CreateTime) < int(*now - CRON_FREQUENCY*60) ) {

      writeLine("stdout", "Path = *Path, Resource= *Resource");
# Make another query for IP Address of the resource
# RESC_LOC: Resource IP Address
# DATA_RESC_NAME: Logical name of storage resource
      *Query2 = select RESC_LOC where DATA_RESC_NAME = '*Resource';
      foreach (*row in *Query2) {
        *Addr = *row.RESC_LOC;
        writeLine("stdout", "ADDR = *Addr, Resource= *Resource");
      }
      *prefixStr = "*File" ++ "*now$userNameClient";
      *tempStr = "/tmp/bcworking/*prefixStr" ++ "outFeatDir";
      *Arg1 = execCmdArg(*Path);    # Image
      *Arg2 = execCmdArg("-o");
      *Arg3 = execCmdArg(*tempStr); # Output Feature Directory
      writeLine("stdout", "Running Bulk Extractor Tool...");
      writeLine("stdout", "Command: *Cmd *Arg1 *Arg2 *Arg3");
      #msiExecCmd("bcMkdir.sh",*tempStr, "null", "null", "null", *Result);
      if (errorcode(msiExecCmd(*Cmd,"*Arg1 *Arg2 *Arg3","null","null","null",*Result)) < 0) {
          if(errormsg(*Result,*msg)==0) {
              msiGetStderrInExecCmdOut(*Result,*Out);
              writeLine("stdout", "ERROR:*Out");
          } else {
              writeLine("stdout", "Result msg is empty");
          }
      } else {
          # Command executed successfully
          msiGetStdoutInExecCmdOut(*Result,*Out);
          writeLine("stdout", "Output is *Out ");
          # run shell script to list iRODS path to files suspected to contain PII or CCN
          msiExecCmd("bcListSuspectedSensitive.sh", *s1, "null", "null", "null", *SResult);
          msiGetStdoutInExecCmdOut(*SResult, *Out);
          *s = split(*Out, "\n");
          *i = 0;
          foreach (*item in *s) {
            writeLine("stdout", "Debug: Suspected sensitive file: *item");
            addAVUMetadata(*item, "CURATOR_REVIEW", "Sensitive", "*reportTimeStamp", *Status);
            *i = *i + 1;
          }
          if (*i > 0) {
            # e-mail archivist with list of suspected sensitive files
            writeLine("stdout", "Sending email to *Archivist");
            msiSendMail("*Archivist","Suspected sensitive data","*s");
          }
          # remove working subdirectories
          cleanup(*Addr, *tempStr, *outFeatDir, *prefixStr, *status);
      }
    } else {
      writeLine("stdout", "Skipping file *CreateTime < *now - 60");
    }
  }
}

# Function: cleanup: Calls a script to remove the temporary files created in /tmp
cleanup: input string * input string * input string * input string * output integer -> integer
cleanup(*Addr, *tempStr, *outFeatDir, *prefixStr, *status) {
   writeLine("stdout", "Cleanup: Moving *tempStr to *outFeatDir");
   remote(*Addr, "null") {
      *local = "localPath=*tempStr++++forceFlag="; #str(*options);
      writeLine("stdout", "cleanup: local: *local");
      writeLine("stdout", "cleanup: outFeatDir: *outFeatDir");
      writeLine("stdout", "cleanup: tempStr: *tempStr");
      # Get the list of bulk extractor-examined files and copy one by one
      # Shell script bcListDir is used to list the files in the
      # temporary directory created in /tmp (on UNIX: /bin/ls -1 $dir)
      *a1 = execCmdArg(*tempStr);
      #writeLine("stdout", "Calling script bcListDir with arg *a1");
      #msiExecCmd("bcListDir.sh",*a1, "null", "null", "null", *Result);
      msiExecCmd("bcListDir.sh",*a1, "null", "null", "null", *Result);
      msiGetStdoutInExecCmdOut(*Result, *Out);
      # Call split to put the listed files in an array
      *a = split(*Out, "\n");
      #writeLine("stdout", "Debug: Files in the array are  *a ");
      foreach (*item in *a) {
         *path = *tempStr++"/"++*item;
         msiSplitPath(*path, *Coll, *file);
         #*local = "localPath=*tempStr++++forceFlag=";
         *local = "localPath=*path++++forceFlag=";
         # ensure output directory exists
	 *new_outFeatDir = *outFeatDir++"/"++*prefixStr;
	 isColl(*new_outFeatDir,"stdout",*status);
         # Copy the files from the /tmp/*outFeatDir location to the grid
         *new_outFeatPath = *new_outFeatDir++"/"++*file;
         # Call msiDataObjPut to do the copy of the file
         #writeLine("stdout", "Debug: copyFiles: Copying to file new_outFeatPath: *new_outFeatPath");
         msiDataObjPut(*new_outFeatPath, "null", *local, *status);
      }
      # Remove working dirs
      msiExecCmd("bcRmTmp.sh", "null", "null", "null", "null", *Result);
   }
}

INPUT *Coll="/RODS_ZONE/home/PRESERVATION_USER/dvn_preservation", *outFeatDir="/RODS_ZONE/home/PRESERVATION_USER/bitcurator_output", *Archivist="CURATOR_EMAIL"
OUTPUT ruleExecOut
