**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Option Converter                         *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  22.04.2008                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
//=====================================================================*
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG98

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB                          C-Library
/copy QBASICS1,PBASICS1                      Basic RPG Extensions
/copy QLOG4RPG,PLOG4RPG10                    LogLog

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Program status data structure
// -----------------------------------------
//
//=========================================================================
//  Converts a given property to a file-size-value.
//=========================================================================
//  Example:   512   ->   512 byte
//             512KB ->   512 kByte
//             512MB ->   512 MByte
//             512GB ->   512 GByte
//=========================================================================
dcl-proc OptionConverter_toFileSize export;
  dcl-pi *n int(20);
    i_value   like(LOG4RPG_Property_value_t) value;
    i_default int(20) value;
  end-pi;

//  Return value
  dcl-s fileSize int(20) inz;

//  Helper fields
  dcl-s string like(i_value);
  dcl-s multiplier int(10) inz;
  dcl-s index int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = %trim(i_value);

if (string = '');
   return i_default;
endif;

string = f_ucase(string);
multiplier = 1;

dou '1';

   index = %scan('KB': i_value);
   if (index <> 0);
      multiplier = 1024;
      string     = %trimR(%subst(string: 1: index));
      leave;
   endif;

   index = %scan('MB': i_value);
   if (index <> 0);
      multiplier = 1024 * 1024;
      string     = %trimR(%subst(string: 1: index));
      leave;
   endif;

   index = %scan('GB': i_value);
   if (index <> 0);
      multiplier = 1024 * 1024 * 1024;
      string     = %trimR(%subst(string: 1: index));
      leave;
   endif;

   index = %check('0123456789 ': string);
   if (index > 0);
      LogLog_error('[' + string + '] is not in proper int form.');
      LogLog_error('[' + i_value + '] not in expected format.');
   endif;

enddo;

if (string = '');
   return i_default;
endif;

monitor;
   fileSize = atoi(string) * multiplier;
on-error;
   LogLog_error('[' + string + '] is not in proper int form.');
   LogLog_error('[' + i_value + '] not in expected format.');
endmon;

if (fileSize = 0);
   return i_default;
endif;

return fileSize;


end-proc;

//=========================================================================
//  Converts a given property to a RPG boolean value.
//=========================================================================
//  Example:   0     ->   *OFF
//             1     ->   *ON
//             false ->   *OFF
//             true  ->   *ON
//=========================================================================
dcl-proc OptionConverter_toBoolean export;
  dcl-pi *n ind;
    i_value   like(LOG4RPG_Property_value_t) value;
    i_default ind value;
  end-pi;

//  Helper fields
  dcl-s string like(i_value);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = %trim(i_value);

if (string = '');
   return i_default;
endif;

string = f_lcase(string);

select;
when (string = '1' or string = 'true');
   return *on;
when (string = '0' or string = 'false');
   return *off;
endsl;

return i_default;


end-proc;

//=========================================================================
//  Converts a given property to a RPG integer value.
//=========================================================================
dcl-proc OptionConverter_toInt export;
  dcl-pi *n int(10);
    i_value   like(LOG4RPG_Property_value_t) value;
    i_default int(10) value;
  end-pi;

//  Helper fields
  dcl-s string like(i_value);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = %trim(i_value);

if (string = '');
   return i_default;
endif;

return f_val(string);


end-proc;

