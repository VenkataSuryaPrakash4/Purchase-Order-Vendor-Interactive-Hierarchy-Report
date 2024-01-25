*&---------------------------------------------------------------------*
*& Include          ZISSUE_HIERARCHY_SS
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK blk_1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ebeln FOR ekko-ebeln.

  SELECTION-SCREEN SKIP.

  PARAMETERS: rb_1 RADIOBUTTON GROUP rbg USER-COMMAND r1,
              rb_2 RADIOBUTTON GROUP rbg.
SELECTION-SCREEN END OF BLOCK blk_1.
