**free
/if NOT defined(CLIB)
/define CLIB

//  Basic C data types
/if NOT defined(C_DATA_TYPES)
/define C_DATA_TYPES
// C Data Types
dcl-s char_t char(1) based(pDummy);
dcl-s short_t int(5) based(pDummy);
dcl-s ushort_t uns(5) based(pDummy);
dcl-s int_t int(10) based(pDummy);
dcl-s uint_t uns(10) based(pDummy);
dcl-s long_t int(10) based(pDummy);
dcl-s ulong_t uns(10) based(pDummy);
dcl-s float_t float(4) based(pDummy);
dcl-s double_t float(8) based(pDummy);
/endif

//  stdin, stdout and stderr
dcl-s stdin pointer import('_C_IFS_stdin');
dcl-s stdout pointer import('_C_IFS_stdout');
dcl-s stderr pointer import('_C_IFS_stderr');

//  system -- Execute a Command
//     Return value       Meaning
//     ----------------   --------------------------------------
//     0                  the command is successful
//     -1                 for a NULL pointer
//     1                  the command fails
dcl-pr system int(10) extproc('system');
  i_clCommand pointer options(*string) value;
end-pr;

dcl-s EXCP_MSGID char(7) import('_EXCP_MSGID');

//  time -- Determine Current Time
//     The time() function returns the current calendar time.
//     The return value is also stored in the location that
//     is given by timeptr.
dcl-pr time int(10) extproc('time');
  timeptr pointer value;
end-pr;

//  strftime -- Convert to Formatted Time
//     strftime() returns the number of bytes placed into the
//     array pointed to by 'dest'.
dcl-pr strftime int(10) extproc('strftime');
  dest    pointer value;
  maxsize int(10) value;
  format  pointer options(*string) value;
  timeptr likeds(tm_t) const;
end-pr;

dcl-ds tm_t qualified based(pDummy);
  tm_sec   int(10);
  tm_min   int(10);
  tm_hour  int(10);
  tm_mday  int(10);
  tm_mon   int(10);
  tm_year  int(10);
  tm_wday  int(10);
  tm_yday  int(10);
  tm_isdst int(10);
end-ds;

//  localtime() -- Correct Local Time, returns tm_t*
//     The localtime() function converts a time value, in
//     seconds, to a structure of type tm.
dcl-pr localtime pointer extproc('localtime');
  time int(10) const;
end-pr;

//  localtime_r() -- Correct Local Time
//     It is the same as localtime() except that it passes
//     in the place to store the returned structure result.
dcl-pr localtime_r pointer extproc('localtime_r');
  time int(10) const;
  tm   likeds(tm_t) const;
end-pr;

//  strtok -- Tokenize String
//     The first time the strtok() function is called, it returns
//     a pointer to the first token in i_string. In later calls
//     it returns a pointer to the next token. A null pointer is
//     returned when there are no more tokens.
dcl-pr strtok pointer extproc('strtok');
  i_string     pointer options(*string) value;
  i_delimiters pointer options(*string) value;
end-pr;

//  atoi -- Convert Character String to Integer
//     The atoi() function returns an int value of the
//     interpreted input string.
dcl-pr atoi int(10) extproc('atoi');
  i_string pointer options(*string) value;
end-pr;

//  memcpy -- Copy Bytes
//     The behavior is undefined if copying takes place
//     between objects that overlap.
//     The memcpy() function returns a pointer to dest.
dcl-pr memcpy pointer extproc('memcpy');
  i_pDest pointer value;
  i_pSrc  pointer value;
  i_count uns(10) value;
end-pr;

//  memset -- Set Bytes to Value
//     The memset() function returns a pointer to dest.
dcl-pr memset pointer extproc('memset');
  i_pDest pointer value;
  i_char  int(10) value;
  i_count uns(10) value;
end-pr;

//  memmove -- Copy Bytes
//     memmove allows copying between objects that may overlap
//     as if src is first copied into a temporary array.
//     The memmove() function returns a pointer to dest.
dcl-pr memmove pointer extproc('memmove');
  pMemDest pointer value;
  pMemSrc  pointer value;
  memSize  like(size_t) value;
end-pr;

//  memcmp -- Compare Buffers
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        buf1 less than buf2
//     0                  buf1 identical to buf2
//     Greater than 0     buf1 greater than buf2
dcl-pr memcmp int(10) extproc('memcmp');
  pBuf1 pointer value;
  pBuf2 pointer value;
  count like(size_t) value;
end-pr;

//  memicmp -- Compare Bytes (ignore case)
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        buf1 less than buf2
//     0                  buf1 identical to buf2
//     Greater than 0     buf1 greater than buf2
dcl-pr memicmp int(10) extproc('__memicmp');
  pBuf1 pointer value;
  pBuf2 pointer value;
  count uns(10) value;
end-pr;

//  strcmp() -- Compare Strings
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        string 1 less than string 2
//     0                  string 1 equivalent to string 2
//     Greater than 0     string 1 greater than string 2
dcl-pr strcmp int(10) extproc('strcmp');
  string1 pointer options(*string) value;
  string2 pointer options(*string) value;
end-pr;

//  strcasecmp() -- Compare Strings without Case Sensitivity
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        string 1 less than string 2
//     0                  string 1 equivalent to string 2
//     Greater than 0     string 1 greater than string 2
dcl-pr strcasecmp int(10) extproc('strcasecmp');
  string1 pointer options(*string) value;
  string2 pointer options(*string) value;
end-pr;
/if NOT defined(TESTPTR)
/define TESTPTR

//  Test Pointer (TESTPTR)
dcl-pr testptr int(10) extproc('_TESTPTR');
  i_ptr       pointer value;
  i_test_type int(10) value;
end-pr;

dcl-c cTESTPTR_TYPE_PROCPTR 0;
dcl-c cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING 0;
dcl-c cTESTPTR_OPTIMIZED_PARAMETER_PASSING 1;

dcl-c cTESTPTR_TYPE_MEMPTR 1;
dcl-c cTESTPTR_NON_TERASPACE 0;
dcl-c cTESTPTR_TERASPACE 1;

dcl-c cTESTPTR_ERROR_NOT_EXIST x'2401';
dcl-c cTESTPTR_ERROR_INVALID x'2402';
dcl-c cTESTPTR_ERROR_OBJECT_DESTROYED x'2202';
/endif

//  malloc() - Reserve Storage Block
dcl-pr TS_malloc pointer extproc('_C_TS_malloc');
  i_size uns(10) value;
end-pr;

//  realloc() - Change Reserved Storage Block Size
dcl-pr TS_realloc pointer extproc('_C_TS_realloc');
  i_pMem pointer value;
  i_size uns(10) value;
end-pr;

//  free() - Release Storage Blocks
dcl-pr TS_free extproc('_C_TS_free');
  i_pMem pointer value;
end-pr;

//  _C_TS_malloc_info() - Determine amount of teraspace memory used
dcl-pr TS_malloc_info int(10) extproc('_C_TS_malloc_info');
  o_c_mallinfo likeds(C_mallinfo_t) const;
  i_size       uns(10) value;
end-pr;

//  _C_TS_malloc_debug() - Determine amount of teraspace memory
//                         used (with optional dumps and verification)
dcl-pr TS_malloc_debug int(10) extproc('_C_TS_malloc_debug');
  i_dump_level uns(10) value;
  i_vrfy_level uns(10) value;
  o_c_mallinfo likeds(C_mallinfo_t) const;
  i_size       uns(10) value;
end-pr;

// The following are possible values for the dump_level parameter
dcl-c C_NO_DUMPS 0;
//  Dumps the _C_mallinfo_t structure:
dcl-c C_DUMP_TOTALS 1;
//  Does a hex dump of all allocated chunks of teraspace storage,
//  this is the entire 512K chunk of storage:
dcl-c C_DUMP_CHUNKS 2;
//  Dumps each of the allocated nodes.
//  There is a node for each malloc performed with the header
//  associated with that malloc:
dcl-c C_DUMP_NODES 3;
//  Dumps the cartesian tree used to keep track of the freed nodes:
dcl-c C_DUMP_TREE 4;
dcl-c C_DUMP_ALL 9999;

//  The following are possible values for the verify_level parameter
dcl-c C_NO_CHECKS 0;
dcl-c C_CHECK_TOTALS 1;
dcl-c C_CHECK_CHUNKS 2;
dcl-c C_CHECK_NODES 3;
dcl-c C_CHECK_TREE 4;
dcl-c C_CHECK_ALL 9998;
//  Will call abort() if verification fails
dcl-c C_CHECK_ALL_AND_ABORT 9999;

// The following structure is used to return information
// from the _C_TS_malloc_info routine.  The fields are:
//   total_bytes        - bytes allocated from system
//                        (high water mark)
//   allocated_bytes    - number of allocated bytes
//   unallocated_bytes  - number of unallocated bytes
//   allocated_blocks   - number of allocated blocks
//   unallocated_blocks - number of unallocated blocks
//   requested_bytes    - bytes actually requested from malloc
//   pad_bytes          - bytes used to pad allocation length
//                        to a multiple of 16
//   overhead_bytes     - bytes used for malloc overhead
dcl-ds C_mallinfo_t qualified based(pDummy);
  total_bytes        int(20);
  allocated_bytes    int(20);
  unallocated_bytes  int(20);
  allocated_blocks   int(20);
  unallocated_blocks int(20);
  requested_bytes    int(20);
  pad_bytes          int(20);
  overhead_bytes     int(20);
end-ds;

//  malloc -- Reserve Storage Block
dcl-pr malloc pointer extproc('malloc');
  i_size uns(10) value;
end-pr;

//  realloc -- Change Reserved Storage Block Size
dcl-pr realloc pointer extproc('realloc');
  i_pMem pointer value;
  i_size uns(10) value;
end-pr;

//  free -- Release Storage Blocks
dcl-pr free extproc('free');
  i_pMem pointer value;
end-pr;

//  srand -- Set Seed for rand Function   e.g.:   srand(getSeed(*null))
dcl-pr srand extproc('srand');
  i_seed uns(10) value;
end-pr;

//  rand -- Generate Random Number                x = rand()
dcl-pr rand int(10) extproc('rand');
end-pr;

dcl-c RAND_MAX 32767;

//  getSeed -- Get Seed for srand function
dcl-pr getSeed int(10) extproc('time');
  i_timePtr pointer value;
end-pr;

//  strlen -- Determine String Length
dcl-pr strlen uns(10) extproc('strlen');
  i_string pointer value;
end-pr;

//  tmpnam -- Produce Temporary File Name
dcl-pr tmpnam pointer extproc('tmpnam');
  pTmpNme pointer value;
end-pr;

//  _C_IFS_tmpnam -- Produce Temporary File Name for the IFS file system
dcl-pr ifs_tmpnam pointer extproc('_C_IFS_tmpnam');
  fileName pointer value;
end-pr;

dcl-c L_tmpnam 39; // ! <stdio.h>

dcl-c TMP_MAX 32767; // ! <stdio.h>

//  qsort -- Sort Array
dcl-pr qsort pointer extproc('qsort');
  memPtr    pointer value;
  numElem   like(size_t) value;
  width     like(size_t) value;
  pSortFunc pointer(*proc) value;
end-pr;

//  bsearch -- Search Arrays
dcl-pr bsearch pointer extproc('bsearch');
  keyPtr     pointer value;
  memPtr     pointer value;
  numElem    like(size_t) value;
  width      like(size_t) value;
  pSearchFnc pointer(*proc) value;
end-pr;

//  iconv_open()--Code Conversion Allocation API
dcl-pr iconv_open extproc('iconv_open') like(iconv_t);
  i_toCode   pointer value;
  i_fromCode pointer value;
end-pr;

dcl-ds iconv_t qualified based(pDummy) align;
  return_value int(10);
  cd           int(10) dim(12);
end-ds;

dcl-ds iconv_fromcode_t qualified based(pDummy);
  ibmccsid      char(8);
  ccsid         char(5);
  convAlt       char(3);
  substAlt      char(1);
  shiftStateAlt char(1);
  inpLengthOpt  char(1);
  errOption     char(1);
  reserved      char(12);
end-ds;

dcl-ds iconv_tocode_t qualified based(pDummy);
  ibmccsid char(8);
  ccsid    char(5);
  reserved char(19);
end-ds;

//  QtqIconvOpen()--Code Conversion Allocation API
dcl-pr QtqIconv_open extproc('QtqIconvOpen') likeds(iconv_t);
  i_toCode   likeds(QtqCode_t) const;
  i_fromCode likeds(QtqCode_t) const;
end-pr;

dcl-ds QtqCode_t qualified based(pDummy);
  ccsid         int(10);
  conversionA   int(10);
  substitutionA int(10);
  shiftStateA   int(10);
  inpLenOpt     int(10);
  errOptMxdDta  int(10);
  reserved      char(12);
end-ds;

//  iconv()--Code Conversion API
dcl-pr iconv uns(10) extproc('iconv');
  i_cd         likeds(iconv_t) value;
  i_pInBuf     pointer;
  i_inBytLeft  uns(10);
  i_pOutBuf    pointer;
  i_outBytLeft uns(10);
end-pr;

dcl-c cICONV_ERROR 4294967295;

//  iconv_close()--Code Conversion Deallocation API
dcl-pr iconv_close int(10) extproc('iconv_close');
  i_cd likeds(iconv_t) value;
end-pr;

//  0/-1 = stat()--Get File Information                include <sys/stat.h>
dcl-pr stat int(10) extproc('stat'); // = int
  i_pPath pointer options(*string) value; // = *path
  i_pStat pointer value; // = *buf
end-pr;

//  0/-1 = fstat()--Get File Information by Descriptor include <sys/stat.h>
dcl-pr fstat int(10) extproc('fstat'); // = int
  i_fd   int(10) value; // = int
  i_stat likeds(st_stat_t) const; // = *buf
end-pr;

//  0/-1 = lstat()--Get File or Link Information       include <sys/stat.h>
dcl-pr lstat int(10) extproc('lstat'); // = int
  i_pPath pointer options(*string) value; // = *path
  i_pStat pointer value; // = *buf
end-pr;

dcl-ds st_stat_t qualified based(pDummy) align;
  mode       uns(10); // mode_t =uint
  ino        uns(10); // ino_t  =uint
  nlink      uns(5); // nlink_t=ushort
  reserved2  char(2);
  uid        uns(10); // uid_t  =uint
  gid        uns(10); // gid_t  =uint
  size       int(10); // off_t  =int
  atime      int(10); // time_t =long
  mtime      int(10); // time_t =long
  ctime      int(10); // time_t =long
  dev        uns(10); // dev_t  =uint
  blksize    uns(10); // size_t =uint
  allocsize  uns(10); // ulong
  objtype    char(11); // qp0l_objtype_t
  reserved3  char(1);
  codepage   uns(5); // ushort
  ccsid      uns(5); // ushort
  rdev       uns(10); // dev_t  =uint
  nlink32    uns(10); // nlink32_t=ulng
  rdev64     uns(20); // dev64_t=ullng
  dev64      uns(20); // dev64_t=ullng
  reserved1  char(36);
  ino_gen_id uns(10); // uint
end-ds;

//  Qp0lGetAttr()--Get Attributes
dcl-pr Qp0lGetAttr int(10) extproc('Qp0lGetAttr');
  i_path       likeds(Qlg_Path_Name_t) const;
  i_attrArray  like(Qlg_attrArray_t) const;
  i_pBuffer    pointer value;
  i_bytPrv     uns(10) value;
  o_sizeNeeded uns(10);
  o_bytRet     uns(10);
  i_followLnk  uns(10) value;
end-pr;

/if not defined(Qlg_Path_Name)
/define Qlg_Path_Name
dcl-ds Qlg_Path_Name_t qualified align based(pDummy);
  CCSID               int(10);
  Country_ID          char(2);
  Language_ID         char(3);
  Reserved            char(3);
  Path_Type           uns(10);
  Path_Length         int(10);
  Path_Name_Delimiter char(2);
  Reserved2           char(10);
  Path_Name           char(256);
end-ds;

dcl-c QLG_PATH_JOB_CCSID 0;
dcl-c QLG_PATH_JOB_COUNTRYID X'0000';
dcl-c QLG_PATH_JOB_LANGUAGEID X'000000';

//  The Path_Name is a character string and the delimiter is one byte long.
dcl-c QLG_CHAR_SINGLE 0;

//  The Path_Name is a pointer and the delimiter is one byte long.
dcl-c QLG_PTR_SINGLE 1;

//  The Path_Name is a character string and the delimiter is two bytes long.
dcl-c QLG_CHAR_DOUBLE 2;

//  The Path_Name is a pointer and the delimiter is two bytes long.
dcl-c QLG_PTR_DOUBLE 3;

/endif

dcl-ds Qlg_attrArray_t qualified based(pDummy);
  numE int(10);
  attr int(10) dim(64);
end-ds;

dcl-ds Qlg_rtnAttr_t qualified based(pDummy);
  ofsNextAttr int(10);
  ID          int(10);
  size        int(10);
  reserved    char(4);
end-ds;

dcl-c QP0L_ATTR_OBJTYPE 0; // CHAR(10)
dcl-c QP0L_ATTR_DATA_SIZE 1; // UINT(4)
dcl-c QP0L_ATTR_ALLOC_SIZE 2; // UINT(4)
dcl-c QP0L_ATTR_EXTENDED_ATTR_SIZE 3; // UINT(4)
dcl-c QP0L_ATTR_CREATE_TIME 4; // UINT(4)
dcl-c QP0L_ATTR_ACCESS_TIME 5; // UINT(4)
dcl-c QP0L_ATTR_CHANGE_TIME 6; // UINT(4)
dcl-c QP0L_ATTR_MODIFY_TIME 7; // UINT(4)
dcl-c QP0L_ATTR_STG_FREE 8; // CHAR(1)
dcl-c QP0L_ATTR_CHECKED_OUT 9; // chkOut Fmt
dcl-c QP0L_ATTR_LOCAL_REMOTE 10; // CHAR(1)

dcl-c QP0L_DONOT_FOLLOW_SYMLNK x'00';
dcl-c QP0L_FOLLOW_SYMLNK x'01';

dcl-c QP0L_NOT_CHECKED_OUT x'00';
dcl-c QP0L_CHECKED_OUT x'01';

dcl-c QP0L_LOCAL_OBJ x'01';
dcl-c QP0L_REMOTE_OBJ x'02';

//  QlgGetcwd()--Get Current Directory (using NLS-enabled path name)
//  Returns: Qlg_Path_Name_T
dcl-pr QlgGetcwd pointer extproc('QlgGetcwd');
  o_path likeds(Qlg_Path_Name_t) const;
  i_size like(size_t) value;
end-pr;

//  getcwd()--Get Current Directory
dcl-pr getcwd pointer extproc('getcwd');
  o_path char(65535) options(*varsize) const;
  i_size like(size_t) value;
end-pr;

//  QlgChdir()--Change Current Directory (using NLS-enabled path name)
//  Returns: Qlg_Path_Name_T
dcl-pr QlgChdir int(10) extproc('QlgChdir');
  i_path likeds(Qlg_Path_Name_t) const;
end-pr;

//  chdir()--Change Current Directory
dcl-pr chdir int(10) extproc('chdir');
  i_path pointer options(*string) value;
end-pr;

//  QSYSINC/SYS.TYPES
dcl-s off_t int(10) based(pDummy);
dcl-s size_t uns(10) based(pDummy);
dcl-s ssize_t int(10) based(pDummy);
dcl-s time_t int(10) based(pDummy);

//  0/-1 = chmod()--Change File Authorizations         include <sys/stat.h>
dcl-pr chmod int(10) extproc('chmod'); // = int
  i_pPath pointer options(*string) value; // = *path
  i_mode  uns(10) value; // = mode_t =uint
end-pr;

//  mkdir()--Make Directory                            include <sys/stat.h>
dcl-pr mkdir int(10) extproc('mkdir'); // = rc
  i_pPath pointer options(*string) value; // = *path
  i_mode  uns(10) value; // = mode_t =uint
end-pr;

//  rmdir()--Remove Directory                          include <sys/stat.h>
dcl-pr rmdir int(10) extproc('rmdir'); // = rc
  i_pPath pointer options(*string) value; // = *path
end-pr;

//  opendir()--Open Directory                          include <dirent.h>
dcl-pr opendir pointer extproc('opendir'); // = *DIR
  i_pDirName pointer options(*string) value; // = *dirname
end-pr;

//  readdir()--Read Directory Entry
dcl-pr readdir pointer extproc('readdir'); // = *dirent
  i_dirp pointer value; // = *DIR
end-pr;

dcl-ds dirent_t qualified based(pDummy);
  d_reserv1       char(16);
  d_fileno_gen_id uns(10);
  d_fileno        uns(10);
  d_reclen        uns(10);
  d_reserv3       int(10);
  d_reserv4       char(8);
/if not defined(*V5R2M0)
  d_nlsinfo       like(qlg_nls_t);
/else
  d_nlsinfo       likeds(qlg_nls_t);
/endif
  d_namelen       uns(10);
  d_name          char(640);
end-ds;

dcl-ds qlg_nls_t qualified based(pDummy) align;
  ccsid        int(10);
  country_id   char(2);
  language_id  char(3);
  nls_reserved char(3);
end-ds;

//  rewinddir()--Reset Directory Stream to Beginning
dcl-pr rewinddir extproc('rewinddir');
  i_dirp pointer value; // = *DIR
end-pr;

//  closedir()--Close Directory
dcl-pr closedir int(10) extproc('closedir'); // = rc
  i_dirp pointer value; // = *DIR
end-pr;

//  fd/-1 = open()--Open File                          include <fcntl.h>
dcl-pr open int(10) extproc('open'); // = int
  i_pPath       pointer options(*string) value; // = *path
  i_opnFLag     int(10) value; // = int
  i_mode        uns(10) options(*nopass) value; // = uint
  i_codePage    uns(10) options(*nopass) value; // = uint
  i_crtCodePage uns(10) options(*nopass) value; // = uint
end-pr;

//  <sys/stat.h>
dcl-c S_IRUSR 256; // ! Read For Own
dcl-c S_IWUSR 128; // ! Write For Ow
dcl-c S_IXUSR 64; // ! Exc/Srch For
dcl-c S_IRWXU 448; // ! Rd/Wrt/Exc O

dcl-c S_IRGRP 32; // ! Read For Gro
dcl-c S_IWGRP 16; // ! Write For Gr
dcl-c S_IXGRP 8; // ! Exc/Srch For
dcl-c S_IRWXG 56; // ! Rd/Wrt/Exc G

dcl-c S_IROTH 4; // ! Read For Oth
dcl-c S_IWOTH 2; // ! Write For Ot
dcl-c S_IXOTH 1; // ! Exc/Srch For
dcl-c S_IRWXO 7; // ! Rd/Wrt/Exc O

dcl-c S_ISUID 2048;
dcl-c S_ISGID 1024;
dcl-c S_ISVTX 512;

//  <h/fcntl.h>
dcl-c O_CREAT 8; // ! Append Mode
dcl-c O_EXCL 16; // ! Exclusive Us
dcl-c O_TRUNC 64; // ! Truncate Fla

dcl-c O_APPEND 256; // ! Append Mode

dcl-c O_CODEPAGE 8388608; // ! Codepage Fla
dcl-c O_TEXTDATA 16777216; // ! Text Data Fl
dcl-c O_FORCE_SCAN 67108864; // ! Force scan
dcl-c O_INHERITMODE 134217728; // ! Inherit Mode
dcl-c O_CCSID 32; // ! CCSID
dcl-c O_TEXT_CREAT 33554432; // !

dcl-c O_SHARE_RDONLY 65536; // ! Shared Read
dcl-c O_SHARE_WRONLY 131072; // ! Shared Write
dcl-c O_SHARE_RDWR 262144; // ! Shared Rd/Wr
dcl-c O_SHARE_NONE 524288; // ! No Share

dcl-c O_RDONLY 1; // ! Read Only
dcl-c O_WRONLY 2; // ! Write Only
dcl-c O_RDWR 4; // ! Read/Write

//  value/-1 = read()--Write from Descriptor           include <unistd.h>
dcl-pr read extproc('read') like(ssize_t); // = ssize_t
  i_fd      int(10) value; // = int
  i_pBuffer pointer value; // = *buf
  i_buflen  like(size_t) value; // = size_t
end-pr;

//  value/-1 = write()--Write to Descriptor            include <unistd.h>
dcl-pr write extproc('write') like(ssize_t); // = ssize_t
  i_fd      int(10) value; // = int
  i_pBuffer pointer value; // = *buf
  i_buflen  like(size_t) value; // = size_t
end-pr;

//  0/-1 = ftruncate()--Truncate File                  include <unistd.h>
dcl-pr ftruncate int(10) extproc('ftruncate'); // = int
  i_fd     int(10) value; // = int
  i_length like(off_t) value; // = off_t
end-pr;

//  off_t = lseek()--Set File Read/Write Offset        include <unistd.h>
dcl-pr lseek extproc('lseek') like(off_t); // = off_t
  i_fd     int(10) value; // = int
  i_offset like(off_t) value; // = off_t
  i_whence int(10) value; // = int
end-pr;

//  <h/unistd.h>
dcl-c SEEK_SET 0; // ! seek start
dcl-c SEEK_CUR 1; // ! seek curPos
dcl-c SEEK_END 2; // ! seek end

//  0/-1 = unlink()--Remove Link to File               include <unistd.h>
dcl-pr unlink int(10) extproc('unlink'); // = int
  i_pPath pointer options(*string) value; // = *path
end-pr;

//  0/-1 = Qp0lRenameKeep()--Rename File or Directory, Keep "new" If It Exists
dcl-pr Qp0lRenameKeep int(10) extproc('Qp0lRenameKeep'); // = int
  i_pOldPath pointer options(*string) value; // = *path
  i_pNewPath pointer options(*string) value; // = *path
end-pr;

//  0/-1 = Qp0lRenameUnlink()--Rename File or Directory, Unlink "new" If It Exists
dcl-pr Qp0lRenameUnlink int(10) extproc('Qp0lRenameUnlink'); // = int
  i_pOldPath pointer options(*string) value; // = *path
  i_pNewPath pointer options(*string) value; // = *path
end-pr;

//  0/-1 = close()--Close File or Socket Descriptor    include <unistd.h>
/if NOT defined(c_close_function)
/define c_close_function
dcl-pr close int(10) extproc('close'); // = int
  i_fd int(10) value; // = int
end-pr;
/endif

//  erno--Set Pointer to Runtime Error Code
dcl-pr errno pointer extproc('__errno');
end-pr;

//  strerror -- Set Pointer to Runtime Error Message
dcl-pr strerror pointer extproc('strerror');
  errno int(10) value;
end-pr;

//  <sys/errno.h>
dcl-c EDOM_C 3001; // domain error i
dcl-c ERANGE_C 3002; // range error in
dcl-c ETRUNC_C 3003; // truncation on
dcl-c ENOTOPEN_C 3004; // file has not b
dcl-c ENOTREAD_C 3005; // file not opene
dcl-c ERECIO_C 3008; // file opened fo
dcl-c ENOTWRITE_C 3009; // file not opene
dcl-c ESTDIN_C 3010; // stdin cannot b
dcl-c ESTDOUT_C 3011; // stdout cannot
dcl-c ESTDERR_C 3012; // stderr cannot
dcl-c EBADSEEK_C 3013; // bad offset to
dcl-c EBADNAME_C 3014; // invalid file n
dcl-c EBADMODE_C 3015; // invalid file m
dcl-c EBADPOS_C 3017; // invalid positi
dcl-c ENOPOS_C 3018; // no record at s
dcl-c ENUMMBRS_C 3019; // no ftell if mo
dcl-c ENUMRECS_C 3020; // no ftell if to
dcl-c EBADFUNC_C 3022; // invalid functi
dcl-c ENOREC_C 3026; // record not fou
dcl-c EBADDATA_C 3028; // message data i
dcl-c EBADOPT_C 3040; // bad option on
dcl-c ENOTUPD_C 3041; // file not opene
dcl-c ENOTDLT_C 3042; // file not opene
dcl-c EPAD_C 3043; // padding occurr
dcl-c EBADKEYLN_C 3044; // bad key length
dcl-c EPUTANDGET_C 3080; // illegal write
dcl-c EGETANDPUT_C 3081; // illegal read a
dcl-c EIOERROR_C 3101; // I/O exception
dcl-c EIORECERR_C 3102; // I/O exception

//  The following values are defined by POSIX ISO/IEC 9945-1:1990.
dcl-c EINVAL_C 3021; // invalid argume
dcl-c EIO_C 3006; // input/output e
dcl-c ENODEV_C 3007; // no such device
dcl-c EBUSY_C 3029; // resource busy
dcl-c ENOENT_C 3025; // no such file o
dcl-c EPERM_C 3027; // operation not

//  AS/400 specific error numbers
dcl-c EACCES_C 3401; // Permission den
dcl-c ENOTDIR_C 3403; // Not a director
dcl-c ENOSPC_C 3404; // No space avail
dcl-c EXDEV_C 3405; // Improper link.
dcl-c EWOULDBLOCK_C 3406; // Operation woul
dcl-c EAGAIN_C 3406; // Operation woul
dcl-c EINTR_C 3407; // Interrupted fu
dcl-c EFAULT_C 3408; // The address us
dcl-c ETIME_C 3409; // Operation time
dcl-c ENXIO_C 3415; // No such device
dcl-c ECLOSED_C 3417; // Socket closed
dcl-c EADDRINUSE_C 3420; // Address alread
dcl-c EADDRNOTAVAIL_C 3421; // Address not av
dcl-c EAFNOSUPPORT_C 3422; // The type of so
dcl-c EALREADY_C 3423; // Operation alre
dcl-c ECONNABORTED_C 3424; // Connection end
dcl-c ECONNREFUSED_C 3425; // A remote host
dcl-c ECONNRESET_C 3426; // A connection w
dcl-c EDESTADDRREQ_C 3427; // Operation requ
dcl-c EHOSTDOWN_C 3428; // A remote host
dcl-c EHOSTUNREACH_C 3429; // A route to the
dcl-c EINPROGRESS_C 3430; // Operation in p
dcl-c EISCONN_C 3431; // A connection h
dcl-c EMSGSIZE_C 3432; // Message size o
dcl-c ENETDOWN_C 3433; // The network is
dcl-c ENETRESET_C 3434; // A socket is co
dcl-c ENETUNREACH_C 3435; // Cannot reach t
dcl-c ENOBUFS_C 3436; // There is not e
dcl-c ENOPROTOOPT_C 3437; // The protocol d
dcl-c ENOTCONN_C 3438; // Requested oper
dcl-c ENOTSOCK_C 3439; // The specified
dcl-c ENOTSUP_C 3440; // Operation not
dcl-c EOPNOTSUPP_C 3440; // Operation not
dcl-c EPFNOSUPPORT_C 3441; // The socket pro
dcl-c EPROTONOSUPPORT_C 3442; // No protocol of
dcl-c EPROTOTYPE_C 3443; // The socket typ
dcl-c ERCVDERR_C 3444; // An error indic
dcl-c ESHUTDOWN_C 3445; // Cannot send da
dcl-c ESOCKTNOSUPPORT_C 3446; // The specified
dcl-c ETIMEDOUT_C 3447; // A remote host
dcl-c EUNATCH_C 3448; // The protocol r
dcl-c EBADF_C 3450; // Descriptor not
dcl-c EMFILE_C 3452; // Too many open
dcl-c ENFILE_C 3453; // Too many open
dcl-c EPIPE_C 3455; // Broken pipe.
dcl-c EEXIST_C 3457; // File exists.
dcl-c EDEADLK_C 3459; // Resource deadl
dcl-c ENOMEM_C 3460; // Storage alloca
dcl-c EOWNERTERM_C 3462; // The mutex no l
dcl-c EDESTROYED_C 3463; // he synchroniza
dcl-c ETERM_C 3464; // Operation term
dcl-c EMLINK_C 3468; // Maximum link c
dcl-c ESPIPE_C 3469; // Seek request n
dcl-c ENOSYS_C 3470; // Function not i
dcl-c EISDIR_C 3471; // Specified targ
dcl-c EROFS_C 3472; // Read-only file
dcl-c EUNKNOWN_C 3474; // Unknown system
dcl-c EITERBAD_C 3475; // Iterator is in
dcl-c EDAMAGE_C 3484; // A damaged obje
dcl-c ELOOP_C 3485; // A loop exists
dcl-c ENAMETOOLONG_C 3486; // A path name is
dcl-c ENOLCK_C 3487; // No locks avail
dcl-c ENOTEMPTY_C 3488; // Directory not
dcl-c ENOSYSRSC_C 3489; // System resourc
dcl-c ECONVERT_C 3490; // Conversion err
dcl-c E2BIG_C 3491; // Argument list
dcl-c EILSEQ_C 3492; // Conversion sto
dcl-c ESOFTDAMAGE_C 3497; // Object has sof
dcl-c ENOTENROLL_C 3498; // User not enrol
dcl-c EOFFLINE_C 3499; // Object is susp
dcl-c EROOBJ_C 3500; // Object is a re
dcl-c ELOCKED_C 3506; // Area being rea
dcl-c EFBIG_C 3507; // Object too lar
dcl-c EIDRM_C 3509; // The semaphore,
dcl-c ENOMSG_C 3510; // The queue does
dcl-c EFILECVT_C 3511; // File ID conver
dcl-c EBADFID_C 3512; // A File ID coul
dcl-c ESTALE_C 3513; // A File ID coul
dcl-c ESRCH_C 3515; // No such proces
dcl-c ENOTSIGINIT_C 3516; // Process not en
dcl-c ECHILD_C 3517; // No child proce
dcl-c EBADH_C 3520; // Handle is not
dcl-c ETOOMANYREFS_C 3523; // The operation
dcl-c ENOTSAFE_C 3524; // Function not a
dcl-c EOVERFLOW_C 3525; // Object is too
dcl-c EJRNDAMAGE_C 3526; // Journal damage
dcl-c EJRNINACTIVE_C 3527; // Journal inacti
dcl-c EJRNRCVSPC_C 3528; // Journal space
dcl-c EJRNRMT_C 3529; // Journal is rem
dcl-c ENEWJRNRCV_C 3530; // New journal re
dcl-c ENEWJRN_C 3531; // New journal is
dcl-c EJOURNALED_C 3532; // Object already
dcl-c EJRNENTTOOLONG_C 3533; // Entry too larg
dcl-c EDATALINK_C 3534; // Object is a Da
dcl-c ENOTAVAIL_C 3535; // Independent AS
dcl-c ENOTTY_C 3536; // Inappropriate
dcl-c EFBIG2_C 3540; // Write or trunc
dcl-c ETXTBSY_C 3543; // Text file busy
dcl-c EASPGRPNOTSET_C 3544; // ASP group not
dcl-c ERESTART_C 3545; // System call ca
dcl-c ESCANFAILURE_C 3546; // Object marked

//  Unix return codes
dcl-c RC_OK 0;
dcl-c RC_ERROR -1;

//  Convert External Form to Numeric Value (CVTEFN)
dcl-pr cvtefnd float(8) extproc('cvtefnd');
  i_source pointer value;
  i_len    uns(10) value;
  i_mask   pointer value;
end-pr;

//  Test Bit in String (TSTBTS)
dcl-pr tstbts int(10) extproc('tstbts');
  bit_string pointer value;
  bit_offset int(10) value;
end-pr;

//  getenv()--Get Value of Environment Variable
dcl-pr getenv pointer extproc('getenv');
  name pointer options(*string) value;
end-pr;

//  putenv()--Change or Add Environment Variable
dcl-pr putenv int(10) extproc('putenv');
  string pointer options(*string) value;
end-pr;

//  Qp0zDltEnv()--Delete an Environment Variable
dcl-pr Qp0zDltEnv int(10) extproc('Qp0zDltEnv');
  name pointer options(*string) value;
end-pr;

//  Qp0zInitEnv()--Initialize Environment for Variables
dcl-pr Qp0zInitEnv int(10) extproc('Qp0zInitEnv');
end-pr;

dcl-s ENVIRON pointer import('environ');

//  Generate Universal Unique Identifier (GENUUID)
dcl-pr genUUID extproc('_GENUUID');
  uuid_template pointer value;
end-pr;

dcl-ds uuid_template_t qualified based(pDummy);
  bytPrv   uns(10);
  bytAvl   uns(10);
  reserved char(8);
  uuid     char(16);
end-ds;

//  Convert Hex to Character (CVTHC)
dcl-pr cvthc extproc('cvthc');
  pResult    pointer value;
  pSource    pointer value;
  sourceSize int(10) value;
end-pr;

//  Convert Eight Bit Character to Hex Nibbles (CVTCH)
dcl-pr cvtch extproc('cvtch');
  pResult   pointer value;
  pSource   pointer value;
  sourceLen int(10) value;
end-pr;

//  Cipher (CIPHER)
dcl-pr cipher extproc('_CIPHER');
  *n pointer const;
  *n pointer value;
  *n pointer const;
end-pr;

dcl-ds cipherCtrls_t qualified based(pDummy) align;
  function      char(2) pos(1);
  hashAlg       char(1) pos(3);
  sequence      char(1) pos(4);
  dataLength    uns(10) pos(5);
  output        char(1) pos(9);
  reserved_1    char(7) pos(10);
  hashContext   pointer pos(17);
  HMACKey       pointer pos(33);
  HMACKeyLength uns(10) pos(49);
  reserved_2    char(44) pos(53);
end-ds;

dcl-c cCIPHER_MD5 x'00';
dcl-c cCIPHER_SHA1 x'01';

dcl-c cCIPHER_ONLY x'00';
dcl-c cCIPHER_FIRST x'01';
dcl-c cCIPHER_MIDDLE x'02';
dcl-c cCIPHER_FINAL x'03';

dcl-c cCIPHER_HASH x'00';
dcl-c cCIPHER_HMAC x'01';

/endif
