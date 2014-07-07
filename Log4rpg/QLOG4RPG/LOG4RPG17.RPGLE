      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Filter                                   *
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
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG17
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  name                               like(LOG4RPG_filterName_t      )
     D  filterImpl                         likeds(LOG4RPG_classFilter_t   )
     D  pNextFilter                        like(LOG4RPG_pFilter_t         )
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG12                    ClassLoader
      /COPY QLOG4RPG,PLOG4RPG13                    Repository
      /COPY QLOG4RPG,PLOG4RPG16                    LogEvent
      *
      /DEFINE DEFINE_PROCPTR
      /COPY QLOG4RPG,PFILTER                       Filter implementation
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
     D cPARAMETER_NEXT_FILTER...
     D                 C                          const('nextfilter')
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
      *  Creates a new filter.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pFilter       - Returns a handle to the filter on success, else
      *                   a NULL handle.
      *=========================================================================
     P Filter_new...
     P                 B                   export
      *
     D Filter_new...
     D                 PI                         like(LOG4RPG_pFilter_t       )
     D  i_fltName                          const  like(LOG4RPG_filterName_t    )
     D  i_fltImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Return value
     D filter          DS                  likeds(handle_t             )
     D                                     based(pFilter  )
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
     D tempFilter      DS                  likeds(handle_t              ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         initializeModule();
 
         LogLog_debug('Creating filter [' + i_fltName + '] ...');
 
         pFilter = Filter_null();
 
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
 
         // Initialize filter
         tempFilter.name    = i_fltName;
         if not ClassLoader_resolveFilter(i_fltImpl: tempFilter.filterImpl);
            return pFilter;
         endif;
         tempFilter.pNextFilter = Filter_null();
 
         // Create properties list
         if pPropString <> *NULL;
            pPropList = PropertyList_new(pPropString);
         else;
            pPropList = PropertyList_null();
         endif;
 
         // Create filter handle
         pFilter  = %alloc(%size(handle_t));
         filter   = tempFilter;
 
         // Instanciate filter implementation object
         g_pFilter_new = filter.filterImpl.procNew.procptr;
         SrvPgmFilter_new(pFilter
                          : filter.filterImpl.pHandle
                          : pPropList
                          : '');
 
         // Destroy properties list
         if not PropertyList_isNull(pPropList);
            PropertyList_delete(pPropList);
         endif;
 
         // Add filter to the repository
         Repository_addFilter(pFilter);
 
         LogLog_verbose('+ Allocated memory for filter [' +
                           filter.name + '].');
 
         return pFilter;
 
      /END-FREE
      *
     P Filter_new...
     P                 E
      *
      *=========================================================================
      *  Decides what to do with the log event.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the Log event.
      *
      *  Returns:
      *   decision      - The decison of the filter how to treat the log event.
      *                   Valid values are:   cFILTER_ACCEPT
      *                                       cFILTER_DENY
      *                                       cFILTER_NEUTRAL
      *=========================================================================
     P Filter_decide...
     P                 B                   export
      *
     D Filter_decide...
     D                 PI            10I 0
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Return value
     D decision        S             10I 0 inz
      *
      *  Helper fields
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(i_pFilter  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('-> Filtering log event of logger [' +
                            LogEvent_getLoggerName(i_pLogEvent) + ']...');
 
         g_pFilter_decide = filter.filterImpl.procDecide.procptr;
         decision = SrvPgmFilter_decide(filter.filterImpl.pHandle
                                        : i_pLogEvent);
 
         LogLog_verbose('-> Decision: ' + %char(decision));
 
         return decision;
 
      /END-FREE
      *
     P Filter_decide...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the filter.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter returned by Filter_new().
      *
      *  Returns:
      *   name          - Name of the specidfied filter.
      *=========================================================================
     P Filter_getName...
     P                 B                   export
      *
     D Filter_getName...
     D                 PI                         like(LOG4RPG_filterName_t  )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(i_pFilter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return filter.name;
 
      /END-FREE
      *
     P Filter_getName...
     P                 E
      *
      *=========================================================================
      *  Returns the next filter.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter returned by Filter_new().
      *
      *  Returns:
      *   pFilter       - Next filter of filter chain.
      *=========================================================================
     P Filter_getNext...
     P                 B                   export
      *
     D Filter_getNext...
     D                 PI                         like(LOG4RPG_pFilter_t     )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(i_pFilter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return filter.pNextFilter;
 
      /END-FREE
      *
     P Filter_getNext...
     P                 E
      *
      *=========================================================================
      *  Sets the next filter of the filter chain.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter returned by Filter_new().
      *   i_pNextFilter - Next filter of filter chain.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Filter_setNext...
     P                 B                   export
      *
     D Filter_setNext...
     D                 PI
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
     D  i_pNextFilter                      const  like(LOG4RPG_pFilter_t     )
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(i_pFilter)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         filter.pNextFilter = i_pNextFilter;
 
         return;
 
      /END-FREE
      *
     P Filter_setNext...
     P                 E
      *
      *=========================================================================
      *  Sets the properties of the specified filter.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter returned by Filter_new().
      *   i_pPropList   - Handle of the properties list.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Filter_setProperties...
     P                 B                   export
      *
     D Filter_setProperties...
     D                 PI
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t    )
     D                                     based(i_pFilter  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_pFilter_setProperties =
               filter.filterImpl.procSetProperties.procptr;
         SrvPgmFilter_setProperties(filter.filterImpl.pHandle
                                    : i_pPropList
                                    : i_prefix);
 
         return;
 
      /END-FREE
      *
     P Filter_setProperties...
     P                 E
      *
      *=========================================================================
      *  Deletes a given filter.
      *=========================================================================
      *  Parameters:
      *   io_pFilter    - Handle of the filter returned by Filter_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
      *
     P Filter_delete...
     P                 B                   export
      *
     D Filter_delete...
     D                 PI              N
     D  io_pFilter                                like(LOG4RPG_pFilter_t       )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D name            S                   like(filter.name  ) inz
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(io_pFilter  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         initializeModule();
 
         if not Repository_existFilter(filter.name);
            io_pFilter = Filter_null();
            return cTrue;
         endif;
 
         LogLog_verbose('Deleting filter [' + filter.name + '] ...');
 
         name = filter.name;
 
         // Remove filter from repository
         Repository_removeFilter(filter.name);
 
         // Delete filter
         g_pFilter_delete = filter.filterImpl.procDelete.procptr;
         isDeleted = SrvPgmFilter_delete(filter.filterImpl.pHandle);
 
         dealloc(N) io_pFilter;
         io_pFilter = Filter_null();
 
         LogLog_verbose('- Freed memory of filter [' + name + '].');
 
         return isDeleted;
 
      /END-FREE
      *
     P Filter_delete...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified property is known by the
      *  super filter.
      *=========================================================================
      *  Parameters:
      *   i_parameter   - Parameter that is tested.
      *
      *  Returns:
      *   isKnown       - Returns TRUE if the property is known by the super
      *                   Filter "class", else FALSE.
      *=========================================================================
     P Filter_knowsProperty...
     P                 B                   export
      *
     D Filter_knowsProperty...
     D                 PI              N
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_parameter = cPARAMETER_NEXT_FILTER or
              f_startsWith(cPARAMETER_NEXT_FILTER + '.': i_parameter);
            return cTrue;
         other;
            return cFalse;
         endsl;
 
      /END-FREE
      *
     P Filter_knowsProperty...
     P                 E
      *
      *=========================================================================
      *  Tests a given filter for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter returned by Filter_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the filter is a
      *                   NULL handle.
      *=========================================================================
     P Filter_isNull...
     P                 B                   export
      *
     D Filter_isNull...
     D                 PI              N
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
      *
      *  Return value
     D isNull          S               N   inz(cFalse)
      *
      *  Filter handle
     D filter          DS                  likeds(handle_t)
     D                                     based(i_pFilter  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pFilter = Filter_null();
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;
 
         return isNull;
 
      /END-FREE
      *
     P Filter_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL filter.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pFilter       - Filter NULL handle.
      *=========================================================================
     P Filter_null...
     P                 B                   export
      *
     D Filter_null...
     D                 PI                         like(LOG4RPG_pFilter_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
      *
     P Filter_null...
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
