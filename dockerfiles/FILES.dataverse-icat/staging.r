myStagingRule {
# Loop over files in a collection, *Src 
# Put all files into a staging collection. *Dest
  *Len = strlen(*Src);

#=============get current time, Timestamp is YYY-MM-DD.hh:mm:ss  ======================
  msiGetSystemTime(*TimeH,"human");
  msiGetSystemTime(*TimeA,"unix");

#============ create a collection for log files if it does not exist ===============
  *LPath = "/dvnZone/home/dataverse/staging_logs";
  isColl(*LPath,*Status);

#============ create file into which results will be written =========================
  *Lfile = "*LPath/Check-*TimeH";
  *Dfile = "destRescName=*Res++++forceFlag=";
  msiDataObjCreate(*Lfile, *Dfile, *L_FD);

#============ find files to stage
  *Query = select DATA_NAME, DATA_CHECKSUM, COLL_NAME, DATA_MODIFY_TIME where COLL_NAME like '*Src%';
  foreach(*Row in *Query) {
    *File = *Row.DATA_NAME;
    *Check = *Row.DATA_CHECKSUM;
    *Coll = *Row.COLL_NAME;
    *Path = "*Coll/*File";
    *Q1 = select count(META_DATA_ATTR_VALUE) where DATA_NAME = '*File' and COLL_NAME = '*Coll' and META_DATA_ATTR_NAME = 'Staged';
    *Process = 0;
    *Staged = "0";
    *Num = "0";
    foreach(*R1 in *Q1) {
       *Num = *R1.META_DATA_ATTR_VALUE;
       if(*Num == "0") {
          *Process = 1;
       } else {
          *Q2 = select META_DATA_ATTR_VALUE, META_DATA_CREATE_TIME where DATA_NAME = '*File' and COLL_NAME = '*Coll' and META_DATA_ATTR_NAME = 'Staged';
          *DataModify = *Row.DATA_MODIFY_TIME;
          foreach(*R2 in *Q2) {
             *Staged = *R2.META_DATA_ATTR_VALUE;
             *MetaDataCreateTime = *R2.META_DATA_CREATE_TIME;
            if(*Staged == "0" || double(*DataModify) > double(*MetaDataCreateTime)) { *Process = 1; }
          }
       }
    }
    if(*Coll != "*LPath" && *Process == 1) {
       *L1 = strlen(*Coll);
       *Src1 = *Coll ++ "/" ++ *File;
       *C1 = substr(*Coll,*Len,*L1);
       if(strlen(*C1)==0) {
          *DestColl = *Dest;
          *Dest1 = *Dest ++ "/" ++ *File;
       } else {
          *DestColl = *Dest ++ *C1;
          *Dest1 = *Dest ++ *C1 ++ "/" ++ *File;
       }
       isColl(*DestColl,*Status);
       msiDataObjCopy(*Src1,*Dest1,"destRescName=*Res++++forceFlag=", *Status);
       # with inheritance enabled, shouldn't need to set ACLs
       #msiSetACL("default","own","odum_fed#dfcmain", *Dest1);
       writeLine("stdout","*Dest1");
       msiDataObjChksum(*Dest1, "forceChksum=", *Chksum);
       if (*Check != *Chksum) {
         writeLine("*Lfile", "Bad checksum for file *Dest1");
       }
       else { writeLine("*Lfile", "Moved file *Src1 to *Dest1");
          if(*Staged != "1" && *Num != "0") {
             *Str0 = "Staged=*Staged";
             msiString2KeyValPair(*Str0,*KVP);
             msiRemoveKeyValPairsFromObj(*KVP,*Path,"-d");
          }
          if(*Num == "0") {
             *Str1 = "Staged=1";
             msiString2KeyValPair(*Str1,*KVP);
             msiAssociateKeyValuePairsToObj(*KVP,*Path,"-d");
          }
          writeLine("*Lfile","*Src1 copied to *Dest1 *Check *TimeH");
       }
     }
  }
}
isColl (*LPath,*Status) {
  *Query0 = select count(COLL_ID) where COLL_NAME = '*LPath';
  foreach(*Row0 in *Query0) {*Result = *Row0.COLL_ID;}
  if(*Result == "0" ) {
    msiCollCreate(*LPath, "1", *Status);
    if(*Status < 0) {
      writeLine("serverlog","Could not create log collection");
      fail;
    }  # end of check on status
  }  # end of log collection creation
}
INPUT *Res=$"dvnResc", *Src=$"/dvnZONE/home/dataverse/stage/dvn_backuppreservation", *Dest =$"/STAGING_RODS_ZONE/home/dataverse/dvn_backuppreservation"
OUTPUT ruleExecOut
