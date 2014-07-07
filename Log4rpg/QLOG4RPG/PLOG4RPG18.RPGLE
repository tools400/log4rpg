      /IF NOT DEFINED(PLOG4RPG18)
      /DEFINE PLOG4RPG18
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG17                    Filter
      *
     D LOG4RPG_pFilterList_t...
     D                 S               *                           based(pDummy)
      *
     D LOG4RPG_FilterListIterator_t...
     D                 DS                  qualified               based(pDummy)
     D  pFltList                           like(LOG4RPG_pFilterList_t )
     D  lastFlt                      10I 0
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new filter list.
     D FilterList_new...
     D                 PR                         like(LOG4RPG_pFilterList_t )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_new+
     D                                     ')
      *
      *  Returns the number of entries in a given filter list.
     D FilterList_getNumE...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_NumE+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Adds an filter to a given filter list.
     D FilterList_put...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_put+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Removes the specified filter from the given filter list.
     D FilterList_remove...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_remove+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Returns the filter that matches the specified name.
     D FilterList_get...
     D                 PR                  like(LOG4RPG_pFilter_t     )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_get+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Tests, if the filter list contains the specified filter.
     D FilterList_exist...
     D                 PR              N
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_exist+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Returns an iterator for the specified filter list.
     D FilterList_getIterator...
     D                 PR                  likeds(LOG4RPG_Filter...
     D                                                    ListIterator_t   )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_getIterator+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Returns the first filter of the specified filter list.
     D FilterList_getFirst...
     D                 PR                  like(LOG4RPG_pFilter_t     )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_getFirst+
     D                                     ')
     D  io_fltIter                                likeds(LOG4RPG_Filter...
     D                                                           ListIterator_t)
      *
      *  Returns the next filter of the specified filter list.
     D FilterList_getNext...
     D                 PR                  like(LOG4RPG_pFilter_t     )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_getNext+
     D                                     ')
     D  io_fltIter                                likeds(LOG4RPG_Filter...
     D                                                           ListIterator_t)
      *
      *  Deletes a given filter list.
     D FilterList_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_delete+
     D                                     ')
     D  io_pFltList                               like(LOG4RPG_pFilterList_t )
      *
      *  Test the specified filter list object for a NULL value.
     D FilterList_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_isNull+
     D                                     ')
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Returns a NULL filter list.
     D FilterList_null...
     D                 PR                         like(LOG4RPG_pFilterList_t )
     D                                     extproc('LOG4RPG18+
     D                                     _FilterList_null+
     D                                     ')
      *
      /ENDIF
