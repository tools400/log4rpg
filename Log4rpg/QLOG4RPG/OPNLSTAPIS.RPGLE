**free

dcl-ds qgy_opnListInf_t qualified based(pDummy);
  totalRcds     int(10);
  rcdsRet       int(10);
  hRequest      char(4);
  rcdLen        int(10);
  infComplInd   char(1);
  dateTimeCrt   char(13);
  listStatInd   char(1);
  reserved_01   char(1);
  lenInfRet     int(10);
  firstRcdInRcv int(10);
  reserved_02   char(40);
end-ds;

//  Get List Entries (QGYGTLE) API
dcl-pr QGYGTLE extpgm('QGYGTLE');
  o_rcvVar     char(65535) options(*varsize);
  i_rcvVarLen  int(10) const;
  i_hRequest   char(4) const;
  o_opnListInf char(80);
  i_numRcdRtn  int(10) const;
  i_startRcd   int(10) const;
  io_errCode   char(65535) options(*varsize);
end-pr;

//  Close List (QGYCLST) API
dcl-pr QGYCLST extpgm('QGYCLST');
  i_hRequest char(4) const;
  io_errCode char(65535) options(*varsize);
end-pr;

//  Open List of Objects (QGYOLOBJ) API
dcl-pr QGYOLOBJ extpgm('QGYOLOBJ');
  o_rcvVar      char(32767) options(*varsize);
  i_lenRcvVar   int(10) const;
  o_listInf     char(80);
  i_numRcdRet   int(10) const;
  i_sortInf     char(32767) options(*varsize) const;
  i_qObj        char(20) const;
  i_objType     char(10) const;
  i_authCtrl    char(32767) options(*varsize) const;
  i_selectCtrl  char(32767) options(*varsize) const;
  i_numFldRet   int(10) const;
  i_keyOfFldRet char(32767) options(*varsize) const;
  io_ErrCode    char(32767) options(*varsize);
end-pr;

dcl-ds qgy_selectCtrl_t qualified based(pDummy);
  length     int(10);
  value      int(10);
  ofsStat    int(10);
  numStat    int(10);
  reserved_1 int(10);
  statList   likeds(qgy_statList_t);
end-ds;

dcl-ds qgy_statList_t qualified based(pDummy);
  stat char(1) dim(16);
end-ds;

dcl-ds qgy_authCtrl_t qualified based(pDummy);
  length      int(10);
  callLvl     int(10);
  ofsObjAuth  int(10);
  numObjAuth  int(10);
  ofsLibAuth  int(10);
  numLibAuth  int(10);
  reserved_1  char(4);
  objAuthList likeds(qgy_authList_t);
  libAuthList likeds(qgy_authList_t);
end-ds;

dcl-ds qgy_authList_t qualified based(pDummy);
  auth char(10) dim(16);
end-ds;

dcl-ds qgy_sortInf_t qualified based(pDummy);
  numE     int(10);
  sortInfE likeds(qgy_sortInfE_t) dim(16);
end-ds;

dcl-ds qgy_sortInfE_t qualified based(pDummy);
  startPos   int(10);
  length     int(10);
  dataType   int(5);
  order      char(1);
  reserved_1 char(1);
end-ds;

dcl-ds qgy_objInf_t qualified based(pDummy);
  name       char(10);
  lib        char(10);
  type       char(10);
  infStat    char(1);
  reserved_1 char(1);
  numFldRet  int(10);
end-ds;
