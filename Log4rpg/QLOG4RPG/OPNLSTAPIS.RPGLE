      *
     D qgy_opnListInf_t...
     D                 DS                  qualified               based(pDummy)
     D  totalRcds                    10I 0
     D  rcdsRet                      10I 0
     D  hRequest                      4A
     D  rcdLen                       10I 0
     D  infComplInd                   1A
     D  dateTimeCrt                  13A
     D  listStatInd                   1A
     D  reserved_01                   1A
     D  lenInfRet                    10I 0
     D  firstRcdInRcv                10I 0
     D  reserved_02                  40A
      *
      *  Get List Entries (QGYGTLE) API
     D QGYGTLE...
     D                 PR                  extpgm('QGYGTLE')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_rcvVarLen                  10I 0 const
     D  i_hRequest                    4A   const
     D  o_opnListInf                 80A
     D  i_numRcdRtn                  10I 0 const
     D  i_startRcd                   10I 0 const
     D  io_errCode                65535A          options(*varsize)
      *
      *  Close List (QGYCLST) API
     D QGYCLST...
     D                 PR                  extpgm('QGYCLST')
     D  i_hRequest                    4A   const
     D  io_errCode                65535A          options(*varsize)
      *
      *  Open List of Objects (QGYOLOBJ) API
     D QGYOLOBJ...
     D                 PR                         extpgm('QGYOLOBJ')
     D  o_rcvVar                  32767A          options(*varsize )
     D  i_lenRcvVar                  10I 0 const
     D  o_listInf                    80A
     D  i_numRcdRet                  10I 0 const
     D  i_sortInf                 32767A   const  options(*varsize )
     D  i_qObj                       20A   const
     D  i_objType                    10A   const
     D  i_authCtrl                32767A   const  options(*varsize )
     D  i_selectCtrl              32767A   const  options(*varsize )
     D  i_numFldRet                  10I 0 const
     D  i_keyOfFldRet             32767A   const  options(*varsize )
     D  io_ErrCode                32767A          options(*varsize )
      *
     D qgy_selectCtrl_t...
     D                 DS                  qualified               based(pDummy)
     D  length                       10I 0
     D  value                        10I 0
     D  ofsStat                      10I 0
     D  numStat                      10I 0
     D  reserved_1                   10I 0
     D  statList                           likeds(qgy_statList_t   )
      *
     D qgy_statList_t...
     D                 DS                  qualified   based(pDummy)
     D  stat                          1A   dim(16)
      *
     D qgy_authCtrl_t...
     D                 DS                  qualified               based(pDummy)
     D  length                       10I 0
     D  callLvl                      10I 0
     D  ofsObjAuth                   10I 0
     D  numObjAuth                   10I 0
     D  ofsLibAuth                   10I 0
     D  numLibAuth                   10I 0
     D  reserved_1                    4A
     D  objAuthList                        likeds(qgy_authList_t   )
     D  libAuthList                        likeds(qgy_authList_t   )
      *
     D qgy_authList_t...
     D                 DS                  qualified               based(pDummy)
     D  auth                         10A   dim(16)
      *
     D qgy_sortInf_t...
     D                 DS                  qualified               based(pDummy)
     D  numE                         10I 0
     D  sortInfE                           likeds(qgy_sortInfE_t   )
     D                                     dim(16)
      *
     D qgy_sortInfE_t...
     D                 DS                  qualified               based(pDummy)
     D  startPos                     10I 0
     D  length                       10I 0
     D  dataType                      5I 0
     D  order                         1A
     D  reserved_1                    1A
      *
     D qgy_objInf_t...
     D                 DS                  qualified               based(pDummy)
     D  name                         10A
     D  lib                          10A
     D  type                         10A
     D  infStat                       1A
     D  reserved_1                    1A
     D  numFldRet                    10I 0
      *
