      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: HTMLLayout                               *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  02.11.2006                                              *
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
      *  07.11.2006  Th.Raddatz    Added missing '</title>' tag.            *
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
      *     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
      *                              MODULE(&LI/&OB) +                      *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
      *                                        *LIBL/BASICS1 ) +            *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    HTMLLayout              ') +     *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new HTMLLayout.
     D HTMLLayout_new...
     D                 PR              N   extproc('HTMLLayout+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Renders the log event.
     D HTMLLayout_format...
     D                 PR                  extproc('HTMLLayout+
     D                                     _format')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Returns the header of this layout.
     D HTMLLayout_getHeader...
     D                 PR                         like(LOG4RPG_header_t)
     D                                     extproc('HTMLLayout+
     D                                     _getHeader')
     D  i_pHandle                      *   const
      *
      *  Returns the header of this layout.
     D HTMLLayout_getFooter...
     D                 PR                         like(LOG4RPG_footer_t)
     D                                     extproc('HTMLLayout+
     D                                     _getFooter')
     D  i_pHandle                      *   const
      *
      *  Used to set the properties of the layout.
     D HTMLLayout_setProperties...
     D                 PR                  extproc('HTMLLayout+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given HTMLLayout.
     D HTMLLayout_delete...
     D                 PR              N   extproc('HTMLLayout+
     D                                     _delete')
     D  io_pHandle                     *
      *
      /IF DEFINED(PROTOTYPES_ONLY)
      /EOF
      /ENDIF
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG52
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                     Public interface & type definitions
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pLayout_t  )
     D  title                       128A   varying
     D  color                              likeds(color_t )
      *
     D color_t...
     D                 DS                  qualified           based(pDummy)
     D  info                               like(LOG4RPG_colorAttr_t)
     D  debug                              like(LOG4RPG_colorAttr_t)
     D  warn                               like(LOG4RPG_colorAttr_t)
     D  error                              like(LOG4RPG_colorAttr_t)
     D  fatal                              like(LOG4RPG_colorAttr_t)
      *
     D LOG4RPG_colorAttr_t...
     D                 S             32A   varying             based(pDummy)
      *
     D LOG4RPG_color_t...
     D                 S              7A   varying             based(pDummy)
      *
     D LOG4RPG_strong_t...
     D                 S              6A   varying             based(pDummy)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      *
 CPY  *COPY QLOG4RPG,PLOG4RPG07                    PropertyList
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
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns the color for a log event.
     D getColorAttr...
     D                 PR                         like(LOG4RPG_colorAttr_t)
     D  i_handle                           const  likeds(handle_t         )
     D  i_level                            const  like(LOG4RPG_level_t    )
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'HTMLLayout')
      *
      /COPY QLOG4RPG,PLAYOUT
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
      *=====================================================================*
      *  Creates a new HTMLLayout.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle   - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *   i_pPropsList - Handle of the property list that contains the
      *                  properties for the layout.
      *   i_prefix     - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone       - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P HTMLLayout_new...
     P                 B                   export
      *
     D HTMLLayout_new...
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
     D tmpHandle       DS                  likeds(handle_t ) inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tmpHandle;
 
         // Initialize handle
         tmpHandle.pSuper    = i_pSuper;   // Handle of the super class 'Layout'
         tmpHandle.title     = 'Log4rpg Log Messages';
 
         tmpHandle.color.info  = '';
         tmpHandle.color.debug = '#339933';              // green
         tmpHandle.color.warn  = '#FFCC00; strong';      // orange
         tmpHandle.color.error = '#CC3300; strong';      // red
         tmpHandle.color.fatal = '#993300; strong';      // dark red
 
         // Initialize handle from configuration properties
         if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
            loadConfiguration(tmpHandle: i_pPropList: i_prefix);
         endif;
 
         io_pHandle = %alloc(%size(tmpHandle));
         handle = tmpHandle;
 
         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');
 
         return isDone;
 
      /END-FREE
      *
     P HTMLLayout_new...
     P                 E
      *
      *=====================================================================*
      *  Decides what to do with the log event.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *   i_pLogEvent  - Handle of the Log event.
      *
      *  Returns:
      *   isDone       - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P HTMLLayout_format...
     P                 B                   export
      *
     D HTMLLayout_format...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D htmlString      S                   like(LOG4RPG_formattedText_t) inz
     D colorAttr       S             32A   varying                       inz
     D color           S                   like(LOG4RPG_color_t        ) inz
     D strong          S                   like(LOG4RPG_strong_t       ) inz
     D pToken          S               *                                 inz
     D caller          DS                  likeds(LOG4RPG_caller_t  ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Start log event ...
         htmlString = Layout_newLine() + '<tr>' + Layout_newLine();
 
         // ... adding time
         htmlString = htmlString +
            '<td title="Time">' +
               %char(LogEvent_getTime(i_pLogEvent)) +
            '</td>' + Layout_newLine();
 
         // ... adding job (thread)
         htmlString = htmlString +
            '<td title="Qualified job name">' + %editc(sds.nbr: 'X') + '/' +
                                                %trimR(sds.user)     + '/' +
                                                %trimR(sds.job )           +
            '</td>' + Layout_newLine();
 
         // ... adding level
         htmlString = htmlString +
            '<td title="Level">';
 
         colorAttr = getColorAttr(handle: LogEvent_getLevel(i_pLogEvent));
 
         pToken = strtok(colorAttr: ';');
         if pToken <> *NULL;
            color = %trim(%str(pToken));
            pToken = strtok(*NULL: ';');
         endif;
 
         if pToken <> *NULL;
            strong = %trim(%str(pToken));
         endif;
 
         if color = '';
            htmlString = htmlString + LogEvent_getLevel(i_pLogEvent);
         else;
            htmlString = htmlString + '<font color="' + color + '">';
            if strong <> '';
               htmlString = htmlString + '<strong>';
            endif;
            htmlString = htmlString + LogEvent_getLevel(i_pLogEvent);
            if strong <> '';
               htmlString = htmlString + '</strong>';
            endif;
            htmlString = htmlString +  '</font>';
         endif;
 
         htmlString = htmlString +
            '</td>' + Layout_newLine();
 
         // ... adding logger name
         htmlString = htmlString +
            '<td title="Logger name">' +
               LogEvent_getLoggerName(i_pLogEvent) +
            '</td>' + Layout_newLine();
 
         // ... adding caller information
         caller = LogEvent_getCaller(i_pLogEvent);
 
         htmlString = htmlString +
            '<td title="Procedure:Line">' +
               caller.procedure + ':' + caller.stmtID +
            '</td>' + Layout_newLine();
 
         // ... adding message
         htmlString = htmlString +
            '<td title="Message">' +
               LogEvent_getText(i_pLogEvent) +
            '</td>' + Layout_newLine();
 
         // ... close.
         htmlString = htmlString + '</tr>'  + Layout_newLine();
 
         LogEvent_setText(i_pLogEvent: htmlString);
 
         return;
 
      /END-FREE
      *
     P HTMLLayout_format...
     P                 E
      *
      *=====================================================================*
      *  Returns the header of this layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *
      *  Returns:
      *   header       - The header string of this layout.
      *=====================================================================*
     P HTMLLayout_getHeader...
     P                 B                   export
      *
     D HTMLLayout_getHeader...
     D                 PI                         like(LOG4RPG_header_t)
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D htmlString      S                   like(LOG4RPG_header_t  ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         htmlString =                                                                       //RADDAT
            '<!DOCTYPE HTML PUBLIC "-// 3C//DTD HTML 4.01 Transitional//EN" +
             "http://www.w3.org/TR/html4/loose.dtd">' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<html>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<head>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<title>' + handle.title + '</title>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<style type="text/css">' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<!--' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            'body, table {font-family: arial,sans-serif; font-size: x-small;}' +
             Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            'th {background: #336699; color: #FFFFFF; text-align: left;}' +
             Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '-->' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '</style>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '</head>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<body bgcolor="#FFFFFF" topmargin="6" leftmargin="6">' +
             Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<hr size="1" noshade>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            'Log session start time ' + %char(%date: *JOBRUN) + ', ' +
                                        %char(%time: *JOBRUN) +
             '<br>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<br>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<table cellspacing="0" cellpadding="4" border="1" +
             bordercolor="#224466" width="100%">' +
             Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<tr>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Time</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Job</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Level</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Logger</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Proc:Line</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<th>Message</th>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '</tr>' + Layout_newLine();
 
         return htmlString;
 
      /END-FREE
      *
     P HTMLLayout_getHeader...
     P                 E
      *
      *=====================================================================*
      *  Returns the footer of this layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *
      *  Returns:
      *   footer       - The footer string of this layout.
      *=====================================================================*
     P HTMLLayout_getFooter...
     P                 B                   export
      *
     D HTMLLayout_getFooter...
     D                 PI                         like(LOG4RPG_footer_t)
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D htmlString      S                   like(LOG4RPG_footer_t  ) inz
      *
      *  Layout handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         htmlString =
            '</table>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '<br>' + Layout_newLine();
 
         htmlString = htmlString +                                                          //RADDAT
            '</body></html>' + Layout_newLine();
 
         return htmlString;
 
      /END-FREE
      *
     P HTMLLayout_getFooter...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *   i_pPropsList - Handle of the property list that contains the
      *                  properties for the layout.
      *   i_prefix     - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P HTMLLayout_setProperties...
     P                 B                   export
      *
     D HTMLLayout_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  HTMLLayout-Handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         return;
 
      /END-FREE
      *
     P HTMLLayout_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given HTMLLayout.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle   - Handle that is passed around the various calls to
      *                  this HTMLLayout.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P HTMLLayout_delete...
     P                 B                   export
      *
     D HTMLLayout_delete...
     D                 PI              N
     D  io_pHandle                     *
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Layout handle
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
     P HTMLLayout_delete...
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
     D tmpProperty     DS                  likeds(LOG4RPG_property_t) inz
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
 
               parameter = %subst(property.key: %len(prefix) + 1);
 
               select;
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
      *=========================================================================
    R *  *** Private ***
      *  Loads the configuration parameters from the specified property list.
      *=========================================================================
     P getColorAttr...
     P                 B
      *
     D getColorAttr...
     D                 PI                         like(LOG4RPG_colorAttr_t)
     D  i_handle                           const  likeds(handle_t         )
     D  i_level                            const  like(LOG4RPG_level_t    )
      *
      *  Return value
     D colorAttr       S                   like(LOG4RPG_colorAttr_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_level = cLOG4RPG_LEVEL_DEBUG;
            colorAttr = i_handle.color.debug;
         when i_level = cLOG4RPG_LEVEL_INFO;
            colorAttr = i_handle.color.info;
         when i_level = cLOG4RPG_LEVEL_WARN;
            colorAttr = i_handle.color.warn;
         when i_level = cLOG4RPG_LEVEL_ERROR;
            colorAttr = i_handle.color.error;
         when i_level = cLOG4RPG_LEVEL_FATAL;
            colorAttr = i_handle.color.fatal;
         other;
            colorAttr = '';
         endsl;
 
         return colorAttr;
 
      /END-FREE
      *
     P getColorAttr...
     P                 E
      *
