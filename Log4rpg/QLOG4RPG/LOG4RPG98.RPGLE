      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Option Converter                         *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  22.04.2008                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG98
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      *
      *=========================================================================
      *  Converts a given property to a file-size-value.
      *=========================================================================
      *  Example:   512   ->   512 byte
      *             512KB ->   512 kByte
      *             512MB ->   512 MByte
      *             512GB ->   512 GByte
      *=========================================================================
     P OptionConverter_toFileSize...
     P                 B                   export
      *
     D OptionConverter_toFileSize...
     D                 PI            20I 0
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                    20I 0 value
      *
      *  Return value
     D fileSize        S             20I 0 inz
      *
      *  Helper fields
     D string          S                   like(i_value)
     D multiplier      S             10I 0 inz
     D index           S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P OptionConverter_toFileSize...
     P                 E
      *
      *=========================================================================
      *  Converts a given property to a RPG boolean value.
      *=========================================================================
      *  Example:   0     ->   cFalse
      *             1     ->   cTrue
      *             false ->   cFalse
      *             true  ->   cTrue
      *=========================================================================
     P OptionConverter_toBoolean...
     P                 B                   export
      *
     D OptionConverter_toBoolean...
     D                 PI              N
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                      N   value
      *
      *  Helper fields
     D string          S                   like(i_value)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         string = %trim(i_value);
 
         if (string = '');
            return i_default;
         endif;
 
         string = f_lcase(string);
 
         select;
         when (string = '1' or string = 'true');
            return cTrue;
         when (string = '0' or string = 'false');
            return cFalse;
         endsl;
 
         return i_default;
 
      /END-FREE
      *
     P OptionConverter_toBoolean...
     P                 E
      *
      *=========================================================================
      *  Converts a given property to a RPG integer value.
      *=========================================================================
     P OptionConverter_toInt...
     P                 B                   export
      *
     D OptionConverter_toInt...
     D                 PI            10I 0
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                    10I 0 value
      *
      *  Helper fields
     D string          S                   like(i_value)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         string = %trim(i_value);
 
         if (string = '');
            return i_default;
         endif;
 
         return f_val(string);
 
      /END-FREE
      *
     P OptionConverter_toInt...
     P                 E
      *
