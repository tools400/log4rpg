      /IF NOT DEFINED(jobi0600_t)
      /DEFINE jobi0600_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0600                                      *
      *===============================================================*
      *
     D jobi0600_t      DS                  qualified           based(pDummy)
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
