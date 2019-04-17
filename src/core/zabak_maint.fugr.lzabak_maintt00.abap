*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 05.04.2019 at 13:53:15
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZABAK...........................................*
DATA:  BEGIN OF STATUS_ZABAK                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABAK                         .
CONTROLS: TCTRL_ZABAK
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZABAK_DEFAULT...................................*
DATA:  BEGIN OF STATUS_ZABAK_DEFAULT                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABAK_DEFAULT                 .
CONTROLS: TCTRL_ZABAK_DEFAULT
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZABAK                         .
TABLES: *ZABAK_DEFAULT                 .
TABLES: ZABAK                          .
TABLES: ZABAK_DEFAULT                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
