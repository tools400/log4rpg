      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Appender                                 *
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
      *  26.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
      *                            Added procedure Appender_knowsProperty().*
      *                            Moved wordWrap processing to Appender    *
      *                            implementation objects.                  *
      *                                                                     *
      *  09.09.2008  Th.Raddatz    Changed parameter 'i_filterName' of      *
      *                            Appender_setFilter() to 'i_pFilter' to   *
      *                            be consistent with Filter_setNext().     *
      *                                                                     *
      *  23.05.2011  Th.Raddatz    Fixed problem that the following         *
      *                            procedure did not return a return value: *
      *                               Appender_setFilter()                  *
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
      /COPY QLOG4RPG,PLOG4RPG03
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  name                               like(LOG4RPG_appenderName_t    )
     D  appenderImpl                       likeds(LOG4RPG_classAppender_t )
     D  pLayout                            like(LOG4RPG_pLayout_t         )
     D  pFilter                            like(LOG4RPG_pFilter_t         )
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG06                    Property
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG12                    ClassLoader
      /COPY QLOG4RPG,PLOG4RPG13                    Repository
      /COPY QLOG4RPG,PLOG4RPG17                    Filter
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      /COPY QLOG4RPG,PFILTER                       Filter implementation
      *
      /DEFINE DEFINE_PROCPTR
      /COPY QLOG4RPG,PAPPENDER                     Appender implementation
      /UNDEFINE DEFINE_PROCPTR
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Initializes this module.
     D initializeModule...
     D                 PR
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cPARAMETER_LAYOUT...
     D                 C                          const('layout')
     D cPARAMETER_FILTER...
     D                 C                          const('filter')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_isInit        S               N   inz(cFalse)
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Creates a new appender.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pAppender     - Returns a handle to the appender on success, else
      *                   a NULL handle.
      *=========================================================================
     P Appender_new...
     P                 B                   export
      *
     D Appender_new...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
     D  i_appImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Return value
     D appender        DS                  likeds(handle_t             )
     D                                     based(pAppender)
      *
      *  Paremeter positions
     D p_pPropString   C                   const(3)
      *
      *  Fields for optional parameters
     D pPropString     S                   like(i_pPropString  ) inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D tempAppender    DS                  likeds(handle_t              ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         initializeModule();
 
         LogLog_debug('Creating appender [' + i_appName + '] ...');
 
         pAppender = Appender_null();
 
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
 
         // Initialize appender
         tempAppender.name    = i_appName;
         if not ClassLoader_resolveAppender(i_appImpl
                                            : tempAppender.appenderImpl);
            return pAppender;
         endif;
         tempAppender.pLayout  = Layout_null();
         tempAppender.pFilter  = Filter_null();
 
         // Create properties list
         if pPropString <> *NULL;
            pPropList = PropertyList_new(pPropString);
         else;
            pPropList = PropertyList_null();
         endif;
 
         // Create appender handle
         pAppender = %alloc(%size(handle_t));
         appender = tempAppender;
 
         // Instanciate appender implementation object
         g_pAppender_new = appender.appenderImpl.procNew.procptr;
         SrvPgmAppender_new(pAppender
                            : appender.appenderImpl.pHandle
                            : pPropList
                            : '');
 
         // Destroy properties list
         if not PropertyList_isNull(pPropList);
            PropertyList_delete(pPropList);
         endif;
 
         // Add appender to the repository
         Repository_addAppender(pAppender);
 
         LogLog_verbose('+ Allocated memory for appender [' +
                           appender.name + '].');
 
         return pAppender;
 
      /END-FREE
      *
     P Appender_new...
     P                 E
      *
      *=========================================================================
      *  Appends a message to the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *   i_pLogEvent   - Handle of the Log event that is logged.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Appender_doAppend...
     P                 B                   export
      *
     D Appender_doAppend...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Return value
     D isAppended      S               N   inz(cFalse)
      *
      *  Helper fields
     D decision        S             10I 0 inz
     D pFilter         S                   like(LOG4RPG_pFilter_t ) inz
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Let the filter decide what to do with the log event
         pFilter = Appender_getFilter(i_pAppender);
         dow not Filter_isNull(pFilter);
            decision = Filter_decide(pFilter: i_pLogEvent);
            select;
            when decision = cFILTER_DENY;
               return cFalse;
            when decision = cFILTER_ACCEPT;
               leave;
            when decision = cFILTER_NEUTRAL;
               pFilter = Filter_getNext(pFilter);
            other;
               LogLog_warning('Invalid return value returned by +
                               Filter_decide() of filter [' +
                               Filter_getName(pFilter) + ']');
               leave;
            endsl;
         enddo;
 
         // Layout text of logging event
         if Appender_requiresLayout(i_pAppender) and
 B02        not Layout_isNull(appender.pLayout);
            Layout_format(appender.pLayout: i_pLogEvent);
         endif;
 
         // Append line of log statement to log
         g_pAppender_doAppend = appender.appenderImpl.procDoAppend.procptr;
         isAppended = SrvPgmAppender_doAppend(
                         appender.appenderImpl.pHandle: i_pLogEvent);
 
         return isAppended;
 
      /END-FREE
      *
     P Appender_doAppend...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   name          - Name of the specidfied appender.
      *=========================================================================
     P Appender_getName...
     P                 B                   export
      *
     D Appender_getName...
     D                 PI                         like(LOG4RPG_appenderName_t  )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return appender.name;
 
      /END-FREE
      *
     P Appender_getName...
     P                 E
      *
      *=========================================================================
      *  Returns the layout of the appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   i_pLayout     - Handle of the layout.
      *=========================================================================
     P Appender_getLayout...
     P                 B                   export
      *
     D Appender_getLayout...
     D                 PI                         like(LOG4RPG_pLayout_t       )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return appender.pLayout;
 
      /END-FREE
      *
     P Appender_getLayout...
     P                 E
      *
      *=========================================================================
      *  Sets the properties of the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *   i_pPropList   - Handle of the properties list.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Appender_setProperties...
     P                 B                   export
      *
     D Appender_setProperties...
     D                 PI
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t    )
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pAppender_setProperties =
               appender.appenderImpl.procSetProperties.procptr;
         SrvPgmAppender_setProperties(appender.appenderImpl.pHandle
                                      : i_pPropList
                                      : i_prefix);
 
         return;
 
      /END-FREE
      *
     P Appender_setProperties...
     P                 E
      *
      *=========================================================================
      *  Deletes a given appender.
      *=========================================================================
      *  Parameters:
      *   io_pAppender  - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
      *
     P Appender_delete...
     P                 B                   export
      *
     D Appender_delete...
     D                 PI              N
     D  io_pAppender                              like(LOG4RPG_pAppender_t     )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D name            S                   like(appender.name  ) inz
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(io_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         initializeModule();
 
         if not Repository_existAppender(appender.name);
            io_pAppender = Appender_null();
            return cTrue;
         endif;
 
         LogLog_verbose('Deleting appender [' + appender.name + '] ...');
 
         name = appender.name;
 
         // Remove appender from repository
         Repository_removeAppender(appender.name);
 
         // Delete appender (close appender)
         g_pAppender_delete = appender.appenderImpl.procDelete.procptr;
         isDeleted = SrvPgmAppender_delete(appender.appenderImpl.pHandle);
 
         // Delete layout
         if Appender_requiresLayout(io_pAppender);
            if not Layout_isNull(appender.pLayout);
               Layout_delete(appender.pLayout);
               appender.pLayout = Layout_null();
            endif;
         endif;
 
         // Detach filter from appender
         appender.pFilter = Filter_null();
 
         dealloc(N) io_pAppender;
         io_pAppender = Appender_null();
 
         LogLog_verbose('- Freed memory of appender [' + name + '].');
 
         return isDeleted;
 
      /END-FREE
      *
     P Appender_delete...
     P                 E
      *
      *=========================================================================
      *  Returns TRUE if the appender requires a layout.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   reqLayout     - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=========================================================================
     P Appender_requiresLayout...
     P                 B                   export
      *
     D Appender_requiresLayout...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Return value
     D reqLayout       S               N   inz(cFalse)
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pAppender_requiresLayout =
                     appender.appenderImpl.procRequiresLayout.procptr;
         reqLayout = SrvPgmAppender_requiresLayout(
                                       appender.appenderImpl.pHandle);
 
         return reqLayout;
 
      /END-FREE
      *
     P Appender_requiresLayout...
     P                 E
      *
      *=========================================================================
      *  Sets the layout for the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *   i_pLayout     - Handle of the layout.
      *
      *  Returns:
      *   isSet         - Returns TRUE on success, else FALSE.
      *=========================================================================
     P Appender_setLayout...
     P                 B                   export
      *
     D Appender_setLayout...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         appender.pLayout = i_pLayout;
 
         return cTrue;
 
      /END-FREE
      *
     P Appender_setLayout...
     P                 E
      *
      *=========================================================================
      *  Sets the filter for the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *   i_filterName  - Name of the filter.
      *
      *  Returns:
      *   isSet         - Returns TRUE on success, else FALSE.
      *=========================================================================
     P Appender_setFilter...
     P                 B                   export
      *
     D Appender_setFilter...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
      *
      *  Helper fields
     D filterName      S                   like(LOG4RPG_filterName_t ) inz
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if Filter_isNull(i_pFilter);
            LogLog_warning('Filter is NULL. Please check call from [' +
                           f_caller() + '] to [' + f_this() + '].');
            return cFalse;
         endif;
 
         filterName = Filter_getName(i_pFilter);
 
         if not Repository_existFilter(filterName);
            LogLog_warning('Filter [' + filterName +
                           '] does not exist in repository.');
            return cFalse;
         endif;
 
         appender.pFilter = i_pFilter;
 
         LogLog_debug('Filter [' + filterName +
                      '] attached to appender [' + appender.name + '].');
 
         return cTrue;
 
      /END-FREE
      *
     P Appender_setFilter...
     P                 E
      *
      *=========================================================================
      *  Returns the filter attached to the appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   pFilter       - Returns the handle of the filter on success, else
      *                   Filter_null();
      *=========================================================================
     P Appender_getFilter...
     P                 B                   export
      *
     D Appender_getFilter...
     D                 PI                         like(LOG4RPG_pFilter_t       )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return appender.pFilter;
 
      /END-FREE
      *
     P Appender_getFilter...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified property is known by the
      *  super Appender.
      *=========================================================================
      *  Parameters:
      *   i_parameter   - Parameter that is tested.
      *
      *  Returns:
      *   isKnown       - Returns TRUE if the property is known by the super
      *                   Appender "class", else FALSE.
      *=========================================================================
     P Appender_knowsProperty...
     P                 B                   export
      *
     D Appender_knowsProperty...
     D                 PI              N
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_parameter = cPARAMETER_LAYOUT or
              f_startsWith(cPARAMETER_LAYOUT + '.': i_parameter);
            return cTrue;
         when i_parameter = cPARAMETER_FILTER or
              f_startsWith(cPARAMETER_FILTER + '.': i_parameter);
            return cTrue;
         other;
            return cFalse;
         endsl;
 
      /END-FREE
      *
     P Appender_knowsProperty...
     P                 E
      *
      *=========================================================================
      *  Tests a given appender for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender returned by Appender_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the appender is a
      *                   NULL handle.
      *=========================================================================
     P Appender_isNull...
     P                 B                   export
      *
     D Appender_isNull...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Return value
     D isNull          S               N   inz(cFalse)
      *
      *  Appender handle
     D appender        DS                  likeds(handle_t)
     D                                     based(i_pAppender)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pAppender = Appender_null();
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;
 
         return isNull;
 
      /END-FREE
      *
     P Appender_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL appender.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pAppender     - Appender NULL handle.
      *=========================================================================
     P Appender_null...
     P                 B                   export
      *
     D Appender_null...
     D                 PI                         like(LOG4RPG_pAppender_t     )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
      *
     P Appender_null...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes this module.
      *=========================================================================
     P initializeModule...
     P                 B
      *
     D initializeModule...
     D                 PI
      *
      *  Return value
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if g_isInit;
            return;
         endif;
 
         Loglog_verbose('Initializing module ' + sds.modContProc + '...');
 
         Repository_initialize();
 
         g_isInit = cTrue;
 
         return;
 
      /END-FREE
      *
     P initializeModule...
     P                 E
      *
