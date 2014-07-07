      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: PropertyFilter                           *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  18.10.2006                                              *
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
      *     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
      *                              MODULE(&LI/&OB) +                      *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(&LI/LOG4RPG   +              *
      *                                        &LI/BASICS1 ) +              *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    Property Filter         ') +     *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new PropertyFilter.
     D PropertyFilter_new...
     D                 PR              N   extproc('PropertyFilter+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pFilter_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Decides what to do with the log event.
     D PropertyFilter_decide...
     D                 PR            10I 0 extproc('PropertyFilter+
     D                                     _decide')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the filter.
     D PropertyFilter_setProperties...
     D                 PR                  extproc('PropertyFilter+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given PropertyFilter.
     D PropertyFilter_delete...
     D                 PR              N   extproc('PropertyFilter+
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
     D  pSuper                             like(LOG4RPG_pFilter_t       )
     D  hPropList                          like(LOG4RPG_pPropertyList_t )
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                         C-Library
      *
      /COPY QLOG4RPG,PLOG4RPG07                   PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                   LogLog
      /COPY QLOG4RPG,PLOG4RPG99                   Helper
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
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'PropertyFilter')
      *
     D cPARAMETER_PROPERTY...
     D                 C                          const('property.')
      *
      /COPY QLOG4RPG,PFILTER
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=====================================================================*
      *  Creates a new PropertyFilter.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle   - Handle that is passed around the various calls to
      *                  this PropertyFilter.
      *   i_pPropsList - Handle of the property list that contains the
      *                  properties for the filter.
      *   i_prefix     - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone       - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P PropertyFilter_new...
     P                 B                   export
      *
     D PropertyFilter_new...
     D                 PI              N
     D  i_pSuper                           const  like(LOG4RPG_pFilter_t       )
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
      *  Filter handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tmpHandle;
 
         // Initialize handle
         tmpHandle.pSuper    = i_pSuper;   // Handle of the super class 'Filter'
         tmpHandle.hPropList = PropertyList_new();
 
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
     P PropertyFilter_new...
     P                 E
      *
      *=====================================================================*
      *  Decides what to do with the log event.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this PropertyFilter.
      *   i_pLogEvent  - Handle of the Log event.
      *
      *  Returns:
      *   isDone       - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P PropertyFilter_decide...
     P                 B                   export
      *
     D PropertyFilter_decide...
     D                 PI            10I 0
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D hPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D property        DS                  likeds(LOG4RPG_property_t    ) inz
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      *
      *  Filter handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return if there are no properties to add
         if PropertyList_getNumE(handle.hPropList) = 0;
            return cFILTER_NEUTRAL;
         endif;
 
         // Get property list of log event
         hPropList = LogEvent_getPropertyList(i_pLogEvent);
 
         // Add attributes to log event
         propIter = PropertyList_getIterator(handle.hPropList);
 
         property = PropertyList_getFirst(propIter);
 
         dow property.key <> '';
            PropertyList_put(hPropList: property);
            property = PropertyList_getNext(propIter);
         enddo;
 
         return cFILTER_NEUTRAL;
 
      /END-FREE
      *
     P PropertyFilter_decide...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the filter.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle    - Handle that is passed around the various calls to
      *                  this PropertyFilter.
      *   i_pPropsList - Handle of the property list that contains the
      *                  properties for the filter.
      *   i_prefix     - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P PropertyFilter_setProperties...
     P                 B                   export
      *
     D PropertyFilter_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  PropertyFilter-Handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         return;
 
      /END-FREE
      *
     P PropertyFilter_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given PropertyFilter.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle   - Handle that is passed around the various calls to
      *                  this PropertyFilter.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P PropertyFilter_delete...
     P                 B                   export
      *
     D PropertyFilter_delete...
     D                 PI              N
     D  io_pHandle                     *
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Filter handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Delete property list
         if not PropertyList_isNull(handle.hPropList);
            PropertyList_delete(handle.hPropList);
         endif;
 
         // Clear handle data
         clear handle;
 
         // Free handle memory
         dealloc(N) io_pHandle;
 
         LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');
 
         isDone = cTrue;
 
         return isDone;
 
      /END-FREE
      *
     P PropertyFilter_delete...
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
               when f_startsWith(cPARAMETER_PROPERTY: parameter);
                  tmpProperty.key = %subst(parameter
                                           : %len(cPARAMETER_PROPERTY) + 1);
                  tmpProperty.value = property.value;
                  PropertyList_put(io_handle.hPropList: tmpProperty);
               when Filter_knowsProperty(parameter);
                  // Ignore all parameters known by super Filter class
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
