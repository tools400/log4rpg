      /IF NOT DEFINED(PLOG4RPG17)
      /DEFINE PLOG4RPG17
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PSHARE                        Type defs appenders, layouts, filters
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new filter.
      *  ==> PLOG4RPG
      *
      *  Decides what to do with the log event.
     D Filter_decide...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_decide+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the name of the filter.
     D Filter_getName...
     D                 PR                         like(LOG4RPG_filterName_t  )
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_getName+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Returns the next filter.
     D Filter_getNext...
     D                 PR                         like(LOG4RPG_pFilter_t     )
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_getNext+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Sets the next filter of the filter chain.
      *  ==> PLOG4RPG
      *
      *  Sets the properties of the specified filter.
     D Filter_setProperties...
     D                 PR
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_setProperties+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Tests, whether the specified property is known by the
      *  super filter.
     D Filter_knowsProperty...
     D                 PR              N
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_knowsProperty+
     D                                     ')
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      *
      *  Deletes a given filter.
     D Filter_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_delete+
     D                                     ')
     D  io_pFilter                                like(LOG4RPG_pFilter_t       )
      *
      *  Tests a given filter for a NULL value.
     D Filter_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_isNull+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
      *
      *  Returns a NULL filter.
      *  ==> PLOG4RPG
      *
      /ENDIF
