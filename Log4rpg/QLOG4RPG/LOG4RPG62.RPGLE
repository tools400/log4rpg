      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: XMLLayout                                *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
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
      *  27.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
      *                            object LogEvent.                         *
      *                            Removed return value from procedure      *
      *                            PatternLayout_format().                  *
      *                            Fixed problem that properties were not   *
      *                            found because auf case mismatch.         *
      *                                                                     *
      *  25.04.2007  Th.Raddatz    The log event was not correctly produced *
      *                            when i_text contained ']]>'. Now ']]>'   *
      *                            is replaced with ']]&gt'.                *
      *                                                                     *
      *  03.04.2012  Th.Raddatz    Fixed problem that some special          *
      *                            charcaters were not properly translated  *
      *                            to job CCSID when producing the XML      *
      *                            message.                                 *
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
      /COPY QLOG4RPG,PLOG4RPG62
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pLayout_t  )
     D  rplUnprtChars                  N
     D  substitutionChar...
     D                                1A   varying
     D  encoding                     32A   varying
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG09                    Level
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG99                    Helper
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Loads the configuration parameters from the specified property list.
     D loadConfiguration...
     D                 PR
     D                                            extproc('loadConfiguration')
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Ersetzt nicht darstellbare Zeichen
     D rplcUnprtChars...
     D                 PR                         like(LOG4RPG_formattedText_t)
     D                                            extproc('rplcUnprtChars')
     D  i_handle                           const  likeds(handle_t             )
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'XMLLayout')
      *
     D cPARAMETER_REPLACE_UNPRINTABLE_CHARACTERS...
     D                 C                          const('replace+
     D                                                   unprintablecharacters')
     D cPARAMETER_SUBSTITUTION_CHARACTER...
     D                 C                          const('substitutionCharacter')
     D cPARAMETER_ENCODING...
     D                 C                          const('encoding')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Creates a new XMLLayout.
      *=========================================================================
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLLayout.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=========================================================================
     P XMLLayout_new...
     P                 B                   export
      *
     D XMLLayout_new...
     D                 PI              N
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Helper fields
     D tempHandle      DS                  likeds(handle_t          ) inz
      *
      *  XMLLayout handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tempHandle;
 
         // Initialize handle
         tempHandle.pSuper        = i_pSuper;   // Handle of the super class 'Layout'
         tempHandle.rplUnprtChars = cFalse;
         tempHandle.substitutionChar = '÷';
         tempHandle.encoding         = '';
 
         // Initialize handle from configuration properties
         if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
            loadConfiguration(tempHandle: i_pPropList: i_prefix);
         endif;
 
         io_pHandle = %alloc(%size(tempHandle));
         handle = tempHandle;
 
         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');
 
         return isDone;
 
      /END-FREE
      *
     P XMLLayout_new...
     P                 E
      *
      *=========================================================================
      *  Formats a logging event and returns the result as a string.
      *=========================================================================
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLLayout.
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *                   text of the log event that is formated.
      *
      *  Returns:
      *   text          - Returns the formatted text of the log event.
      *=========================================================================
     P XMLLayout_format...
     P                 B                   export
      *
     D XMLLayout_format...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D xmlString       S                   like(LOG4RPG_formattedText_t) inz
     D isStarted       S               N   inz(cFalse)
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D caller          DS                  likeds(LOG4RPG_caller_t      ) inz
     D property        DS                  likeds(LOG4RPG_property_t    ) inz
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      *
      *  Convert RPG timestamp to Epoch time (mSeconds since January 1, 1970)
     D elapsedEpochTime...
     D                 S             20U 0 inz
     D mSeconds        S             20U 0 inz
     D logTime         S               Z   inz
      *
     D cBASE_TIME      C                          const(
     D                                            z'1970-01-01-00.00.00.000000')
      *
      *  Get Offset from Universal Time Coordinated to Local Time (CEEUTCO) API
     D hours           S             10I 0 inz
     D minutes         S             10I 0 inz
     D seconds         S              8F   inz
      *
     D CEEUTCO         PR                  opdesc
     D  Hours                        10I 0
     D  Minutes                      10I 0
     D  Seconds                       8F
      *
      *  XMLLayout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      *
     D START_CDATA     S              9C   inz(u'003C0021005B00430044+
     D                                           004100540041005B')             <![CDATA[
     D END_CDATA       S              3C   inz(u'005D005D003E')                 ]]>
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Convert log timestamp to Epoch time since this is
         // what 'Chainsaw' expects:
         mSeconds = %subdt(LogEvent_getTime(i_pLogEvent): *MSECONDS);
         logTime  = LogEvent_getTime(i_pLogEvent) - %mseconds(mSeconds);
         elapsedEpochTime = %diff(logTime: cBASE_TIME: *SECONDS);
         CEEUTCO(hours: minutes: seconds);
         elapsedEpochTime = elapsedEpochTime - seconds;
         elapsedEpochTime = (elapsedEpochTime * 1000) + (mSeconds / 1000);
 
         // Start log event ...
         xmlString = '<log4j:event logger="'                  +
                        LogEvent_getLoggerName(i_pLogEvent)   + '" ' +
                     'timestamp="'                            +
                        %char(elapsedEpochTime)               + '" ' +
                     'level="'                                +
                        Level_toString(
                           LogEvent_getPriority(i_pLogEvent)) + '" ' +
                     'thread="'                               +
                        %editc(sds.nbr: 'X') + '/' +
                        %trimR(sds.user)     + '/' +
                        %trimR(sds.job )                      + '" ' +
                     '>';
 
         // ... append message text
         xmlString = xmlString +
                     '<log4j:message>' + %char(START_CDATA) +
                        rplcUnprtChars(handle
                                       : LogEvent_getText(i_pLogEvent)) +
                     %char(END_CDATA) +
                     '</log4j:message>';
 
         // ... append caller information
         caller = LogEvent_getCaller(i_pLogEvent);
 
         xmlString = xmlString +
                     '<log4j:locationInfo class="' +
                        %trimR(caller.pgm.name)    + '" ' +
                     'method="'                    +
                        %trimR(caller.procedure)   + '" ' +
                     'file="'                      +
                        %trimR(caller.module.name) + '" ' +
                     'line="'                      +
                        %trimR(caller.stmtID)      + '" ' +
                     '/>';
 
         // ... append properties
         pPropList = LogEvent_getPropertyList(i_pLogEvent);
 
         if not PropertyList_isNull(pPropList);
 
            propIter = PropertyList_getIterator(pPropList);
 
            isStarted = cFalse;
            property = PropertyList_getFirst(propIter);
 
            dow property.key <> '';
 
               if not isStarted;
                  xmlString = xmlString + '<log4j:properties>';
                  isStarted = cTrue;
               endif;
 
               xmlString = xmlString +
                           '<log4j:data name="' + property.key   +
                                    '" value="' + property.value + '"' +
                           '/>';
 
               property = PropertyList_getNext(propIter);
            enddo;
 
            if isStarted;
               xmlString = xmlString + '</log4j:properties>';
            endif;
         endif;
 
         // ... close.
         xmlString = xmlString + '</log4j:event>';
 
         LogEvent_setText(i_pLogEvent: xmlString);
 
         return;
 
      /END-FREE
      *
     P XMLLayout_format...
     P                 E
      *
      *=====================================================================*
      *  Returns the header of this layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this XMLLayout.
      *
      *  Returns:
      *   header       - The header string of this layout.
      *=====================================================================*
     P XMLLayout_getHeader...
     P                 B                   export
      *
     D XMLLayout_getHeader...
     D                 PI                         like(LOG4RPG_header_t)
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D xmlString       S                   like(LOG4RPG_header_t  ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         xmlString =                                                                        //RADDAT
            '<?xml version="1.0" ';
 
         if handle.encoding <> '';
            xmlString = xmlString +
            'encoding="' + handle.encoding + '" ';
         endif;
 
         xmlString = xmlString +
            '?>' + Layout_newLine();
 
         xmlString = xmlString +
            '<!DOCTYPE log4j:eventSet SYSTEM "log4j.dtd">' +
             Layout_newLine();
 
         xmlString = xmlString +
            '<log4j:eventSet version="1.2" +
             xmlns:log4j="http://jakarta.apache.org/log4j/">' +
             Layout_newLine();
 
         return xmlString;
 
      /END-FREE
      *
     P XMLLayout_getHeader...
     P                 E
      *
      *=====================================================================*
      *  Returns the footer of this layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this XMLLayout.
      *
      *  Returns:
      *   footer       - The footer string of this layout.
      *=====================================================================*
     P XMLLayout_getFooter...
     P                 B                   export
      *
     D XMLLayout_getFooter...
     D                 PI                         like(LOG4RPG_footer_t)
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D xmlString       S                   like(LOG4RPG_footer_t  ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         xmlString =
            '</log4j:eventSet>' + Layout_newLine();
 
         return xmlString;
 
      /END-FREE
      *
     P XMLLayout_getFooter...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLLayout.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P XMLLayout_setProperties...
     P                 B                   export
      *
     D XMLLayout_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  XMLLayout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         return;
 
      /END-FREE
      *
     P XMLLayout_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given XMLLayout.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLLayout.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P XMLLayout_delete...
     P                 B                   export
      *
     D XMLLayout_delete...
     D                 PI              N
     D  io_pHandle                     *
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  XMLLayout handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Clear handle data
         clear handle;
 
         // Free handle memory
         dealloc(N) io_pHandle;
 
         LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');
 
         isDone = cTrue;
 
         return isDone;
 
      /END-FREE
      *
     P XMLLayout_delete...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Loads the configuration parameters from the specified property list.
      *=========================================================================
     P loadConfiguration...
     P                 B
      *
     D loadConfiguration...
     D                 PI
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Local fields
     D parameter       S                   like(property.key        ) inz
     D prefix          S                   like(i_prefix            ) inz
     D property        DS                  likeds(LOG4RPG_property_t) inz
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         prefix = f_lcase(i_prefix);
 
         propIter = PropertyList_getIterator(i_pPropList);
 
         property = PropertyList_getFirst(propIter);
 
         dow property.key <> '';
 
            if (prefix = '') or (f_startsWith(prefix: property.key) and
 B03                             %len(property.key) > %len(prefix));
 
               parameter = f_lcase(%subst(property.key: %len(prefix) + 1));
 
               select;
               when parameter = cPARAMETER_REPLACE_UNPRINTABLE_CHARACTERS;
                  if property.value = '1' or f_lcase(property.value) = 'true';
                     io_handle.rplUnprtChars = cTrue;
                  else;
                     io_handle.rplUnprtChars = cFalse;
                  endif;
               when parameter = cPARAMETER_SUBSTITUTION_CHARACTER;
                  io_handle.substitutionChar = property.value;
               when parameter = cPARAMETER_ENCODING;
                  io_handle.encoding         = property.value;
               when Layout_knowsProperty(parameter);
                  // Ignore all parameters known by super Layout class
               other;
                  LogLog_warning('No such property ['     +
                                  property.key            +
                                 '] in [' + cTHIS_CLASS + ']');
               endsl;
 
            endif;
 
            property = PropertyList_getNext(propIter);
         enddo;
 
         return;
 
      /END-FREE
      *
     P loadConfiguration...
     P                 E
      *
      *=====================================================================*
    R *  *** private ***
      *  Entfernt nicht darstellbare Zeichen
      *=====================================================================*
     P rplcUnprtChars...
     P                 B                   export
      *
     D rplcUnprtChars...
     D                 PI                         like(LOG4RPG_formattedText_t)
     D  i_handle                           const  likeds(handle_t             )
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      *  Return value
     D text1           S                   like(LOG4RPG_formattedText_t) inz
     D text2           S                   like(LOG4RPG_formattedText_t) inz
      *
      *  Arbeitsfelder
     D x               S             10I 0 inz
      *
     D END_CDATA       S              3C   inz(u'005D005D003E')                 ]]>
     D ESC_END_CDATA   S              6C   inz(u'005D005D002600670074003B')     ]]&gt;
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Replace closing string of CDATA section
         text1 = f_replace(%char(END_CDATA): %char(ESC_END_CDATA): i_text);
 
         // Replace unprintable characters
         if not i_handle.rplUnprtChars;
            return text1;
         endif;
 
         for x = 1 to %len(text1);
            if %subst(text1: x: 1) < x'40' or %subst(text1: x: 1) > x'FE';
               text2 = text2 + i_handle.substitutionChar;
            else;
               text2 = text2 + %subst(text1: x: 1);
            endif;
         endfor;
 
         return text2;
 
      /END-FREE
      *
     P rplcUnprtChars...
     P                 E
      *
