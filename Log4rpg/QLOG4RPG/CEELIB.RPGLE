 DEF  /IF NOT DEFINED(CEELIB)
 DEF  /DEFINE CEELIB
      *
      * ---------------------------------------------------------------
      *   Program or Procedure Call APIs
      * ---------------------------------------------------------------
      *
      *  Condition token, used as feedback code
     D cee_fc_t        DS                  qualified               based(pDummy)
     D  Condition_ID...
     D                         1      4A
     D   MsgSev                1      2I 0
     D   Msg_No                3      4U 0
     D  Flags                  5      5A
     D  Facility_ID...
     D                         6      8A
     D  I_S_Info               9     12A
      *
      *  Retrieve Operational Descriptor Information (CEEDOD)
     D CEEDOD...
     D                 PR
     D                                            extproc('CEEDOD')
     D  i_posn                       10I 0 const
     D  o_desctype                   10I 0
     D  o_datatype                   10I 0
     D  o_descinf1                   10I 0
     D  o_descinf2                   10I 0
     D  o_datalen                    10I 0
     D  o_fc                         12A          options(*omit   )
      *
      *  Reference fields for CEEDOD API
     D descInf_t       DS                  based(pDummy)   qualified
     D  desctype                     10I 0
     D  datatype                     10I 0
     D  descinf1                     10I 0
     D  descinf2                     10I 0
     D  datalen                      10I 0
      *
      *  Test for Omitted Argument (CEETSTA) API
     D CEETSTA...
     D                 PR
     D                                            extproc('CEETSTA')
     D  io_isPresent                 10I 0
     D  i_argNum                     10I 0 const
     D  o_fc                         12A          options(*omit   )
      *
      *  Get String Information (CEEGSI) API
     D CEEGSI...
     D                 PR
     D                                            extproc('CEEGSI')
     D  i_posn                       10I 0 const
     D  o_datatype                   10I 0
     D  o_curlen                     10I 0
     D  o_maxlen                     10I 0
     D  o_fb                         12A          options(*omit   )
      *
      *  Reference fields for CEEGSI API
     D strInf_t        DS                  based(pDummy)   qualified
     D  datatype                     10I 0
     D  curlen                       10I 0
     D  maxlen                       10I 0
      *
      * ---------------------------------------------------------------
      *   Math APIs
      * ---------------------------------------------------------------
      *
      *  Logarithm base 10 (double float)
     D CEESDLG1...
     D                 PR                  extproc('CEESDLG1')
     D  i_value                       8F   const
     D  o_result                      8F
      *
      * ---------------------------------------------------------------
      *   ILE CEE Date and Time APIs
      * ---------------------------------------------------------------
      *
      *  Calculate Day of Week from Lilian Date (CEEDYWK) API
     D CEEDYWK         PR                  opdesc extproc('CEEDYWK')
     D   lilian_date                 10I 0 const
     D   day_no                      10I 0
     D   feedback                    12A   options(*omit)
      *
      *  Convert Lilian Date to Character Format (CEEDATE) API
     D CEEDATE         PR                  opdesc extproc('CEEDATE')
     D   lilian_date                 10I 0 const
     D   date_format                 80A   const options(*varsize)
     D   char_date                   80A   options(*varsize)
     D   feedback                    12A   options(*omit)
      *
      *  Convert Date to Lilian Format (CEEDAYS) API
     D CEEDAYS         PR                  opdesc extproc('CEEDAYS')
     D   char_date                   80A   const options(*varsize)
     D   date_format                 80A   const options(*varsize)
     D   lilian_date                 10I 0
     D   feedback                    12A   options(*omit)
      *
      * ---------------------------------------------------------------
      *   Activation Group and Control Flow APIs
      * ---------------------------------------------------------------
      *
      *  Register Activation Group Exit Procedure (CEE4RAGE) API
     D CEE4RAGE...
     D                 PR                  extproc('CEE4RAGE')
     D  i_pProc                        *   const procptr
     D   fc                          12A         options(*OMIT)
      *
     D END_ACTGRP_CODE_EXCEPTION_MESSAGE...
     D                 C                   x'40000000'
     D END_ACTGRP_CODE_ABNORMAL_END...
     D                 C                   x'00008000'
     D END_ACTGRP_CODE_ACTGRP_IS_ENDING...
     D                 C                   x'00004000'
     D END_ACTGRP_CODE_INIT_BY_RCLACTGRP...
     D                 C                   x'00002000'
     D END_ACTGRP_CODE_INIT_BY_JOB_END...
     D                 C                   x'00001000'
     D END_ACTGRP_CODE_INIT_BY_EXIT_VERB...
     D                 C                   x'00000800'
     D END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK...
     D                 C                   x'00000400'
     D END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP...
     D                 C                   x'00000200'
      *
      *  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
     D CEERTX...
     D                 PR                         extproc('CEERTX')
     D  i_procPtr                      *   const  procptr
     D  i_rtxToken                     *   const  options(*omit)
     D  o_fc                         12A          options(*omit)
      *
     D CEERTX_user_exit...
     D                 PR                         extproc('CEERTX_user_exit')
     D  i_rtxToken                     *   const
      *
      *  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
     D CEEUTX...
     D                 PR                         extproc('CEEUTX')
     D  i_procPtr                      *   const  procptr
     D  o_fc                         12A          options(*omit)
      *
 DEF  /ENDIF
