**free
/if NOT DEFINED(CLIB2)
/define CLIB2

//  File open feedback data structure
dcl-ds RFILE_t based(pDummy) qualified;
  res01   char(16);
  pInBuf  pointer;
  pOutBuf pointer;
  res02   char(48);
end-ds;
/if not defined(*V5R3M0)
     D  riofb                              like(RIOFB_t)
/else
D  riofb                              likeds(RIOFB_t)
/endif
D  res03                        32A
D  bufLen                       10U 0
D  res04                        28A
D  pInNull                        *
D  pOutNul                        *
D  pKeyNul                        *
D  res05                        48A
D  minLen                       10I 0
D  nMapLen                       5I 0
D  nKeyLen                       5I 0
D  res06                         8A
//
//  Record IO feedback data structure
dcl-ds RIOFB_t based(pDummy)  align  qualified;
pKey            pointer;
pSysP           pointer;
rrn             uns(10);
numByt          int(10);
blkCnt          int(5);
blkFld          char(1);
bitfld          char(1);
dupKy           char(1) overlay(bitfld: 1);
icfLc           char(1) overlay(bitfld: 1);
res01           char(1) overlay(bitfld: 1);
res02           char(20);
end-ds;

//  Constants used by IO feedback procedures
dcl-c RRN_EQ x'08000300';

dcl-c KEY_EQ x'0B000100';
dcl-c KEY_GT x'0D000100';
dcl-c KEY_LT x'09000100';
dcl-c KEY_LE x'0A000100';
dcl-c KEY_GE x'0C000100';
dcl-c KEY_NEXTUNQ x'05000100';
dcl-c KEY_PREVUNQ x'06000100';
dcl-c KEY_NEXTEQ x'0E000100';
dcl-c KEY_PREVEQ x'0F000100';

dcl-c FIRST x'01000300';
dcl-c LAST x'02000300';
dcl-c NEXT x'03000300';
dcl-c PREVIOUS x'04000300';

dcl-c START_FRC x'03000004';
dcl-c START x'01000004';
dcl-c END_FRC x'04000004';
dcl-c END x'02000004';

dcl-c NO_LOCK x'00000001';
dcl-c DFT x'0B000100';
dcl-c NO_POSITION x'00100000';
dcl-c PRIOR x'00001000';
dcl-c DATA_ONLY x'00000002';
dcl-c NULL_KEY_MAP x'00000008';

dcl-c EOF -1;

//  _Ropen -- Open a Record File for I/O Operatins                                      R
//    #include <recio.h>
//    _RFILE *_Ropen(const char * filename, const char * mode, ...);
dcl-pr Ropen pointer extproc('_Ropen'); // _RFILE
  i_fileName pointer options(*string) value;
  i_mode     pointer options(*string) value;
end-pr;

//  _Rclose -- Close a File
//    #include <recio.h>
//    int _Rclose(_RFILE *fp);
dcl-pr Rclose int(10) extproc('_Rclose');
  i_fp pointer value;
end-pr;

//  _Rlocate -- Position to a Record
//    #include <recio.h>
//    _RIOFB_T *_Rlocate(_RFILE *fp, void *key, int klen_rrn, int opts);
dcl-pr Rlocate pointer extproc('_Rlocate'); // _RIOFB_T
  i_fp       pointer value;
  i_key      pointer value;
  i_klen_rrn int(10) value;
  i_opts     int(10) value;
end-pr;

//  _Rreadd -- Read a Record by Relative Record Number
//    #include <recio.h>
//    _RIOFB_T *_Rreadd (_RFILE *fp, void *buf, size_t size,
//                                int opts, long rrn);
dcl-pr Rreadd pointer extproc('_Rreadd'); // _RIOFB_T
  i_fp      pointer value;
  i_pBuffer pointer value;
  i_size    uns(10) value;
  i_opts    int(10) value;
  i_rrn     int(10) value;
end-pr;

//  _Rreadn -- Read the next Record
//    #include <recio.h>
//    _RIOFB_T *_Rreadn (_RFILE *fp, void *buf, size_t size, int opts);
dcl-pr Rreadn pointer extproc('_Rreadn'); // _RIOFB_T
  i_fp      pointer value;
  i_pBuffer pointer value;
  i_size    uns(10) value;
  i_opts    int(10) value;
end-pr;

//  _Rreadk -- Read a Record by Key
//    #include <recio.h>
//    _RIOFB_T *_Rreadk(_RFILE *fp, void *buf, size_t size,
//                       int opts, void *key, unsigned int keylen);
dcl-pr Rreadk pointer extproc('_Rreadk'); // _RIOFB_T
  i_fp      pointer value;
  i_pBuffer pointer value;
  i_size    uns(10) value;
  i_opts    int(10) value;
  i_key     pointer value;
  i_klen    int(10) value;
end-pr;

//  _Rreads -- Read the Same Record
//    #include <recio.h>
//    _RIOFB_T *_Rreads(_RFILE *fp, void *buf, size_t size, int opts);
dcl-pr Rreads pointer extproc('_Rreads'); // _RIOFB_T
  i_fp      pointer value;
  i_pBuffer pointer value;
  i_size    uns(10) value;
  i_opts    int(10) value;
end-pr;

//  _Rrlslck -- Release a Record Lock
//    #include <recio.h>
//    int _Rrlslck(_RFILE *fp);
dcl-pr RrlsLck pointer extproc('_Rrlslck'); // int 1=success
  i_fp pointer value; //     0=error
end-pr;
//  _Rupdate -- Update a Record
//    #include <recio.h>
//    _RIOFB_T *_Rupdate(_RFILE *fp, void *buf, size_t size);
dcl-pr Rupdate pointer extproc('_Rupdate'); // _RIOFB_T
  i_fp pointer value;
end-pr;
/if defined(RUPDATE_OPTIONS_STRING)
     D  i_pBuffer                      *   value  options(*string)
/else
D  i_pBuffer                      *   value
/endif
D  i_size                       10U 0 value
//
//
//  _Rwrite -- Write the next record
//    #include <recio.h>
//    _RIOFB_T * _Rwrite(_RFILE *fp, void *buf, size_t size);
dcl-pr Rwrite pointer extproc('_Rwrite'); // _RIOFB_T
  i_fp pointer value;
end-pr;
/if defined(RWRITE_OPTIONS_STRING)
     D  i_pBuffer                      *   value  options(*string)
/else
D  i_pBuffer                      *   value
/endif
D  i_size                       10U 0 value
//
//  _Rwrited -- Write a Record Directly
//    #include <recio.h>
//    _RIOFB_T *_Rwrited(_RFILE *fp, void *buf, size_t size, unsigned long rrn);
dcl-pr Rwrited pointer extproc('_Rwrited'); // _RIOFB_T
  i_fp pointer value;
end-pr;
/if defined(RWRITE_OPTIONS_STRING)
     D  i_pBuffer                      *   value  options(*string)
/else
D  i_pBuffer                      *   value
/endif
D  i_size                       10U 0 value
D  i_rrn                        10U 0 value
//
//  _Rformat -- Set the Record Format Name
//    #include <recio.h>
//    void  _Rformat(_RFILE *fp, char *fmt);
dcl-pr Rformat extproc('_Rformat'); // void
  i_handle pointer value;
  i_format pointer options(*string) value;
end-pr;

/endif
