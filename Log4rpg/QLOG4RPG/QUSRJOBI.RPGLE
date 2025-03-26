      /IF NOT DEFINED(QUSRJOBI)
      /DEFINE QUSRJOBI
      *
      *  Retrieve Job Information (QUSRJOBI) API
     D QUSRJOBI        PR                  extpgm('QUSRJOBI')
     D  o_rcvVar                  32767A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  i_qJob                       26A   const
     D  i_intJobID                   16A   const
     D  io_errCode                32767A          options(*varsize)
      *
     D jobi0600_t      DS                  qualified template
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  job                          10A
     D  user                         10A
     D  nbr                           6A
     D  intJobID                     16A
     D  status                       10A
     D  type                          1A
     D  subType                       1A
     D  jobSws                        8A
     D  endStatus                     1A
     D  sbsD                         10A
     D  sbsDLib                      10A
     D  curUser                      10A
     D  dbcs                          1A
     D  exitKey                       1A
     D  cancelKey                     1A
     D  prdRetCode                   10I 0
     D  userRetCode                  10I 0
     D  pgmretCode                   10I 0
     D  spcEnv                       10A
     D  device                       10A
     D  grpPrf                       10A
     D  grpPrfAry                    10A   dim(15)
     D  jobUsrID                     10A
     D  jobUsrIDStg                   1A
      *
      /ENDIF
