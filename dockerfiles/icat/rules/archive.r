myArchiveRule {
# Loop over files in a collection, *Src 
# Put all files into a staging collection. *Dest
  *Len = strlen(*Src);

#=============get current time, Timestamp is YYY-MM-DD.hh:mm:ss  ======================
  msiGetSystemTime(*TimeH,"human");
  msiGetSystemTime(*TimeA,"unix");

#============ create a collection for log files if it does not exist ===============
  *LPath = "/RODS_ZONE/home/PRESERVATION_USER/archive_logs";
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
    if(*Coll != "*LPath") {
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
       msiSetACL("default","own","odum_fed#dfcmain", *Dest1);
       msiDataObjChksum(*Dest1, "forceChksum=", *Chksum);
       if (*Check != *Chksum) {
         writeLine("*Lfile", "Bad checksum for file *Dest1");
	 writeLine("stdout", "*Check doesn't match *Chksum");
       }
       else {
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
INPUT *Res="demoResc", *Src="/RODS_ZONE/home/PRESERVATION_USER/dvn_preservation", *Dest="/PRESERVATION_ZONE/RODS_ZONE/dvn_preservation"
OUTPUT ruleExecOut
