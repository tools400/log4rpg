      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Layout                                   *
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
      *  27.10.2006  Th.Raddatz    Removed return value from procedure      *
      *                            Layout_format().                         *
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
      /COPY QLOG4RPG,PLOG4RPG11
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  layoutImpl                         likeds(LOG4RPG_classLayout_t   )
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C Library
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG12                    ClassLoader
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      /DEFINE DEFINE_PROCPTR
      /COPY QLOG4RPG,PLAYOUT                       Layout implementation
      /UNDEFINE DEFINE_PROCPTR
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
      *=========================================================================
      *  Creates a new layout.
      *=========================================================================
      *  Parameters:
      *   i_layoutImpl  - A string that specifies the layout implementation
      *                   object.
      *   i_pPropString - A string that specifies the properties for the
      *                   layout implementation object.
      *
      *  Returns:
      *   pLayout       - Returns a handle to the layout object on success,
      *                   else a NULL handle.
      *=========================================================================
     P Layout_new...
     P                 B                   export
      *
     D Layout_new...
     D                 PI                         like(LOG4RPG_pLayout_t       )
     D  i_layoutImpl                       const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Return value
     D layout          DS                  likeds(handle_t    )
     D                                     based(pLayout)
      *
      *  Paremeter positions
     D p_pPropString   C                   const(2)
      *
      *  Fields for optional parameters
     D pPropString     S                   like(i_pPropString  ) inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D tempLayout      DS                  likeds(handle_t              ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Creating layout ...');
 
         pLayout = Layout_null();
 
         // Get optional parameters ...
         // ... property string
         if %parms() >= p_pPropString;
            CEETSTA(isPresent: p_pPropString: *omit);
         else;
            isPresent = 0;
         endif;
 
         if isPresent = 1;
            pPropString = i_pPropString;
         else;
            pPropString = *NULL;
         endif;
 
         // Initialize layout;
         if not ClassLoader_resolveLayout(i_layoutImpl: tempLayout.layoutImpl);
            return pLayout;
         endif;
 
         // Create properties list
         if pPropString <> *NULL;
            pPropList = PropertyList_new(pPropString);
         else;
            pPropList = PropertyList_null();
         endif;
 
         // Create layout handle
         pLayout = %alloc(%size(handle_t));
         layout = tempLayout;
 
         // Instanciate layout implementation object
         g_pLayout_new = layout.layoutImpl.procNew.procptr;
         SrvPgmLayout_new(pLayout
                          : layout.layoutImpl.pHandle
                          : pPropList
                          : '');
 
         // Destroy properties list
         if not PropertyList_isNull(pPropList);
            PropertyList_delete(pPropList);
         endif;
 
         LogLog_verbose('+ Allocated memory for layout.');
 
         return pLayout;
 
      /END-FREE
      *
     P Layout_new...
     P                 E
      *
      *=========================================================================
      *  Formats the given string according to the layout.
      *=========================================================================
      *  Parameters:
      *   i_pLayout     - Handle of the layout returned by Layout_new().
      *
      *  Returns:
      *   text          - Returns the formatted text on success, else ''.
      *=========================================================================
     P Layout_format...
     P                 B                   export
      *
     D Layout_format...
     D                 PI
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t      )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t    )
      *
      *  Layout handle
     D layout          DS                  likeds(handle_t    )
     D                                     based(i_pLayout)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('-> Formatting log event of logger [' +
                            LogEvent_getLoggerName(i_pLogEvent) + ']...');
 
         g_pLayout_format = layout.layoutImpl.procFormat.procptr;
         SrvPgmLayout_format(layout.layoutImpl.pHandle
                             : i_pLogEvent);
 
         return;
 
      /END-FREE
      *
     P Layout_format...
     P                 E
      *
      *=========================================================================
      *  Returns the header of the layout. (optional layout procedure)
      *=========================================================================
      *  Parameters:
      *   i_pLayout     - Handle of the layout returned by Layout_new().
      *
      *  Returns:
      *   header        - Returns the header of the layout.
      *=========================================================================
     P Layout_getHeader...
     P                 B                   export
      *
     D Layout_getHeader...
     D                 PI                         like(LOG4RPG_header_t       )
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t      )
      *
      *  Return value
     D header          S                   like(LOG4RPG_header_t  ) inz
      *
      *  Layout handle
     D layout          DS                  likeds(handle_t    )
     D                                     based(i_pLayout)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pLayout_getHeader = layout.layoutImpl.procGetHeader.procptr;
 
         if g_pLayout_getHeader <> *NULL;
            header = SrvPgmLayout_getHeader(layout.layoutImpl.pHandle);
         endif;
 
         return header;
 
      /END-FREE
      *
     P Layout_getHeader...
     P                 E
      *
      *=========================================================================
      *  Returns the footer of the layout. (optional layout procedure)
      *=========================================================================
      *  Parameters:
      *   i_pLayout     - Handle of the layout returned by Layout_new().
      *
      *  Returns:
      *   footer        - Returns the footer of the layout.
      *=========================================================================
     P Layout_getFooter...
     P                 B                   export
      *
     D Layout_getFooter...
     D                 PI                         like(LOG4RPG_footer_t       )
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t      )
      *
      *  Return value
     D footer          S                   like(LOG4RPG_footer_t  ) inz
      *
      *  Layout handle
     D layout          DS                  likeds(handle_t    )
     D                                     based(i_pLayout)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pLayout_getFooter = layout.layoutImpl.procGetFooter.procptr;
 
         if g_pLayout_getFooter <> *NULL;
            footer = SrvPgmLayout_getFooter(layout.layoutImpl.pHandle);
         endif;
 
         return footer;
 
      /END-FREE
      *
     P Layout_getFooter...
     P                 E
      *
      *=========================================================================
      *  Returns the new-line character.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   newLine       - The new line charcater of the system.
      *=========================================================================
     P Layout_newLine...
     P                 B                   export
      *
     D Layout_newLine...
     D                 PI             2A          varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return '\n';
 
      /END-FREE
      *
     P Layout_newLine...
     P                 E
      *
      *=========================================================================
      *  Sets the properties of the specified layout.
      *=========================================================================
      *  Parameters:
      *   i_pLayout     - Handle of the layout returned by Layout_new().
      *   i_pPropList   - Handle of the properties list.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Layout_setProperties...
     P                 B                   export
      *
     D Layout_setProperties...
     D                 PI
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Layout handle
     D layout          DS                  likeds(handle_t    )
     D                                     based(i_pLayout)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pLayout_setProperties =
               layout.layoutImpl.procSetProperties.procptr;
         SrvPgmLayout_setProperties(layout.layoutImpl.pHandle
                                    : i_pPropList
                                    : i_prefix);
 
         return;
 
      /END-FREE
      *
     P Layout_setProperties...
     P                 E
      *
      *=========================================================================
      *  Deletes the specified layout.
      *=========================================================================
      *  Parameters:
      *   io_pLayout    - Handle of the layout returned by Layout_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
     P Layout_delete...
     P                 B                   export
      *
     D Layout_delete...
     D                 PI              N
     D  io_pLayout                                like(LOG4RPG_pLayout_t      )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Layout handle
     D layout          DS                  likeds(handle_t    )
     D                                     based(io_pLayout)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Deleting layout ...');
 
         // Delete layout
         g_pLayout_delete = layout.layoutImpl.procDelete.procptr;
         isDeleted = SrvPgmLayout_delete(layout.layoutImpl.pHandle);
 
         dealloc(N) io_pLayout;
         io_pLayout = Layout_null();
 
         LogLog_verbose('- Free memory of layout.');
 
         return isDeleted;
 
      /END-FREE
      *
     P Layout_delete...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified property is known by the
      *  super Layout.
      *=========================================================================
      *  Parameters:
      *   i_parameter   - Parameter that is tested.
      *
      *  Returns:
      *   isKnown       - Returns TRUE if the property is known by the super
      *                   Layout "class", else FALSE.
      *=========================================================================
     P Layout_knowsProperty...
     P                 B                   export
      *
     D Layout_knowsProperty...
     D                 PI              N
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         other;
            return cFalse;
         endsl;
 
      /END-FREE
      *
     P Layout_knowsProperty...
     P                 E
      *
      *=========================================================================
      *  Tests the specified layout for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pLayout     - Handle of the property list returned by
      *                   Layout_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the layout is a
      *                   NULL handle.
      *=========================================================================
     P Layout_isNull...
     P                 B                   export
      *
     D Layout_isNull...
     D                 PI              N
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
      *
      *  Return value
     D isNull          S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pLayout = Layout_null();
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;
 
         return isNull;
 
      /END-FREE
      *
     P Layout_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL layout.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pLayout       - Layout NULL handle.
      *=========================================================================
     P Layout_null...
     P                 B                   export
      *
     D Layout_null...
     D                 PI                         like(LOG4RPG_pLayout_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
      *
     P Layout_null...
     P                 E
      *
