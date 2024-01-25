*&---------------------------------------------------------------------*
*& Report ZISSUE_HIERARCHY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zissue_hierarchy.

INCLUDE zissue_hierarchy_dd.
INCLUDE zissue_hierarchy_ss.
INCLUDE zissue_hierarchy_validation.

START-OF-SELECTION.
  PERFORM getdata.
