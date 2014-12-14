{@********************************************************}
{    Copyright (c) 1999-2012 Zeos Development Group       }
{                                                         }
{        Originally written by EgonHugeist                }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://sourceforge.net/p/zeoslib/tickets/ (BUGTRACKER)}
{   svn://svn.code.sf.net/p/zeoslib/code-0/trunk (SVN)    }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

Unit ZOleDB;

//  Imported oledb on 08.11.2014 00:47:46 from oledb.tlb of:
//  http://py-com-tools.googlecode.com/svn/trunk/sdk-tlbs/

interface
{$I ZDbc.inc}
{.$IFDEF ENABLE_ADO}

{$IFDEF WIN64}
{$ALIGN 8}
{$ELSE}
{$ALIGN 2}
{$ENDIF}
{$MINENUMSIZE 4}

// Dependency: stdole v2 (stdole2.pas)
//  Warning: renamed method 'Reset' in IDBBinderProperties to 'Reset_'
Uses
  Windows,ActiveX,Classes,Variants, ZCompatibility;
Const
  IID_IColumnsInfo : TGUID = '{0C733A11-2A1C-11CE-ADE5-00AA0044773D}';

//add start from msdac.h
  CLSID_DATALINKS: TGUID = '{2206CDB2-19C1-11D1-89E0-00C04FD7A829}'; {DataLinks}
  CLSID_MSDAINITIALIZE: TGUID = '{2206CDB0-19C1-11D1-89E0-00C04FD7A829}';
  IID_IDataInitialize: TGUID = '{2206CCB1-19C1-11D1-89E0-00C04FD7A829}';
//end add from msdac.h
  IID_ICommand : TGUID = '{0C733A63-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IMultipleResults : TGUID = '{0C733A90-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IConvertType : TGUID = '{0C733A88-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandPrepare : TGUID = '{0C733A26-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandProperties : TGUID = '{0C733A79-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandText : TGUID = '{0C733A27-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandWithParameters : TGUID = '{0C733A64-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IAccessor : TGUID = '{0C733A8C-2A1C-11CE-ADE5-00AA0044773D}';

  oledbMajorVersion = 0;
  oledbMinorVersion = 0;
  oledbLCID = 0;
  LIBID_oledb : TGUID = '{5D8DF8EB-BD36-4DB4-A604-E09991233FFC}';

(*  IID_DBStructureDefinitions : TGUID = '{0C733A80-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITypeInfo : TGUID = '{00020401-0000-0000-C000-000000000046}';
  IID_ITypeComp : TGUID = '{00020403-0000-0000-C000-000000000046}';
  IID_ITypeLib : TGUID = '{00020402-0000-0000-C000-000000000046}';*)
  IID_IRowset : TGUID = '{0C733A7C-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetInfo : TGUID = '{0C733A55-2A1C-11CE-ADE5-00AA0044773D}';
  (*IID_IRowsetLocate : TGUID = '{0C733A7D-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetResynch : TGUID = '{0C733A84-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetScroll : TGUID = '{0C733A7E-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IChapteredRowset : TGUID = '{0C733A93-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetFind : TGUID = '{0C733A9D-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowPosition : TGUID = '{0C733A94-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowPositionChange : TGUID = '{0997A571-126E-11D0-9F8A-00A0C9A0631E}';
  IID_IViewRowset : TGUID = '{0C733A97-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IViewChapter : TGUID = '{0C733A98-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IViewSort : TGUID = '{0C733A9A-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IViewFilter : TGUID = '{0C733A9B-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetView : TGUID = '{0C733A99-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetExactScroll : TGUID = '{0C733A7F-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetChange : TGUID = '{0C733A05-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetUpdate : TGUID = '{0C733A6D-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetIdentity : TGUID = '{0C733A09-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetNotify : TGUID = '{0C733A83-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetIndex : TGUID = '{0C733A82-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IColumnsRowset : TGUID = '{0C733A10-2A1C-11CE-ADE5-00AA0044773D}';*)
  IID_IDBCreateCommand : TGUID = '{0C733A1D-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBCreateSession : TGUID = '{0C733A5D-2A1C-11CE-ADE5-00AA0044773D}';
  (*IID_ISourcesRowset : TGUID = '{0C733A1E-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBProperties : TGUID = '{0C733A8A-2A1C-11CE-ADE5-00AA0044773D}';*)
  IID_IDBInitialize : TGUID = '{0C733A8B-2A1C-11CE-ADE5-00AA0044773D}';
  (*IID_IDBInfo : TGUID = '{0C733A89-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBDataSourceAdmin : TGUID = '{0C733A7A-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBAsynchNotify : TGUID = '{0C733A96-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBAsynchStatus : TGUID = '{0C733A95-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ISessionProperties : TGUID = '{0C733A85-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IIndexDefinition : TGUID = '{0C733A68-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITableDefinition : TGUID = '{0C733A86-2A1C-11CE-ADE5-00AA0044773D}';*)
  IID_IOpenRowset : TGUID = '{0C733A69-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBSchemaRowset : TGUID = '{0C733A7B-2A1C-11CE-ADE5-00AA0044773D}';
  (*IID_IMDDataset : TGUID = '{A07CCCD1-8148-11D0-87BB-00C04FC33942}';
  IID_IMDFind : TGUID = '{A07CCCD2-8148-11D0-87BB-00C04FC33942}';
  IID_IMDRangeRowset : TGUID = '{0C733AA0-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IAlterTable : TGUID = '{0C733AA5-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IAlterIndex : TGUID = '{0C733AA6-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetChapterMember : TGUID = '{0C733AA8-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandPersist : TGUID = '{0C733AA7-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetRefresh : TGUID = '{0C733AA9-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IParentRowset : TGUID = '{0C733AAA-2A1C-11CE-ADE5-00AA0044773D}';*)
  IID_IErrorRecords : TGUID = '{0C733A67-2A1C-11CE-ADE5-00AA0044773D}';
  (*IID_IErrorInfo : TGUID = '{1CF2B120-547D-101B-8E65-08002B2BD119}';
  IID_IErrorLookup : TGUID = '{0C733A66-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ISQLErrorInfo : TGUID = '{0C733A74-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IGetDataSource : TGUID = '{0C733A75-2A1C-11CE-ADE5-00AA0044773D}'; *)
  IID_ITransactionLocal : TGUID = '{0C733A5F-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITransaction : TGUID = '{0FB15084-AF41-11CE-BD2B-204C4F4F5020}';
  IID_ITransactionOptions : TGUID = '{3A6AD9E0-23B9-11CF-AD60-00AA00A74CCD}';
  (*IID_ITransactionJoin : TGUID = '{0C733A5E-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITransactionObject : TGUID = '{0C733A60-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITrusteeAdmin : TGUID = '{0C733AA1-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITrusteeGroupAdmin : TGUID = '{0C733AA2-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IObjectAccessControl : TGUID = '{0C733AA3-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ISecurityInfo : TGUID = '{0C733AA4-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITableCreation : TGUID = '{0C733ABC-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ITableDefinitionWithConstraints : TGUID = '{0C733AAB-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRow : TGUID = '{0C733AB4-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowChange : TGUID = '{0C733AB5-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowSchemaChange : TGUID = '{0C733AAE-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IGetRow : TGUID = '{0C733AAF-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IBindResource : TGUID = '{0C733AB1-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IAuthenticate : TGUID = '{79EAC9D0-BAF9-11CE-8C82-00AA004BA90B}';
  IID_IScopedOperations : TGUID = '{0C733AB0-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICreateRow : TGUID = '{0C733AB2-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IDBBinderProperties : TGUID = '{0C733AB3-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IColumnsInfo2 : TGUID = '{0C733AB8-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRegisterProvider : TGUID = '{0C733AB9-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IGetSession : TGUID = '{0C733ABA-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IGetSourceRow : TGUID = '{0C733ABB-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetCurrentIndex : TGUID = '{0C733ABD-2A1C-11CE-ADE5-00AA0044773D}';
  IID_ICommandStream : TGUID = '{0C733ABF-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IRowsetBookmark : TGUID = '{0C733AC2-2A1C-11CE-ADE5-00AA0044773D}';
  *)

//start from oledb.h
  DB_NULLGUID: TGuid = '{00000000-0000-0000-0000-000000000000}';

  DBSCHEMA_TABLES_INFO: TGUID = '{C8B522E0-5CF3-11CE-ADE5-00AA0044773D}';
  MDGUID_MDX: TGUID = '{A07CCCD0-8148-11D0-87BB-00C04FC33942}';
  DBGUID_MDX: TGUID = '{A07CCCD0-8148-11D0-87BB-00C04FC33942}';
  MDSCHEMA_CUBES: TGUID = '{C8B522D8-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_DIMENSIONS: TGUID = '{C8B522D9-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_HIERARCHIES: TGUID = '{C8B522DA-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_LEVELS: TGUID = '{C8B522DB-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_MEASURES: TGUID = '{C8B522DC-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_PROPERTIES: TGUID = '{C8B522DD-5CF3-11CE-ADE5-00AA0044773D}';
  MDSCHEMA_MEMBERS: TGUID = '{C8B522DE-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_TRUSTEE: TGUID = '{C8B522E1-5CF3-11CE-ADE5-00AA0044773D}';

  DBOBJECT_TABLE: TGUID = '{C8B522E2-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_COLUMN: TGUID = '{C8B522E4-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_DATABASE: TGUID = '{C8B522E5-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_PROCEDURE: TGUID = '{C8B522E6-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_VIEW: TGUID = '{C8B522E7-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_SCHEMA: TGUID = '{C8B522E8-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_DOMAIN: TGUID = '{C8B522E9-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_COLLATION: TGUID = '{C8B522EA-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_TRUSTEE: TGUID = '{C8B522EB-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_SCHEMAROWSET: TGUID = '{C8B522EC-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_CHARACTERSET: TGUID = '{C8B522ED-5CF3-11CE-ADE5-00AA0044773D}';
  DBOBJECT_TRANSLATION: TGUID = '{C8B522EE-5CF3-11CE-ADE5-00AA0044773D}';

  DB_PROPERTY_CHECK_OPTION: TGUID = '{C8B5220B-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_CONSTRAINT_CHECK_DEFERRED: TGUID = '{C8B521F0-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_DROP_CASCADE: TGUID = '{C8B521F3-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_UNIQUE: TGUID = '{C8B521F5-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_ON_COMMIT_PRESERVE_ROWS: TGUID = '{C8B52230-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_PRIMARY: TGUID = '{C8B521FC-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_CLUSTERED: TGUID = '{C8B521FF-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_NONCLUSTERED: TGUID = '{C8B52200-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_BTREE: TGUID = '{C8B52201-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_HASH: TGUID = '{C8B52202-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_FILLFACTOR: TGUID = '{C8B52203-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_INITIALSIZE: TGUID = '{C8B52204-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_DISALLOWNULL: TGUID = '{C8B52205-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_IGNORENULL: TGUID = '{C8B52206-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_IGNOREANYNULL: TGUID = '{C8B52207-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_SORTBOOKMARKS: TGUID = '{C8B52208-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_AUTOMATICUPDATE: TGUID = '{C8B52209-5CF3-11CE-ADE5-00AA0044773D}';
  DB_PROPERTY_EXPLICITUPDATE: TGUID = '{C8B5220A-5CF3-11CE-ADE5-00AA0044773D}';

  DBGUID_LIKE_SQL: TGUID = '{C8B521F6-5CF3-11CE-ADE5-00AA0044773D}';
  DBGUID_LIKE_DOS: TGUID = '{C8B521F7-5CF3-11CE-ADE5-00AA0044773D}';
  DBGUID_LIKE_OFS: TGUID = '{C8B521F8-5CF3-11CE-ADE5-00AA0044773D}';
  DBGUID_LIKE_MAPI: TGUID = '{C8B521F9-5CF3-11CE-ADE5-00AA0044773D}';

  DBSCHEMA_ASSERTIONS: TGUID = '{C8B52210-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_CATALOGS: TGUID = '{C8B52211-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_CHARACTER_SETS: TGUID = '{C8B52212-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_COLLATIONS: TGUID = '{C8B52213-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_COLUMNS: TGUID = '{C8B52214-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_CHECK_CONSTRAINTS: TGUID = '{C8B52215-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_CONSTRAINT_COLUMN_USAGE: TGUID = '{C8B52216-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_CONSTRAINT_TABLE_USAGE: TGUID = '{C8B52217-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_KEY_COLUMN_USAGE: TGUID = '{C8B52218-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_REFERENTIAL_CONSTRAINTS: TGUID = '{C8B52219-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_TABLE_CONSTRAINTS: TGUID = '{C8B5221A-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_COLUMN_DOMAIN_USAGE: TGUID = '{C8B5221B-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_INDEXES: TGUID = '{C8B5221E-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_COLUMN_PRIVILEGES: TGUID = '{C8B52221-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_TABLE_PRIVILEGES: TGUID = '{C8B52222-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_USAGE_PRIVILEGES: TGUID = '{C8B52223-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_PROCEDURES: TGUID = '{C8B52224-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_SCHEMATA: TGUID = '{C8B52225-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_SQL_LANGUAGES: TGUID = '{C8B52226-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_STATISTICS: TGUID = '{C8B52227-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_TABLES: TGUID = '{C8B52229-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_TRANSLATIONS: TGUID = '{C8B5222A-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_PROVIDER_TYPES: TGUID = '{C8B5222C-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_VIEWS: TGUID = '{C8B5222D-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_VIEW_COLUMN_USAGE: TGUID = '{C8B5222E-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_VIEW_TABLE_USAGE: TGUID = '{C8B5222F-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_PROCEDURE_PARAMETERS: TGUID = '{C8B522B8-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_FOREIGN_KEYS: TGUID = '{C8B522C4-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_PRIMARY_KEYS: TGUID = '{C8B522C5-5CF3-11CE-ADE5-00AA0044773D}';
  DBSCHEMA_PROCEDURE_COLUMNS: TGUID = '{C8B522C9-5CF3-11CE-ADE5-00AA0044773D}';

  DBCOL_SELFCOLUMNS: TGUID = '{C8B52231-5CF3-11CE-ADE5-00AA0044773D}';
  DBCOL_SPECIALCOL: TGUID = '{C8B52232-5CF3-11CE-ADE5-00AA0044773D}';
  PSGUID_QUERY: TGUID = '{49691C90-7E17-101A-A91C-08002B2ECDA9}';

  DBPROPSET_COLUMN: TGUID = '{C8B522B9-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DATASOURCE: TGUID = '{C8B522BA-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DATASOURCEINFO: TGUID = '{C8B522BB-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_INDEX: TGUID = '{C8B522BD-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DBINIT: TGUID = '{C8B522BC-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_ROWSET: TGUID = '{C8B522BE-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_SESSION: TGUID = '{C8B522C6-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_TABLE: TGUID = '{C8B522BF-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_PROPERTIESINERROR: TGUID = '{C8B522D4-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_VIEW: TGUID = '{C8B522DF-5CF3-11CE-ADE5-00AA0044773D}';

  DBPROPSET_COLUMNALL = '{C8B522F0-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_CONSTRAINTALL = '{C8B522FA-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DATASOURCEALL: TGUID = '{C8B522C0-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DATASOURCEINFOALL: TGUID = '{C8B522C1-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_DBINITALL: TGUID = '{C8B522CA-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_INDEXALL = '{C8B522F1-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_ROWSETALL: TGUID = '{C8B522C2-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_SESSIONALL: TGUID = '{C8B522C7-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_TABLEALL = '{C8B522F2-5CF3-11CE-ADE5-00AA0044773D}';
  DBPROPSET_TRUSTEEALL = '{C8B522F3-5CF3-11CE-ADE5-00AA0044773D}';


  DBGUID_DEFAULT: TGUID = '{C8B521FB-5CF3-11CE-ADE5-00AA0044773D}';
  DBGUID_SQL: TGUID = '{C8B522D7-5CF3-11CE-ADE5-00AA0044773D}';
//end from oledb.h

  MAXCOLS = 4096;
  MAXBOUND = 65535; { High bound for arrays }
//Enums

Type
  tagTYPEKIND =LongWord;
Const
  TKIND_ENUM = $0000000000000000;
  TKIND_RECORD = $0000000000000001;
  TKIND_MODULE = $0000000000000002;
  TKIND_INTERFACE = $0000000000000003;
  TKIND_DISPATCH = $0000000000000004;
  TKIND_COCLASS = $0000000000000005;
  TKIND_ALIAS = $0000000000000006;
  TKIND_UNION = $0000000000000007;
  TKIND_MAX = $0000000000000008;
Type
  tagDESCKIND =LongWord;
Const
  DESCKIND_NONE = $0000000000000000;
  DESCKIND_FUNCDESC = $0000000000000001;
  DESCKIND_VARDESC = $0000000000000002;
  DESCKIND_TYPECOMP = $0000000000000003;
  DESCKIND_IMPLICITAPPOBJ = $0000000000000004;
  DESCKIND_MAX = $0000000000000005;
Type
  tagFUNCKIND =LongWord;
Const
  FUNC_VIRTUAL = $0000000000000000;
  FUNC_PUREVIRTUAL = $0000000000000001;
  FUNC_NONVIRTUAL = $0000000000000002;
  FUNC_STATIC = $0000000000000003;
  FUNC_DISPATCH = $0000000000000004;
Type
  tagINVOKEKIND =LongWord;
Const
  INVOKE_FUNC = $0000000000000001;
  INVOKE_PROPERTYGET = $0000000000000002;
  INVOKE_PROPERTYPUT = $0000000000000004;
  INVOKE_PROPERTYPUTREF = $0000000000000008;
Type
  tagCALLCONV =LongWord;
Const
  CC_FASTCALL = $0000000000000000;
  CC_CDECL = $0000000000000001;
  CC_MSCPASCAL = $0000000000000002;
  CC_PASCAL = $0000000000000002;
  CC_MACPASCAL = $0000000000000003;
  CC_STDCALL = $0000000000000004;
  CC_FPFASTCALL = $0000000000000005;
  CC_SYSCALL = $0000000000000006;
  CC_MPWCDECL = $0000000000000007;
  CC_MPWPASCAL = $0000000000000008;
  CC_MAX = $0000000000000009;
Type
  tagVARKIND =LongWord;
Const
  VAR_PERINSTANCE = $0000000000000000;
  VAR_STATIC = $0000000000000001;
  VAR_CONST = $0000000000000002;
  VAR_DISPATCH = $0000000000000003;
Type
  tagSYSKIND =LongWord;
Const
  SYS_WIN16 = $0000000000000000;
  SYS_WIN32 = $0000000000000001;
  SYS_MAC = $0000000000000002;
  SYS_WIN64 = $0000000000000003;
Type
  _SE_OBJECT_TYPE =LongWord;
Const
  SE_UNKNOWN_OBJECT_TYPE = $0000000000000000;
  SE_FILE_OBJECT = $0000000000000001;
  SE_SERVICE = $0000000000000002;
  SE_PRINTER = $0000000000000003;
  SE_REGISTRY_KEY = $0000000000000004;
  SE_LMSHARE = $0000000000000005;
  SE_KERNEL_OBJECT = $0000000000000006;
  SE_WINDOW_OBJECT = $0000000000000007;
  SE_DS_OBJECT = $0000000000000008;
  SE_DS_OBJECT_ALL = $0000000000000009;
  SE_PROVIDER_DEFINED_OBJECT = $000000000000000A;
  SE_WMIGUID_OBJECT = $000000000000000B;
  SE_REGISTRY_WOW64_32KEY = $000000000000000C;
Type
  _TRUSTEE_TYPE =LongWord;
Const
  TRUSTEE_IS_UNKNOWN = $0000000000000000;
  TRUSTEE_IS_USER = $0000000000000001;
  TRUSTEE_IS_GROUP = $0000000000000002;
  TRUSTEE_IS_DOMAIN = $0000000000000003;
  TRUSTEE_IS_ALIAS = $0000000000000004;
  TRUSTEE_IS_WELL_KNOWN_GROUP = $0000000000000005;
  TRUSTEE_IS_DELETED = $0000000000000006;
  TRUSTEE_IS_INVALID = $0000000000000007;
  TRUSTEE_IS_COMPUTER = $0000000000000008;
Type
  _TRUSTEE_FORM =LongWord;
Const
  TRUSTEE_IS_SID = $0000000000000000;
  TRUSTEE_IS_NAME = $0000000000000001;
  TRUSTEE_BAD_FORM = $0000000000000002;
  TRUSTEE_IS_OBJECTS_AND_SID = $0000000000000003;
  TRUSTEE_IS_OBJECTS_AND_NAME = $0000000000000004;
Type
  _MULTIPLE_TRUSTEE_OPERATION =LongWord;
Const
  NO_MULTIPLE_TRUSTEE = $0000000000000000;
  TRUSTEE_IS_IMPERSONATE = $0000000000000001;
Type
  _ACCESS_MODE =LongWord;
Const
  NOT_USED_ACCESS = $0000000000000000;
  GRANT_ACCESS = $0000000000000001;
  SET_ACCESS = $0000000000000002;
  DENY_ACCESS = $0000000000000003;
  REVOKE_ACCESS = $0000000000000004;
  SET_AUDIT_SUCCESS = $0000000000000005;
  SET_AUDIT_FAILURE = $0000000000000006;
Type
  _PROGRESS_INVOKE_SETTING =LongWord;
Const
  ProgressInvokeNever = $0000000000000001;
  ProgressInvokeEveryObject = $0000000000000002;
  ProgressInvokeOnError = $0000000000000003;
  ProgressCancelOperation = $0000000000000004;
  ProgressRetryOperation = $0000000000000005;
  ProgressInvokePrePostError = $0000000000000006;
// DBCOLUMNFLAGSENUM constants
type
  DBCOLUMNFLAGSENUM = TOleEnum;
const
  DBCOLUMNFLAGS_ISBOOKMARK = $00000001;
  DBCOLUMNFLAGS_MAYDEFER = $00000002;
  DBCOLUMNFLAGS_WRITE = $00000004;
  DBCOLUMNFLAGS_WRITEUNKNOWN = $00000008;
  DBCOLUMNFLAGS_ISFIXEDLENGTH = $00000010;
  DBCOLUMNFLAGS_ISNULLABLE = $00000020;
  DBCOLUMNFLAGS_MAYBENULL = $00000040;
  DBCOLUMNFLAGS_ISLONG = $00000080;
  DBCOLUMNFLAGS_ISROWID = $00000100;
  DBCOLUMNFLAGS_ISROWVER = $00000200;
  DBCOLUMNFLAGS_CACHEDEFERRED = $00001000;

// DBPROPTOPTIONS constants from msdacs.h
type
  DBPROMPTOPTIONS = TOleEnum;
const
  DBPROMPTOPTIONS_NONE = 0;
  DBPROMPTOPTIONS_WIZARDSHEET = $1;
  DBPROMPTOPTIONS_PROPERTYSHEET = $2;
  DBPROMPTOPTIONS_BROWSEONLY = $8;
  DBPROMPTOPTIONS_DISABLE_PROVIDER_SELECTION = $10;

// DBTYPEENUM constants from oledb.h
type
  DBTYPEENUM = TOleEnum;
const
  DBTYPE_EMPTY	= 0;
  DBTYPE_NULL	= 1;
	DBTYPE_I2	= 2;
	DBTYPE_I4	= 3;
	DBTYPE_R4	= 4;
	DBTYPE_R8	= 5;
	DBTYPE_CY	= 6;
	DBTYPE_DATE	= 7;
	DBTYPE_BSTR	= 8;
	DBTYPE_IDISPATCH	= 9;
	DBTYPE_ERROR	= 10;
	DBTYPE_BOOL	= 11;
	DBTYPE_VARIANT	= 12;
	DBTYPE_IUNKNOWN	= 13;
	DBTYPE_DECIMAL	= 14;
	DBTYPE_UI1	= 17;
  DBTYPE_ARRAY = $00002000;
  DBTYPE_BYREF = $00004000;
	DBTYPE_I1	= 16;
	DBTYPE_UI2	= 18;
	DBTYPE_UI4	= 19;
	DBTYPE_I8	= 20;
	DBTYPE_UI8	= 21;
	DBTYPE_GUID	= 72;
  DBTYPE_VECTOR = $00001000;
  DBTYPE_RESERVED = $00008000;
	DBTYPE_BYTES	= 128;
	DBTYPE_STR	= 129;
	DBTYPE_WSTR	= 130;
	DBTYPE_NUMERIC	= 131;
	DBTYPE_UDT	= 132;
	DBTYPE_DBDATE	= 133;
	DBTYPE_DBTIME	= 134;
	DBTYPE_DBTIMESTAMP	= 135;

// DBTYPEENUM15 constants from oledb.h
//@@@+ V1.5
type
  DBTYPEENUM15 = TOleEnum;
const
  DBTYPE_HCHAPTER	= 136;

// DBTYPEENUM20 constants from oledb.h
//@@@+ V2.0
type
  DBTYPEENUM20 = TOleEnum;
const
  DBTYPE_FILETIME	= 64;
	DBTYPE_PROPVARIANT	= 138;
	DBTYPE_VARNUMERIC	= 139;

type
  DBACCESSORFLAGSENUM = TOleEnum;
const
  DBACCESSOR_INVALID = 0;
  DBACCESSOR_PASSBYREF	= $1;
	DBACCESSOR_ROWDATA = $2;
	DBACCESSOR_PARAMETERDATA = $4;
	DBACCESSOR_OPTIMIZED	= $8;
	DBACCESSOR_INHERITED	= $10;

type
  DBBINDSTATUSENUM = TOleEnum;
const
  DBBINDSTATUS_OK	= 0;
	DBBINDSTATUS_BADORDINAL	= $1;
	DBBINDSTATUS_UNSUPPORTEDCONVERSION	= $2;
	DBBINDSTATUS_BADBINDINFO	= $3;
	DBBINDSTATUS_BADSTORAGEFLAGS	= $4;
	DBBINDSTATUS_NOINTERFACE	= $5;
	DBBINDSTATUS_MULTIPLESTORAGE	= $6;

type
  DBPARTENUM = TOleEnum;
const
  DBPART_INVALID = $0;
  DBPART_VALUE = $1;
  DBPART_LENGTH = $2;
  DBPART_STATUS = $4;

type
  DBMEMOWNERENUM = TOleEnum;
const
  DBMEMOWNER_CLIENTOWNED = $0;
  DBMEMOWNER_PROVIDEROWNED = $1;

type
  DBPARAMIOENUM = TOleEnum;
const
  DBPARAMIO_NOTPARAM = $0;
  DBPARAMIO_INPUT = $1;
  DBPARAMIO_OUTPUT = $02;
  DBPARAMIO_INPUTOUTPUT = DBPARAMIO_INPUT or DBPARAMIO_OUTPUT;

type
  DBSTATUSENUM = TOleEnum;
const
  DBSTATUS_S_OK = $0;
  DBSTATUS_E_BADACCESSOR = $1;
  DBSTATUS_E_CANTCONVERTVALUE = $2;
  DBSTATUS_S_ISNULL = $3;
  DBSTATUS_S_TRUNCATED = $4;
  DBSTATUS_E_SIGNMISMATCH = $5;
  DBSTATUS_E_DATAOVERFLOW = $6;
  DBSTATUS_E_CANTCREATE = $7;
  DBSTATUS_E_UNAVAILABLE = $8;
  DBSTATUS_E_PERMISSIONDENIED = $9;
  DBSTATUS_E_INTEGRITYVIOLATION = $A;
  DBSTATUS_E_SCHEMAVIOLATION = $B;
  DBSTATUS_E_BADSTATUS = $C;
  DBSTATUS_S_DEFAULT = $D;

type
  DBPARAMFLAGSENUM = TOleEnum;
const
  DBPARAMFLAGS_ISINPUT = $00000001;
  DBPARAMFLAGS_ISOUTPUT = $00000002;
  DBPARAMFLAGS_ISSIGNED = $00000010;
  DBPARAMFLAGS_ISNULLABLE = $00000040;
  DBPARAMFLAGS_ISLONG = $00000080;
type
  DBPARAMFLAGSENUM20 = TOleEnum;
const
  DBPARAMFLAGS_SCALEISNEGATIVE = $00000100;

type
  XACTTC = TOleEnum;
const
  XACTTC_SYNC_PHASEONE  = $1;
  XACTTC_SYNC_PHASETWO  = $2;
  XACTTC_SYNC           = $2;
  XACTTC_ASYNC_PHASEONE = $4;
  XACTTC_ASYNC          = $4;

type
  ISOLATIONLEVEL = TOleEnum;
const
  ISOLATIONLEVEL_UNSPECIFIED	= $ffffffff;
	ISOLATIONLEVEL_CHAOS	= $10;
	ISOLATIONLEVEL_READUNCOMMITTED	= $100;
	ISOLATIONLEVEL_BROWSE	= $100;
	ISOLATIONLEVEL_READCOMMITTED	= $1000;
	ISOLATIONLEVEL_CURSORSTABILITY	= ISOLATIONLEVEL_READCOMMITTED; //Synonym for ISOLATIONLEVEL_READCOMMITTED
	ISOLATIONLEVEL_REPEATABLEREAD	= $10000;
	ISOLATIONLEVEL_SERIALIZABLE	= $100000;
	ISOLATIONLEVEL_ISOLATED	= ISOLATIONLEVEL_SERIALIZABLE; //Synonym for ISOLATIONLEVEL_SERIALIZABLE

type
  DBRESULTFLAGENUM = (
    DBRESULTFLAG_DEFAULT	= 0,
	  DBRESULTFLAG_ROWSET	= 1,
	  DBRESULTFLAG_ROW	= 2
    );

  PCHAPTER = ^HCHAPTER;
  HCHAPTER = NativeUInt;
const
  DB_NULL_HCHAPTER = HCHAPTER($0000000000000000);

//Forward declarations
type
 IColumnsInfo = interface;

 ICommand = interface;
 IMultipleResults = interface;
 //IConvertType = interface;
 ICommandPrepare = interface;
 ICommandProperties = interface;
 ICommandText = interface;
 ICommandWithParameters = interface;
 //DBStructureDefinitions = interface;
 IAccessor = interface;
 //ITypeInfo = interface;
 //ITypeComp = interface;
 //ITypeLib = interface;
 (*IRowset = interface;
 IRowsetInfo = interface;
 IRowsetLocate = interface;
 IRowsetResynch = interface;
 IRowsetScroll = interface;
 IChapteredRowset = interface;
 IRowsetFind = interface;
 IRowPosition = interface;
 IRowPositionChange = interface;
 IViewRowset = interface;
 IViewChapter = interface;
 IViewSort = interface;
 IViewFilter = interface;
 IRowsetView = interface;
 IRowsetExactScroll = interface;
 IRowsetChange = interface;
 IRowsetUpdate = interface;
 IRowsetIdentity = interface;
 IRowsetNotify = interface;
 IRowsetIndex = interface;
 IColumnsRowset = interface;*)
 IDBCreateCommand = interface;
 IDBCreateSession = interface;
 (*ISourcesRowset = interface;
 IDBProperties = interface;*)
 IDBInitialize = interface;
 (*IDBInfo = interface;
 IDBDataSourceAdmin = interface;
 IDBAsynchNotify = interface;
 IDBAsynchStatus = interface;
 ISessionProperties = interface;
 IIndexDefinition = interface;
 ITableDefinition = interface;
 IOpenRowset = interface;*)
 IDBSchemaRowset = interface;
 (*IMDDataset = interface;
 IMDFind = interface;
 IMDRangeRowset = interface;
 IAlterTable = interface;
 IAlterIndex = interface;
 IRowsetChapterMember = interface;
 ICommandPersist = interface;
 IRowsetRefresh = interface;
 IParentRowset = interface;*)
 IErrorRecords = interface;
 (*IErrorInfo = interface;
 IErrorLookup = interface;
 ISQLErrorInfo = interface;
 IGetDataSource = interface;*)
 ITransactionLocal = interface;
 ITransaction = interface;
 ITransactionOptions = interface;
 (*ITransactionJoin = interface;
 ITransactionObject = interface;
 ITrusteeAdmin = interface;
 ITrusteeGroupAdmin = interface;
 IObjectAccessControl = interface;
 ISecurityInfo = interface;
 ITableCreation = interface;
 ITableDefinitionWithConstraints = interface;
 IRow = interface;
 IRowChange = interface;
 IRowSchemaChange = interface;
 IGetRow = interface;
 IBindResource = interface;
 IAuthenticate = interface;
 IScopedOperations = interface;
 ICreateRow = interface;
 IDBBinderProperties = interface;
 IColumnsInfo2 = interface;
 IRegisterProvider = interface;
 IGetSession = interface;
 IGetSourceRow = interface;
 IRowsetCurrentIndex = interface;
 ICommandStream = interface;
 IRowsetBookmark = interface;
*)
//Map CoClass to its default interface

//from oledb.h
  // Length of a non-character object, size
  PDBLENGTH = ^DBLENGTH;
  DBLENGTH = NativeUInt; //ULONGLONG
  // Offset within a rowset
  DBROWOFFSET = NativeInt;
  // Number of rows
  PDBROWCOUNT = ^DBROWCOUNT;
  DBROWCOUNT = NativeInt;

  PDBCOUNTITEM = ^DBCOUNTITEM;
  DBCOUNTITEM = NativeUInt;
  // Ordinal (column number, etc.)
  DBORDINAL = NativeUInt;
  DB_LORDINAL = NativeInt;
  // Bookmarks
  DBBKMARK = NativeUInt;
  // Offset in the buffer
  DBBYTEOFFSET = NativeUInt;
  // Reference count of each row/accessor  handle
  PDBREFCOUNT = ^DBREFCOUNT;
  DBREFCOUNT = NativeInt;
  // Parameters
  DB_UPARAMS = NativeUInt;
  DB_LPARAMS = NativeInt;
  // hash values corresponding to the elements (bookmarks)
  DBHASHVALUE = LongWord;
  // For reserve
  DB_DWRESERVE = LongWord;
  DB_LRESERVE = NativeInt;
  DB_URESERVE = NativeUInt;

  DBPART = LongWord;
  DBMEMOWNER = LongWord;
  DBPARAMIO = LongWord;
  DBTYPE = Word;
  DBBINDSTATUS = DWORD;

  PDBSTATUS = ^DBSTATUS;
  DBSTATUS = DWORD;

  PIUnknown = ^IUnknown;

  PHROW = ^HROW;
  HROW = NativeUInt;

  DBROWSTATUS = DWORD;


  DBROWOPTIONS = DWORD;

  DBRESULTFLAG = DB_LRESERVE;

//end from oledb.h

//records, unions, aliases

{start:---------------------used by zeos---------------------------------------}
  PDBORDINAL_Array = ^TDBORDINAL_Array;
  TDBORDINAL_Array = array[0..MAXBOUND] of DBORDINAL;

  PDB_LPARAMS_Array = ^TDB_LPARAMS_Array;
  TDB_LPARAMS_Array = array[0..MAXBOUND] of DB_LPARAMS;

  PDB_UPARAMS_Array = ^TDB_UPARAMS_Array;
  TDB_UPARAMS_Array = array[0..MAXBOUND] of DB_UPARAMS;

  PDBBINDSTATUS_Array = ^TDBBINDSTATUS_Array;
  TDBBINDSTATUS_Array = array[0..MAXBOUND] of DBBINDSTATUS;
  TDBBINDSTATUSDynArray = array of DBBINDSTATUS;

  PHROWS_Array = ^THROWS_Array;
  THROWS_Array = array[0..MAXBOUND] of HROW;

  PDBREFCOUNT_Array = ^TDBREFCOUNT_Array;
  TDBREFCOUNT_Array = array[0..MAXBOUND] of DBREFCOUNT;

  PDBROWSTATUS_Array = ^TDBROWSTATUS_Array;
  TDBROWSTATUS_Array = array[0..MAXBOUND] of DBROWSTATUS;

  PDBROWOPTIONS_Array = ^TDBROWOPTIONS_Array;
  TDBROWOPTIONS_Array = array[0..MAXBOUND] of DBROWOPTIONS;

  PULONG_Array = ^TULONG_Array;
  TULONG_Array = array[0..MAXBOUND] of ULONG;

  PDBOBJECT = ^DBOBJECT;
  DBOBJECT = record
    dwFlags : LongWord;
    iid : TIID;
  end;

  PDBBINDEXT = ^DBBINDEXT;

  PDBBINDING = ^TDBBINDING;
  TDBBINDING = record
    iOrdinal : DBORDINAL;
    obValue : DBBYTEOFFSET;
    obLength : DBBYTEOFFSET;
    obStatus : DBBYTEOFFSET; //DWORD ??? http://msdn.microsoft.com/en-us/library/windows/desktop/ms716845%28v=vs.85%29.aspx
    pTypeInfo : ITypeInfo;
    pObject : PDBOBJECT;
    pBindExt : PDBBINDEXT;
    dwPart : DBPART;
    dwMemOwner : DBMEMOWNER;
    eParamIO : DBPARAMIO;
    cbMaxLen : DBLENGTH;
    dwFlags : LongWord;
    wType : DBTYPE;
    bPrecision : Byte;
    bScale : Byte;
  end;

  PDBBindingArray = ^TDBBindingArray;
  TDBBindingArray = array[0..MAXBOUND] of TDBBINDING;
  TDBBindingDynArray = array of TDBBinding;

  DBBINDEXT = record
    pExtension : PByte;
    ulExtension : DBCOUNTITEM;
  end;

  DBCOLUMNFLAGS = LongWord;

  TDBIDGUID = record
    case Integer of
      0: (guid: TGUID);
      1: (pguid: ^TGUID);
  end;
  TDBIDNAME = record
    case Integer of
      0: (pwszName: PWideChar);
      1: (ulPropid: UINT);
  end;

  DBKIND = LongWord;
  TDBID = record
    uGuid: TDBIDGUID;
    eKind: DBKIND;
    uName: TDBIDNAME;
  end;
  PDBCOLUMNINFO = ^TDBCOLUMNINFO;
  TDBCOLUMNINFO = record
    pwszName : PWideChar;
    pTypeInfo : ITypeInfo;
    iOrdinal : DBORDINAL;
    dwFlags : DBCOLUMNFLAGS;
    ulColumnSize : DBLENGTH;
    wType : DBTYPE;
    bPrecision : Byte;
    bScale : Byte;
    columnid : TDBID;
  end;

  PDBIDArray = ^TDBIDArray;
  TDBIDArray = array[0..MAXBOUND] of TDBID;

  DBPARAMFLAGS = DWORD;

  PDBPARAMINFO = ^TDBPARAMINFO;
  TDBPARAMINFO = record
    dwFlags : DBPARAMFLAGS;
    iOrdinal : DBORDINAL;
    pwszName : PWideChar;
    pTypeInfo : ITypeInfo;
    ulParamSize : DBLENGTH;
    wType : DBTYPE;
    bPrecision : Byte;
    bScale : Byte;
  end;
  PDBParamInfoArray = ^TDBParamInfoArray;
  TDBParamInfoArray = array[0..MAXBOUND] of TDBPARAMINFO;

  PHACCESSOR = ^HACCESSOR;
  HACCESSOR = NativeUInt;

  PDBPARAMS = ^TDBPARAMS;
  TDBPARAMS = record
    pData : Pointer;
    cParamSets : DB_UPARAMS;
    hAccessor : HACCESSOR;
  end;

  PDBPARAMBINDINFO = ^TDBPARAMBINDINFO;
  TDBPARAMBINDINFO = record
    pwszDataSourceType : PWideChar;
    pwszName : PWideChar;
    ulParamSize : DBLENGTH;
    dwFlags : DBPARAMFLAGS;
    bPrecision : Byte;
    bScale : Byte;
  end;

  PDBParamBindInfoArray = ^TDBParamBindInfoArray;
  TDBParamBindInfoArray = array[0..MAXBOUND] of TDBParamBindInfo;

  DBPROPID = DWORD;
  DBPROPOPTIONS = DWORD;
  DBPROPSTATUS = DWORD;

  PDBPROP = ^TDBPROP;
  TDBPROP = record
    dwPropertyID : DBPROPID;
    dwOptions : DBPROPOPTIONS;
    dwStatus : DBPROPSTATUS;
    colid : TDBID;
    vValue : OleVariant;
  end;

  PDBPropArray = ^TDBPropArray;
  TDBPropArray = array[0..MAXBOUND] of TDBProp;

  TDBPROPSET = record
    rgProperties : PDBPropArray;
    cProperties : ULONG;
    guidPropertySet : TGUID;
  end;

  PDBPropSetArray = ^TDBPropSetArray;
  TDBPropSetArray = array[0..MAXBOUND] of TDBPropSet;

  PDBACCESSORFLAGS = ^DBACCESSORFLAGS;
  DBACCESSORFLAGS = DWORD;

  TDBPROPIDSET = record
    rgPropertyIDs : TDBPROP;
    cPropertyIDs : ULONG;
    guidPropertySet : TGUID;
  end;
  PDBPROPSET = ^TDBPROPSET;
  PDBPropIDSetArray = ^TDBPropIDSetArray;
  TDBPropIDSetArray = array[0..MAXBOUND] of TDBPropIDSet;

  //transact.h
  PBOID = ^TBOID;
  TBOID = record
    rgb : array[0..15] of Byte;
  end;
  XACTUOW = TBOID;

  ISOLEVEL = Integer;

  PXACTTRANSINFO = ^TXACTTRANSINFO;
  TXACTTRANSINFO = record
    uow : TBOID;
    isoLevel : ISOLEVEL;
    isoFlags : ULONG;
    grfTCSupported : DWORD;
    grfRMSupported : DWORD;
    grfTCSupportedRetaining : DWORD;
    grfRMSupportedRetaining : DWORD;
  end;

  PXACTOPT = ^TXACTOPT;
  TXACTOPT = record
    ulTimeout : ULONG;
    szDescription : array[0..39] of ShortInt;
  end;

  PERRORINFO = ^TERRORINFO;
  TERRORINFO = record
    hrError : HResult;
    dwMinor : DWORD;
    clsid : TGUID;
    iid : TGUID;
    dispid : Integer;
  end;
{end:-----------------------used by zeos---------------------------------------}
(*
 PTYPEATTR = ^TYPEATTR;

 PTYPEDESC = ^TYPEDESC;

 P__MIDL_IOleAutomationTypes_0004 = ^__MIDL_IOleAutomationTypes_0004;

 PARRAYDESC = ^ARRAYDESC;

 __MIDL_IOleAutomationTypes_0004 =  record
    case Integer of
     0: (lptdesc : PTYPEDESC);
     1: (lpadesc : PARRAYDESC);
     2: (hreftype : LongWord);
 end;
 TYPEDESC = packed record
     DUMMYUNIONNAME : __MIDL_IOleAutomationTypes_0004;
     vt : Word;
 end;
 PSAFEARRAYBOUND = ^SAFEARRAYBOUND;

 ARRAYDESC = packed record
     tdescElem : TYPEDESC;
     cDims : Word;
     rgbounds : PSAFEARRAYBOUND;
 end;
 SAFEARRAYBOUND = packed record
     cElements : LongWord;
     lLbound : Integer;
 end;
 PIDLDESC = ^IDLDESC;

 IDLDESC = packed record
     dwReserved : ULONG_PTR;
     wIDLFlags : Word;
 end;
 TYPEATTR = packed record
     guid : TGUID;
     lcid : LongWord;
     dwReserved : LongWord;
     memidConstructor : Integer;
     memidDestructor : Integer;
     lpstrSchema : PWideChar;
     cbSizeInstance : LongWord;
     typekind : tagTYPEKIND;
     cFuncs : Word;
     cVars : Word;
     cImplTypes : Word;
     cbSizeVft : Word;
     cbAlignment : Word;
     wTypeFlags : Word;
     wMajorVerNum : Word;
     wMinorVerNum : Word;
     tdescAlias : TYPEDESC;
     idldescType : IDLDESC;
 end;
 PBINDPTR = ^BINDPTR;

 PFUNCDESC = ^FUNCDESC;

 PELEMDESC = ^ELEMDESC;

 PPARAMDESC = ^PARAMDESC;

 PPARAMDESCEX = ^PARAMDESCEX;

 PARAMDESC = packed record
     pparamdescex : PPARAMDESCEX;
     wParamFlags : Word;
 end;
 ELEMDESC = packed record
     tdesc : TYPEDESC;
     paramdesc : PARAMDESC;
 end;
 FUNCDESC = packed record
     memid : Integer;
     lprgscode : PSCODE;
     lprgelemdescParam : PELEMDESC;
     funckind : tagFUNCKIND;
     invkind : tagINVOKEKIND;
     callconv : tagCALLCONV;
     cParams : Smallint;
     cParamsOpt : Smallint;
     oVft : Smallint;
     cScodes : Smallint;
     elemdescFunc : ELEMDESC;
     wFuncFlags : Word;
 end;
 PARAMDESCEX = packed record
     cBytes : LongWord;
     varDefaultValue : OleVariant;
 end;
 PVARDESC = ^VARDESC;
 (*
 BINDPTR =  record
    case Integer of
     0: (lpfuncdesc : PFUNCDESC);
     1: (lpvardesc : PVARDESC);
     2: (lptcomp : ITypeComp);
 end;
 P__MIDL_IOleAutomationTypes_0005 = ^__MIDL_IOleAutomationTypes_0005;

 __MIDL_IOleAutomationTypes_0005 =  record
    case Integer of
     0: (oInst : LongWord);
     1: (lpvarValue : POleVariant);
 end;
 VARDESC = packed record
     memid : Integer;
     lpstrSchema : PWideChar;
     DUMMYUNIONNAME : __MIDL_IOleAutomationTypes_0005;
     elemdescVar : ELEMDESC;
     wVarFlags : Word;
     varkind : tagVARKIND;
 end;
 PTLIBATTR = ^TLIBATTR;

 TLIBATTR = packed record
     guid : TGUID;
     lcid : LongWord;
     syskind : tagSYSKIND;
     wMajorVerNum : Word;
     wMinorVerNum : Word;
     wLibFlags : Word;
 end;
 PDBPROPIDSET = ^TDBPROPIDSET;

 P__MIDL_DBStructureDefinitions_0001 = ^__MIDL_DBStructureDefinitions_0001;

 __MIDL_DBStructureDefinitions_0001 =  record
    case Integer of
     0: (guid : TGUID);
     1: (pguid : PGUID);
 end;
 P__MIDL_DBStructureDefinitions_0002 = ^__MIDL_DBStructureDefinitions_0002;

 __MIDL_DBStructureDefinitions_0002 =  record
    case Integer of
     0: (pwszName : PWideChar);
     1: (ulPropid : LongWord);
 end;
 TDBID = packed record
     uGuid : __MIDL_DBStructureDefinitions_0001;
     eKind : LongWord;
     uName : __MIDL_DBStructureDefinitions_0002;
 end;

 PDBID = ^TDBID;

 PDBINDEXCOLUMNDESC = ^DBINDEXCOLUMNDESC;

 DBINDEXCOLUMNDESC = packed record
     pColumnID : PDBID;
     eIndexColOrder : LongWord;
 end;

 PDBPROPINFOSET = ^DBPROPINFOSET;

 PDBPROPINFO = ^DBPROPINFO;

 DBPROPINFOSET = packed record
     rgPropertyInfos : PDBPROPINFO;
     cPropertyInfos : LongWord;
     guidPropertySet : TGUID;
 end;

 DBPROPINFO = packed record
     pwszDescription : PWideChar;
     dwPropertyID : LongWord;
     dwFlags : LongWord;
     vtType : Word;
     vValues : OleVariant;
 end;
 PDBLITERALINFO = ^DBLITERALINFO;

 DBLITERALINFO = packed record
     pwszLiteralValue : PWideChar;
     pwszInvalidChars : PWideChar;
     pwszInvalidStartingChars : PWideChar;
     lt : LongWord;
     fSupported : Integer;
     cchMaxLen : LongWord;
 end;
 PDBCOLUMNDESC = ^DBCOLUMNDESC;

 DBCOLUMNDESC = packed record
     pwszTypeName : PWideChar;
     pTypeInfo : ITypeInfo;
     rgPropertySets : PDBPROPSET;
     pclsid : PGUID;
     cPropertySets : LongWord;
     ulColumnSize : LongWord;
     dbcid : TDBID;
     wType : Word;
     bPrecision : Byte;
     bScale : Byte;
 end;
 PMDAXISINFO = ^MDAXISINFO;

 MDAXISINFO = packed record
     cbSize : LongWord;
     iAxis : LongWord;
     cDimensions : LongWord;
     cCoordinates : LongWord;
     rgcColumns : PLongWord;
     rgpwszDimensionNames : PPWideChar;
 end;

 P_OBJECTS_AND_SID = ^_OBJECTS_AND_SID;

 P_SID = ^_SID;

 _OBJECTS_AND_SID = packed record
     ObjectsPresent : LongWord;
     ObjectTypeGuid : TGUID;
     InheritedObjectTypeGuid : TGUID;
     pSid : P_SID;
 end;
 P_SID_IDENTIFIER_AUTHORITY = ^_SID_IDENTIFIER_AUTHORITY;

 _SID_IDENTIFIER_AUTHORITY = packed record
     Value : array[0..5] of Byte;
 end;
 _SID = packed record
     Revision : Byte;
     SubAuthorityCount : Byte;
     IdentifierAuthority : _SID_IDENTIFIER_AUTHORITY;
     SubAuthority : PLongWord;
 end;
 P_OBJECTS_AND_NAME_A = ^_OBJECTS_AND_NAME_A;

 _OBJECTS_AND_NAME_A = packed record
     ObjectsPresent : LongWord;
     ObjectType : _SE_OBJECT_TYPE;
     ObjectTypeName : PChar;
     InheritedObjectTypeName : PChar;
     ptstrName : PChar;
 end;
 P_OBJECTS_AND_NAME_W = ^_OBJECTS_AND_NAME_W;

 _OBJECTS_AND_NAME_W = packed record
     ObjectsPresent : LongWord;
     ObjectType : _SE_OBJECT_TYPE;
     ObjectTypeName : PWideChar;
     InheritedObjectTypeName : PWideChar;
     ptstrName : PWideChar;
 end;
 P_TRUSTEE_A = ^_TRUSTEE_A;

 P__MIDL___MIDL_itf_oledb_0001_0060_0001 = ^__MIDL___MIDL_itf_oledb_0001_0060_0001;

 __MIDL___MIDL_itf_oledb_0001_0060_0001 =  record
    case Integer of
     0: (ptstrName : PChar);
     1: (pSid : P_SID);
     2: (pObjectsAndSid : P_OBJECTS_AND_SID);
     3: (pObjectsAndName : P_OBJECTS_AND_NAME_A);
 end;
 _TRUSTEE_A = packed record
     pMultipleTrustee : P_TRUSTEE_A;
     MultipleTrusteeOperation : _MULTIPLE_TRUSTEE_OPERATION;
     TrusteeForm : _TRUSTEE_FORM;
     TrusteeType : _TRUSTEE_TYPE;
     __MIDL____MIDL_itf_oledb_0001_00600000 : __MIDL___MIDL_itf_oledb_0001_0060_0001;
 end;
 P_TRUSTEE_W = ^_TRUSTEE_W;

 P__MIDL___MIDL_itf_oledb_0001_0060_0002 = ^__MIDL___MIDL_itf_oledb_0001_0060_0002;

 __MIDL___MIDL_itf_oledb_0001_0060_0002 =  record
    case Integer of
     0: (ptstrName : PWideChar);
     1: (pSid : P_SID);
     2: (pObjectsAndSid : P_OBJECTS_AND_SID);
     3: (pObjectsAndName : P_OBJECTS_AND_NAME_W);
 end;
 _TRUSTEE_W = packed record
     pMultipleTrustee : P_TRUSTEE_W;
     MultipleTrusteeOperation : _MULTIPLE_TRUSTEE_OPERATION;
     TrusteeForm : _TRUSTEE_FORM;
     TrusteeType : _TRUSTEE_TYPE;
     __MIDL____MIDL_itf_oledb_0001_00600001 : __MIDL___MIDL_itf_oledb_0001_0060_0002;
 end;
 P_EXPLICIT_ACCESS_A = ^_EXPLICIT_ACCESS_A;

 _EXPLICIT_ACCESS_A = packed record
     grfAccessPermissions : LongWord;
     grfAccessMode : _ACCESS_MODE;
     grfInheritance : LongWord;
     Trustee : _TRUSTEE_A;
 end;
 P_EXPLICIT_ACCESS_W = ^_EXPLICIT_ACCESS_W;

 _EXPLICIT_ACCESS_W = packed record
     grfAccessPermissions : LongWord;
     grfAccessMode : _ACCESS_MODE;
     grfInheritance : LongWord;
     Trustee : _TRUSTEE_W;
 end;
 P_ACTRL_ACCESS_ENTRYA = ^_ACTRL_ACCESS_ENTRYA;

 _ACTRL_ACCESS_ENTRYA = packed record
     Trustee : _TRUSTEE_A;
     fAccessFlags : LongWord;
     Access : LongWord;
     ProvSpecificAccess : LongWord;
     Inheritance : LongWord;
     lpInheritProperty : PChar;
 end;
 P_ACTRL_ACCESS_ENTRYW = ^_ACTRL_ACCESS_ENTRYW;

 _ACTRL_ACCESS_ENTRYW = packed record
     Trustee : _TRUSTEE_W;
     fAccessFlags : LongWord;
     Access : LongWord;
     ProvSpecificAccess : LongWord;
     Inheritance : LongWord;
     lpInheritProperty : PWideChar;
 end;
 P_ACTRL_ACCESS_ENTRY_LISTA = ^_ACTRL_ACCESS_ENTRY_LISTA;

 _ACTRL_ACCESS_ENTRY_LISTA = packed record
     cEntries : LongWord;
     pAccessList : P_ACTRL_ACCESS_ENTRYA;
 end;
 P_ACTRL_ACCESS_ENTRY_LISTW = ^_ACTRL_ACCESS_ENTRY_LISTW;

 _ACTRL_ACCESS_ENTRY_LISTW = packed record
     cEntries : LongWord;
     pAccessList : P_ACTRL_ACCESS_ENTRYW;
 end;
 P_ACTRL_PROPERTY_ENTRYA = ^_ACTRL_PROPERTY_ENTRYA;

 _ACTRL_PROPERTY_ENTRYA = packed record
     lpProperty : PChar;
     pAccessEntryList : P_ACTRL_ACCESS_ENTRY_LISTA;
     fListFlags : LongWord;
 end;
 P_ACTRL_PROPERTY_ENTRYW = ^_ACTRL_PROPERTY_ENTRYW;

 _ACTRL_PROPERTY_ENTRYW = packed record
     lpProperty : PWideChar;
     pAccessEntryList : P_ACTRL_ACCESS_ENTRY_LISTW;
     fListFlags : LongWord;
 end;
 P_ACTRL_ALISTA = ^_ACTRL_ALISTA;

 _ACTRL_ALISTA = packed record
     cEntries : LongWord;
     pPropertyAccessList : P_ACTRL_PROPERTY_ENTRYA;
 end;
 P_ACTRL_ALISTW = ^_ACTRL_ALISTW;

 _ACTRL_ALISTW = packed record
     cEntries : LongWord;
     pPropertyAccessList : P_ACTRL_PROPERTY_ENTRYW;
 end;
 P_TRUSTEE_ACCESSA = ^_TRUSTEE_ACCESSA;

 _TRUSTEE_ACCESSA = packed record
     lpProperty : PChar;
     Access : LongWord;
     fAccessFlags : LongWord;
     fReturnedAccess : LongWord;
 end;
 P_TRUSTEE_ACCESSW = ^_TRUSTEE_ACCESSW;

 _TRUSTEE_ACCESSW = packed record
     lpProperty : PWideChar;
     Access : LongWord;
     fAccessFlags : LongWord;
     fReturnedAccess : LongWord;
 end;
 P_ACTRL_OVERLAPPED = ^_ACTRL_OVERLAPPED;

 P__MIDL___MIDL_itf_oledb_0001_0060_0003 = ^__MIDL___MIDL_itf_oledb_0001_0060_0003;

 __MIDL___MIDL_itf_oledb_0001_0060_0003 =  record
    case Integer of
     0: (Provider : Ppointer);
     1: (Reserved1 : LongWord);
 end;
 _ACTRL_OVERLAPPED = packed record
     __MIDL____MIDL_itf_oledb_0001_00600002 : __MIDL___MIDL_itf_oledb_0001_0060_0003;
     Reserved2 : LongWord;
     hEvent : Ppointer;
 end;
 P_ACTRL_ACCESS_INFOA = ^_ACTRL_ACCESS_INFOA;

 _ACTRL_ACCESS_INFOA = packed record
     fAccessPermission : LongWord;
     lpAccessPermissionName : PChar;
 end;
 P_ACTRL_ACCESS_INFOW = ^_ACTRL_ACCESS_INFOW;

 _ACTRL_ACCESS_INFOW = packed record
     fAccessPermission : LongWord;
     lpAccessPermissionName : PWideChar;
 end;
 P_ACTRL_CONTROL_INFOA = ^_ACTRL_CONTROL_INFOA;

 _ACTRL_CONTROL_INFOA = packed record
     lpControlId : PChar;
     lpControlName : PChar;
 end;
 P_ACTRL_CONTROL_INFOW = ^_ACTRL_CONTROL_INFOW;

 _ACTRL_CONTROL_INFOW = packed record
     lpControlId : PWideChar;
     lpControlName : PWideChar;
 end;
 P_FN_OBJECT_MGR_FUNCTIONS = ^_FN_OBJECT_MGR_FUNCTIONS;

 _FN_OBJECT_MGR_FUNCTIONS = packed record
     Placeholder : LongWord;
 end;
 P_INHERITED_FROMA = ^_INHERITED_FROMA;

 _INHERITED_FROMA = packed record
     GenerationGap : Integer;
     AncestorName : PChar;
 end;
 P_INHERITED_FROMW = ^_INHERITED_FROMW;

 _INHERITED_FROMW = packed record
     GenerationGap : Integer;
     AncestorName : PWideChar;
 end;
 P_SEC_OBJECT = ^_SEC_OBJECT;

 P_SEC_OBJECT_ELEMENT = ^_SEC_OBJECT_ELEMENT;

 _SEC_OBJECT = packed record
     cObjects : LongWord;
     prgObjects : P_SEC_OBJECT_ELEMENT;
 end;
 _SEC_OBJECT_ELEMENT = packed record
     guidObjectType : TGUID;
     ObjectID : TDBID;
 end;
 PDBCONSTRAINTDESC = ^DBCONSTRAINTDESC;

 DBCONSTRAINTDESC = packed record
     pConstraintID : PDBID;
     ConstraintType : LongWord;
     cColumns : LongWord;
     rgColumnList : PDBID;
     pReferencedTableID : PDBID;
     cForeignKeyColumns : LongWord;
     rgForeignKeyColumnList : PDBID;
     pwszConstraintText : PWord;
     UpdateRule : LongWord;
     DeleteRule : LongWord;
     MatchType : LongWord;
     Deferrability : LongWord;
     cReserved : LongWord;
     rgReserved : PDBPROPSET;
 end;
 PDBCOLUMNACCESS = ^DBCOLUMNACCESS;

 DBCOLUMNACCESS = packed record
     pData : Ppointer;
     columnid : TDBID;
     cbDataLen : LongWord;
     dwStatus : LongWord;
     cbMaxLen : LongWord;
     dwReserved : LongWord;
     wType : Word;
     bPrecision : Byte;
     bScale : Byte;
 end;
 P_RemotableHandle = ^_RemotableHandle;

 wireHWND = P_RemotableHandle;
 P__MIDL_IWinTypes_0009 = ^__MIDL_IWinTypes_0009;

 __MIDL_IWinTypes_0009 =  record
    case Integer of
     0: (hInproc : Integer);
     1: (hRemote : Integer);
 end;
 _RemotableHandle = packed record
     fContext : Integer;
     u : __MIDL_IWinTypes_0009;
 end;
 PDBIMPLICITSESSION = ^DBIMPLICITSESSION;

 DBIMPLICITSESSION = packed record
     pUnkOuter : IUnknown;
     piid : PGUID;
     pSession : IUnknown;
 end;

//interface declarations

// DBStructureDefinitions :

 DBStructureDefinitions = interface
   ['{0C733A80-2A1C-11CE-ADE5-00AA0044773D}']
  end;

*)
// IAccessor :

 IAccessor = interface(IUnknown)
   ['{0C733A8C-2A1C-11CE-ADE5-00AA0044773D}']
    // AddRefAccessor :
   function AddRefAccessor(hAccessor: HACCESSOR;var pcRefCount: DBREFCOUNT):HRESULT;stdcall;
    // CreateAccessor :
   function CreateAccessor(dwAccessorFlags: DBACCESSORFLAGS; cBindings: DBCOUNTITEM;
     rgBindings: PDBBindingArray; cbRowSize:DBLENGTH; phAccessor: PHACCESSOR;
     rgStatus: PDBBINDSTATUS_Array):HRESULT;stdcall;
    // GetBindings :
   function GetBindings(hAccessor:HACCESSOR; pdwAccessorFlags: PDBACCESSORFLAGS;
    pcBindings: PDBCOUNTITEM;out prgBindings: PDBBINDING):HRESULT;stdcall;
    // ReleaseAccessor :
   function ReleaseAccessor(hAccessor:HACCESSOR; pcRefCount: PDBREFCOUNT):HRESULT;stdcall;
  end;
(*

// ITypeInfo :
(*
 ITypeInfo = interface(IUnknown)
   ['{00020401-0000-0000-C000-000000000046}']
    // GetTypeAttr :
   function GetTypeAttr(out ppTypeAttr:PTYPEATTR):HRESULT;stdcall;
    // GetTypeComp :
   function GetTypeComp(out ppTComp:ITypeComp):HRESULT;stdcall;
    // GetFuncDesc :
   function GetFuncDesc(index:UInt;out ppFuncDesc:PFUNCDESC):HRESULT;stdcall;
    // GetVarDesc :
   function GetVarDesc(index:UInt;out ppVarDesc:PVARDESC):HRESULT;stdcall;
    // GetNames :
   function GetNames(memid:Integer;out rgBstrNames:WideString;cMaxNames:UInt;out pcNames:UInt):HRESULT;stdcall;
    // GetRefTypeOfImplType :
   function GetRefTypeOfImplType(index:UInt;out pRefType:LongWord):HRESULT;stdcall;
    // GetImplTypeFlags :
   function GetImplTypeFlags(index:UInt;out pImplTypeFlags:SYSINT):HRESULT;stdcall;
    // GetIDsOfNames :
   function GetIDsOfNames(var rgszNames:PWideChar;cNames:UInt;out pMemId:Integer):HRESULT;stdcall;
    // Invoke :
   function Invoke(var pvInstance:pointer;memid:Integer;wFlags:Word;var pDispParams:DISPPARAMS;out pVarResult:OleVariant;out pExcepInfo:EXCEPINFO;out puArgErr:UInt):HRESULT;stdcall;
    // GetDocumentation :
   function GetDocumentation(memid:Integer;out pBstrName:WideString;out pBstrDocString:WideString;out pdwHelpContext:LongWord;out pBstrHelpFile:WideString):HRESULT;stdcall;
    // GetDllEntry :
   function GetDllEntry(memid:Integer;invkind:tagINVOKEKIND;out pBstrDllName:WideString;out pBstrName:WideString;out pwOrdinal:Word):HRESULT;stdcall;
    // GetRefTypeInfo :
   function GetRefTypeInfo(hreftype:LongWord;out ppTInfo:ITypeInfo):HRESULT;stdcall;
    // AddressOfMember :
   function AddressOfMember(memid:Integer;invkind:tagINVOKEKIND;out ppv:Ppointer):HRESULT;stdcall;
    // CreateInstance :
   function CreateInstance(pUnkOuter:IUnknown;var riid:GUID;out ppvObj:Ppointer):HRESULT;stdcall;
    // GetMops :
   function GetMops(memid:Integer;out pBstrMops:WideString):HRESULT;stdcall;
    // GetContainingTypeLib :
   function GetContainingTypeLib(out ppTLib:ITypeLib;out pIndex:UInt):HRESULT;stdcall;
    // ReleaseTypeAttr :
   function ReleaseTypeAttr(var pTypeAttr:TYPEATTR):HRESULT;stdcall;
    // ReleaseFuncDesc :
   function ReleaseFuncDesc(var pFuncDesc:FUNCDESC):HRESULT;stdcall;
    // ReleaseVarDesc :
   function ReleaseVarDesc(var pVarDesc:VARDESC):HRESULT;stdcall;
  end;


// ITypeComp :

 ITypeComp = interface(IUnknown)
   ['{00020403-0000-0000-C000-000000000046}']
    // Bind :
   function Bind(szName:PWideChar;lHashVal:LongWord;wFlags:Word;out ppTInfo:ITypeInfo;out pDescKind:tagDESCKIND;out pBindPtr:BINDPTR):HRESULT;stdcall;
    // BindType :
   function BindType(szName:PWideChar;lHashVal:LongWord;out ppTInfo:ITypeInfo;out ppTComp:ITypeComp):HRESULT;stdcall;
  end;


// ITypeLib :

 ITypeLib = interface(IUnknown)
   ['{00020402-0000-0000-C000-000000000046}']
    // GetTypeInfoCount :
   function GetTypeInfoCount:HRESULT;stdcall;
    // GetTypeInfo :
   function GetTypeInfo(index:UInt;out ppTInfo:ITypeInfo):HRESULT;stdcall;
    // GetTypeInfoType :
   function GetTypeInfoType(index:UInt;out pTKind:tagTYPEKIND):HRESULT;stdcall;
    // GetTypeInfoOfGuid :
   function GetTypeInfoOfGuid(var guid:GUID;out ppTInfo:ITypeInfo):HRESULT;stdcall;
    // GetLibAttr :
   function GetLibAttr(out ppTLibAttr:PTLIBATTR):HRESULT;stdcall;
    // GetTypeComp :
   function GetTypeComp(out ppTComp:ITypeComp):HRESULT;stdcall;
    // GetDocumentation :
   function GetDocumentation(index:SYSINT;out pBstrName:WideString;out pBstrDocString:WideString;out pdwHelpContext:LongWord;out pBstrHelpFile:WideString):HRESULT;stdcall;
    // IsName :
   function IsName(szNameBuf:PWideChar;lHashVal:LongWord;out pfName:Integer):HRESULT;stdcall;
    // FindName :
   function FindName(szNameBuf:PWideChar;lHashVal:LongWord;out ppTInfo:ITypeInfo;out rgMemId:Integer;var pcFound:Word):HRESULT;stdcall;
    // ReleaseTLibAttr :
   function ReleaseTLibAttr(var pTLibAttr:TLIBATTR):HRESULT;stdcall;
  end;
*)
// IRowset :

  IRowset = interface(IUnknown)
   ['{0C733A7C-2A1C-11CE-ADE5-00AA0044773D}']
    // AddRefRows :
    function AddRefRows(cRows: DBCOUNTITEM; const rghRows: PHROWS_Array;
      out rgRefCounts: PDBREFCOUNT_Array; out rgRowStatus: PDBROWSTATUS_Array):HRESULT;stdcall;
    // GetData :
    function GetData(hRow: HROW; hAccessor:HACCESSOR; {out don't work!} pData:pointer):HRESULT;stdcall;
    // GetNextRows :
    function GetNextRows(hReserved: HCHAPTER; lRowsOffset: DBROWOFFSET;
      cRows:DBROWCOUNT;out pcRowsObtained:DBCOUNTITEM;out prghRows: PHROWS_Array):HRESULT;stdcall;
    // ReleaseRows :
    function ReleaseRows(cRows:DBCOUNTITEM; rghRows:PHROWS_Array;
      rgRowOptions:PDBROWOPTIONS_Array; rgRefCounts: PDBREFCOUNT_Array;
      rgRowStatus:PDBROWSTATUS_Array):HRESULT;stdcall;
    // RestartPosition :
    function RestartPosition(hReserved:HCHAPTER):HRESULT;stdcall;
  end;


// IRowsetInfo :

 IRowsetInfo = interface(IUnknown)
   ['{0C733A55-2A1C-11CE-ADE5-00AA0044773D}']
    // GetProperties :
   function GetProperties(cPropertyIDSets:ULONG; rgPropertyIDSets:PDBPropIDSetArray;
    out pcPropertySets:ULONG; out prgPropertySets:PDBPROPSET):HRESULT;stdcall;
    // GetReferencedRowset :
   function GetReferencedRowset(iOrdinal:DBORDINAL; const riid:TGUID;
    out ppReferencedRowset:IUnknown):HRESULT;stdcall;
    // GetSpecification :
   function GetSpecification(const riid:TGUID;out ppSpecification:IUnknown):HRESULT;stdcall;
  end;
(*

// IRowsetLocate :

 IRowsetLocate = interface(IRowset)
   ['{0C733A7D-2A1C-11CE-ADE5-00AA0044773D}']
    // Compare :
   procedure Compare(hReserved:ULONG_PTR;cbBookmark1:LongWord;var pBookmark1:Byte;cbBookmark2:LongWord;var pBookmark2:Byte;out pComparison:LongWord);safecall;
    // GetRowsAt :
   procedure GetRowsAt(hReserved1:ULONG_PTR;hReserved2:ULONG_PTR;cbBookmark:LongWord;var pBookmark:Byte;lRowsOffset:Integer;cRows:Integer;out pcRowsObtained:LongWord;out prghRows:PULONG_PTR);safecall;
    // GetRowsByBookmark :
   procedure GetRowsByBookmark(hReserved:ULONG_PTR;cRows:LongWord;var rgcbBookmarks:LongWord;var rgpBookmarks:PByte;out rghRows:ULONG_PTR;out rgRowStatus:LongWord);safecall;
    // Hash :
   procedure Hash(hReserved:ULONG_PTR;cBookmarks:LongWord;var rgcbBookmarks:LongWord;var rgpBookmarks:PByte;out rgHashedValues:LongWord;out rgBookmarkStatus:LongWord);safecall;
  end;


// IRowsetResynch :

 IRowsetResynch = interface(IUnknown)
   ['{0C733A84-2A1C-11CE-ADE5-00AA0044773D}']
    // GetVisibleData :
   function GetVisibleData(hRow:ULONG_PTR;hAccessor:ULONG_PTR;out pData:pointer):HRESULT;stdcall;
    // ResynchRows :
   function ResynchRows(cRows:LongWord;var rghRows:ULONG_PTR;out pcRowsResynched:LongWord;out prghRowsResynched:PULONG_PTR;out prgRowStatus:PLongWord):HRESULT;stdcall;
  end;


// IRowsetScroll :

 IRowsetScroll = interface(IRowsetLocate)
   ['{0C733A7E-2A1C-11CE-ADE5-00AA0044773D}']
    // GetApproximatePosition :
   procedure GetApproximatePosition(hReserved:ULONG_PTR;cbBookmark:LongWord;var pBookmark:Byte;out pulPosition:LongWord;out pcRows:LongWord);safecall;
    // GetRowsAtRatio :
   procedure GetRowsAtRatio(hReserved1:ULONG_PTR;hReserved2:ULONG_PTR;ulNumerator:LongWord;ulDenominator:LongWord;cRows:Integer;out pcRowsObtained:LongWord;out prghRows:PULONG_PTR);safecall;
  end;


// IChapteredRowset :

 IChapteredRowset = interface(IUnknown)
   ['{0C733A93-2A1C-11CE-ADE5-00AA0044773D}']
    // AddRefChapter :
   function AddRefChapter(hChapter:ULONG_PTR;out pcRefCount:LongWord):HRESULT;stdcall;
    // ReleaseChapter :
   function ReleaseChapter(hChapter:ULONG_PTR;out pcRefCount:LongWord):HRESULT;stdcall;
  end;


// IRowsetFind :

 IRowsetFind = interface(IUnknown)
   ['{0C733A9D-2A1C-11CE-ADE5-00AA0044773D}']
    // FindNextRow :
   function FindNextRow(hChapter:ULONG_PTR;hAccessor:ULONG_PTR;var pFindValue:pointer;CompareOp:LongWord;cbBookmark:LongWord;var pBookmark:Byte;lRowsOffset:Integer;cRows:Integer;var pcRowsObtained:LongWord;out prghRows:PULONG_PTR):HRESULT;stdcall;
  end;


// IRowPosition :

 IRowPosition = interface(IUnknown)
   ['{0C733A94-2A1C-11CE-ADE5-00AA0044773D}']
    // ClearRowPosition :
   function ClearRowPosition:HRESULT;stdcall;
    // GetRowPosition :
   function GetRowPosition(out phChapter:ULONG_PTR;out phRow:ULONG_PTR;out pdwPositionFlags:LongWord):HRESULT;stdcall;
    // GetRowset :
   function GetRowset(var riid:GUID;out ppRowset:IUnknown):HRESULT;stdcall;
    // Initialize :
   function Initialize(pRowset:IUnknown):HRESULT;stdcall;
    // SetRowPosition :
   function SetRowPosition(hChapter:ULONG_PTR;hRow:ULONG_PTR;dwPositionFlags:LongWord):HRESULT;stdcall;
  end;


// IRowPositionChange :

 IRowPositionChange = interface(IUnknown)
   ['{0997A571-126E-11D0-9F8A-00A0C9A0631E}']
    // OnRowPositionChange :
   function OnRowPositionChange(eReason:LongWord;ePhase:LongWord;fCantDeny:Integer):HRESULT;stdcall;
  end;


// IViewRowset :

 IViewRowset = interface(IUnknown)
   ['{0C733A97-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSpecification :
   function GetSpecification(var riid:GUID;out ppObject:IUnknown):HRESULT;stdcall;
    // OpenViewRowset :
   function OpenViewRowset(pUnkOuter:IUnknown;var riid:GUID;out ppRowset:IUnknown):HRESULT;stdcall;
  end;


// IViewChapter :

 IViewChapter = interface(IUnknown)
   ['{0C733A98-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSpecification :
   function GetSpecification(var riid:GUID;out ppRowset:IUnknown):HRESULT;stdcall;
    // OpenViewChapter :
   function OpenViewChapter(hSource:ULONG_PTR;out phViewChapter:ULONG_PTR):HRESULT;stdcall;
  end;


// IViewSort :

 IViewSort = interface(IUnknown)
   ['{0C733A9A-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSortOrder :
   function GetSortOrder(out pcValues:LongWord;out prgColumns:PLongWord;out prgOrders:PLongWord):HRESULT;stdcall;
    // SetSortOrder :
   function SetSortOrder(cValues:LongWord;var rgColumns:LongWord;var rgOrders:LongWord):HRESULT;stdcall;
  end;


// IViewFilter :

 IViewFilter = interface(IUnknown)
   ['{0C733A9B-2A1C-11CE-ADE5-00AA0044773D}']
    // GetFilter :
   function GetFilter(hAccessor:ULONG_PTR;out pcRows:LongWord;out pCompareOps:PLongWord;out pCriteriaData:pointer):HRESULT;stdcall;
    // GetFilterBindings :
   function GetFilterBindings(out pcBindings:LongWord;out prgBindings:PDBBINDING):HRESULT;stdcall;
    // SetFilter :
   function SetFilter(hAccessor:ULONG_PTR;cRows:LongWord;var CompareOps:LongWord;var pCriteriaData:pointer):HRESULT;stdcall;
  end;


// IRowsetView :

 IRowsetView = interface(IUnknown)
   ['{0C733A99-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateView :
   function CreateView(pUnkOuter:IUnknown;var riid:GUID;out ppView:IUnknown):HRESULT;stdcall;
    // GetView :
   function GetView(hChapter:ULONG_PTR;var riid:GUID;out phChapterSource:ULONG_PTR;out ppView:IUnknown):HRESULT;stdcall;
  end;


// IRowsetExactScroll :

 IRowsetExactScroll = interface(IRowsetScroll)
   ['{0C733A7F-2A1C-11CE-ADE5-00AA0044773D}']
    // GetExactPosition :
   procedure GetExactPosition(hChapter:ULONG_PTR;cbBookmark:LongWord;var pBookmark:Byte;out pulPosition:LongWord;out pcRows:LongWord);safecall;
  end;


// IRowsetChange :

 IRowsetChange = interface(IUnknown)
   ['{0C733A05-2A1C-11CE-ADE5-00AA0044773D}']
    // DeleteRows :
   function DeleteRows(hReserved:ULONG_PTR;cRows:LongWord;var rghRows:ULONG_PTR;out rgRowStatus:LongWord):HRESULT;stdcall;
    // SetData :
   function SetData(hRow:ULONG_PTR;hAccessor:ULONG_PTR;var pData:pointer):HRESULT;stdcall;
    // InsertRow :
   function InsertRow(hReserved:ULONG_PTR;hAccessor:ULONG_PTR;var pData:pointer;out phRow:ULONG_PTR):HRESULT;stdcall;
  end;


// IRowsetUpdate :

 IRowsetUpdate = interface(IRowsetChange)
   ['{0C733A6D-2A1C-11CE-ADE5-00AA0044773D}']
    // GetOriginalData :
   procedure GetOriginalData(hRow:ULONG_PTR;hAccessor:ULONG_PTR;out pData:pointer);safecall;
    // GetPendingRows :
   procedure GetPendingRows(hReserved:ULONG_PTR;dwRowStatus:LongWord;var pcPendingRows:LongWord;out prgPendingRows:PULONG_PTR;out prgPendingStatus:PLongWord);safecall;
    // GetRowStatus :
   procedure GetRowStatus(hReserved:ULONG_PTR;cRows:LongWord;var rghRows:ULONG_PTR;out rgPendingStatus:LongWord);safecall;
    // Undo :
   procedure Undo(hReserved:ULONG_PTR;cRows:LongWord;var rghRows:ULONG_PTR;var pcRowsUndone:LongWord;out prgRowsUndone:PULONG_PTR;out prgRowStatus:PLongWord);safecall;
    // Update :
   procedure Update(hReserved:ULONG_PTR;cRows:LongWord;var rghRows:ULONG_PTR;var pcRows:LongWord;out prgRows:PULONG_PTR;out prgRowStatus:PLongWord);safecall;
  end;


// IRowsetIdentity :

 IRowsetIdentity = interface(IUnknown)
   ['{0C733A09-2A1C-11CE-ADE5-00AA0044773D}']
    // IsSameRow :
   function IsSameRow(hThisRow:ULONG_PTR;hThatRow:ULONG_PTR):HRESULT;stdcall;
  end;


// IRowsetNotify :

 IRowsetNotify = interface(IUnknown)
   ['{0C733A83-2A1C-11CE-ADE5-00AA0044773D}']
    // OnFieldChange :
   function OnFieldChange(pRowset:IRowset;hRow:ULONG_PTR;cColumns:LongWord;var rgColumns:LongWord;eReason:LongWord;ePhase:LongWord;fCantDeny:Integer):HRESULT;stdcall;
    // OnRowChange :
   function OnRowChange(pRowset:IRowset;cRows:LongWord;var rghRows:ULONG_PTR;eReason:LongWord;ePhase:LongWord;fCantDeny:Integer):HRESULT;stdcall;
    // OnRowsetChange :
   function OnRowsetChange(pRowset:IRowset;eReason:LongWord;ePhase:LongWord;fCantDeny:Integer):HRESULT;stdcall;
  end;


// IRowsetIndex :

 IRowsetIndex = interface(IUnknown)
   ['{0C733A82-2A1C-11CE-ADE5-00AA0044773D}']
    // GetIndexInfo :
   function GetIndexInfo(var pcKeyColumns:LongWord;out prgIndexColumnDesc:PDBINDEXCOLUMNDESC;var pcIndexPropertySets:LongWord;out prgIndexPropertySets:PDBPROPSET):HRESULT;stdcall;
    // Seek :
   function Seek(hAccessor:ULONG_PTR;cKeyValues:LongWord;var pData:pointer;dwSeekOptions:LongWord):HRESULT;stdcall;
    // SetRange :
   function SetRange(hAccessor:ULONG_PTR;cStartKeyColumns:LongWord;var pStartData:pointer;cEndKeyColumns:LongWord;var pEndData:pointer;dwRangeOptions:LongWord):HRESULT;stdcall;
  end;

*)
// ICommand :

  ICommand = interface(IUnknown)
    ['{0C733A63-2A1C-11CE-ADE5-00AA0044773D}']
     // Cancel :
    function Cancel: HRESULT; stdcall;
     // Execute :
    function Execute(const pUnkOuter: IUnknown; const riid: TGUID;
      var pParams: TDBPARAMS; pcRowsAffected: PDBROWCOUNT; ppRowset: PIUnknown):HRESULT;stdcall;  {note MSDN and OleDB.h are different for ppRowset}
    // GetDBSession :
   function GetDBSession(var riid: TGUID; out ppSession:IUnknown):HRESULT;stdcall;
  end;


// IMultipleResults :

 IMultipleResults = interface(IUnknown)
   ['{0C733A90-2A1C-11CE-ADE5-00AA0044773D}']
    // GetResult :
   function GetResult(pUnkOuter:IUnknown;lResultFlag:DBRESULTFLAG;const riid: TGUID;
    pcRowsAffected: PDBROWCOUNT; ppRowset: PIUnknown):HRESULT;stdcall;
  end;
(*

// IConvertType :

 IConvertType = interface(IUnknown)
   ['{0C733A88-2A1C-11CE-ADE5-00AA0044773D}']
    // CanConvert :
   function CanConvert(wFromType:Word;wToType:Word;dwConvertFlags:LongWord):HRESULT;stdcall;
  end;
*)

// ICommandPrepare :

 ICommandPrepare = interface(IUnknown)
   ['{0C733A26-2A1C-11CE-ADE5-00AA0044773D}']
    // Prepare :
   function Prepare(cExpectedRuns: ULONG): HRESULT; stdcall;
    // Unprepare :
   function Unprepare: HRESULT; stdcall;
  end;


// ICommandProperties :

  ICommandProperties = interface(IUnknown)
    ['{0C733A79-2A1C-11CE-ADE5-00AA0044773D}']
    // GetProperties :
    function GetProperties(cPropertyIDSets: ULONG; const rgPropertyIDSets: PDBPropIDSetArray;
      var pcPropertySets:ULONG;out prgPropertySets:PDBPROPSET):HRESULT;stdcall;
    // SetProperties :
    function SetProperties(cPropertySets:ULONG;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
  end;

// ICommandText :

  ICommandText = interface(ICommand)
    ['{0C733A27-2A1C-11CE-ADE5-00AA0044773D}']
    // GetCommandText :
    function GetCommandText(var pguidDialect: TGUID;out ppwszCommand: PWideChar): HRESULT;safecall;
    // SetCommandText :
    function SetCommandText(const rguidDialect: TGUID; pwszCommand: PWideChar): HRESULT;safecall;
  end;


// ICommandWithParameters :

  ICommandWithParameters = interface(IUnknown)
    ['{0C733A64-2A1C-11CE-ADE5-00AA0044773D}']
    // GetParameterInfo :
    function GetParameterInfo(var pcParams: DB_UPARAMS; out prgParamInfo: PDBPARAMINFO;
      out ppNamesBuffer: PPOleStr):HRESULT;stdcall;
    // MapParameterNames :
    function MapParameterNames(cParamNames: DB_UPARAMS; rgParamNames: POleStrList;
      out rgParamOrdinals: PDB_LPARAMS_Array):HRESULT;stdcall;
     // SetParameterInfo :
    function SetParameterInfo(cParams: DB_UPARAMS; rgParamOrdinals: PDB_UPARAMS_Array;
      rgParamBindInfo: PDBParamBindInfoArray):HRESULT;stdcall;
  end;

(*
// IColumnsRowset :

 IColumnsRowset = interface(IUnknown)
   ['{0C733A10-2A1C-11CE-ADE5-00AA0044773D}']
    // GetAvailableColumns :
   function GetAvailableColumns(var pcOptColumns:LongWord;out prgOptColumns:PDBID):HRESULT;stdcall;
    // GetColumnsRowset :
   function GetColumnsRowset(pUnkOuter:IUnknown;cOptColumns:LongWord;var rgOptColumns:TDBID;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppColRowset:IUnknown):HRESULT;stdcall;
  end;

*)
// IColumnsInfo :

 IColumnsInfo = interface(IUnknown)
   ['{0C733A11-2A1C-11CE-ADE5-00AA0044773D}']
    // GetColumnInfo :
   function GetColumnInfo(var pcColumns:  DBORDINAL; out prgInfo: PDBCOLUMNINFO;
    out ppStringsBuffer: PWideChar): HRESULT; stdcall;
    // MapColumnIDs :
   function MapColumnIDs(const cColumnIDs: DBORDINAL; const rgColumnIDs: PDBIDArray;
    {out} rgColumns: PDBORDINAL_Array): HRESULT; stdcall;
  end;


// IDBCreateCommand :

 IDBCreateCommand = interface(IUnknown)
   ['{0C733A1D-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateCommand :
   function CreateCommand(pUnkOuter:IUnknown;const riid:TGUID;out ppCommand:IUnknown):HRESULT;stdcall;
  end;


// IDBCreateSession :

 IDBCreateSession = interface(IUnknown)
   ['{0C733A5D-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateSession :
   function CreateSession(const pUnkOuter:IUnknown;const riid:TGUID;
    out ppDBSession:IUnknown):HRESULT;stdcall;
  end;
(*

// ISourcesRowset :

 ISourcesRowset = interface(IUnknown)
   ['{0C733A1E-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSourcesRowset :
   function GetSourcesRowset(pUnkOuter:IUnknown;var riid:GUID;cPropertySets:LongWord;var rgProperties:TDBPROPSET;out ppSourcesRowset:IUnknown):HRESULT;stdcall;
  end;


// IDBProperties :

 IDBProperties = interface(IUnknown)
   ['{0C733A8A-2A1C-11CE-ADE5-00AA0044773D}']
    // GetProperties :
   function GetProperties(cPropertyIDSets:LongWord;rgPropertyIDSets:PDBPropIDSetArray;var pcPropertySets:LongWord;out prgPropertySets:PDBPROPSET):HRESULT;stdcall;
    // GetPropertyInfo :
   function GetPropertyInfo(cPropertyIDSets:LongWord;rgPropertyIDSets:PDBPropIDSetArray;var pcPropertyInfoSets:LongWord;out prgPropertyInfoSets:PDBPROPINFOSET;out ppDescBuffer:PWord):HRESULT;stdcall;
    // SetProperties :
   function SetProperties(cPropertySets:LongWord;rgPropertySets:PDBPropSetArray):HRESULT;stdcall;
  end;

*)
// IDBInitialize :

  // initialize and uninitialize OleDB data source objects and enumerators
  IDBInitialize = interface(IUnknown)
    ['{0C733A8B-2A1C-11CE-ADE5-00AA0044773D}']
    // Initialize :
    function Initialize:HRESULT;stdcall;
    // Uninitialize :
    function Uninitialize:HRESULT;stdcall;
  end;
(*

// IDBInfo :

 IDBInfo = interface(IUnknown)
   ['{0C733A89-2A1C-11CE-ADE5-00AA0044773D}']
    // GetKeywords :
   function GetKeywords(out ppwszKeywords:PWideChar):HRESULT;stdcall;
    // GetLiteralInfo :
   function GetLiteralInfo(cLiterals:LongWord;var rgLiterals:LongWord;var pcLiteralInfo:LongWord;out prgLiteralInfo:PDBLITERALINFO;out ppCharBuffer:PWord):HRESULT;stdcall;
  end;


// IDBDataSourceAdmin :

 IDBDataSourceAdmin = interface(IUnknown)
   ['{0C733A7A-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateDataSource :
   function CreateDataSource(cPropertySets:LongWord;rgPropertySets:PDBPropSetArray;pUnkOuter:IUnknown;var riid:GUID;out ppDBSession:IUnknown):HRESULT;stdcall;
    // DestroyDataSource :
   function DestroyDataSource:HRESULT;stdcall;
    // GetCreationProperties :
   function GetCreationProperties(cPropertyIDSets:LongWord;rgPropertyIDSets:PDBPropIDSetArray;out pcPropertyInfoSets:LongWord;out prgPropertyInfoSets:PDBPROPINFOSET;out ppDescBuffer:PWord):HRESULT;stdcall;
    // ModifyDataSource :
   function ModifyDataSource(cPropertySets:LongWord;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
  end;


// IDBAsynchNotify :

 IDBAsynchNotify = interface(IUnknown)
   ['{0C733A96-2A1C-11CE-ADE5-00AA0044773D}']
    // OnLowResource :
   function OnLowResource(dwReserved:LongWord):HRESULT;stdcall;
    // OnProgress :
   function OnProgress(hChapter:ULONG_PTR;eOperation:LongWord;ulProgress:LongWord;ulProgressMax:LongWord;eAsynchPhase:LongWord;pwszStatusText:PWideChar):HRESULT;stdcall;
    // OnStop :
   function OnStop(hChapter:ULONG_PTR;eOperation:LongWord;hrStatus:HResult;pwszStatusText:PWideChar):HRESULT;stdcall;
  end;


// IDBAsynchStatus :

 IDBAsynchStatus = interface(IUnknown)
   ['{0C733A95-2A1C-11CE-ADE5-00AA0044773D}']
    // Abort :
   function Abort(hChapter:ULONG_PTR;eOperation:LongWord):HRESULT;stdcall;
    // GetStatus :
   function GetStatus(hChapter:ULONG_PTR;eOperation:LongWord;out pulProgress:LongWord;out pulProgressMax:LongWord;out peAsynchPhase:LongWord;out ppwszStatusText:PWideChar):HRESULT;stdcall;
  end;


// ISessionProperties :

 ISessionProperties = interface(IUnknown)
   ['{0C733A85-2A1C-11CE-ADE5-00AA0044773D}']
    // GetProperties :
   function GetProperties(cPropertyIDSets:LongWord;rgPropertyIDSets:PDBPropIDSetArray;var pcPropertySets:LongWord;out prgPropertySets:PDBPROPSET):HRESULT;stdcall;
    // SetProperties :
   function SetProperties(cPropertySets:LongWord;rgPropertySets:PDBPropSetArray):HRESULT;stdcall;
  end;


// IIndexDefinition :

 IIndexDefinition = interface(IUnknown)
   ['{0C733A68-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateIndex :
   function CreateIndex(var pTableID:TDBID;var pIndexID:TDBID;cIndexColumnDescs:LongWord;var rgIndexColumnDescs:DBINDEXCOLUMNDESC;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppIndexID:PDBID):HRESULT;stdcall;
    // DropIndex :
   function DropIndex(var pTableID:TDBID;var pIndexID:TDBID):HRESULT;stdcall;
  end;


// ITableDefinition :

 ITableDefinition = interface(IUnknown)
   ['{0C733A86-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateTable :
   function CreateTable(pUnkOuter:IUnknown;var pTableID:TDBID;cColumnDescs:LongWord;var rgColumnDescs:DBCOLUMNDESC;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppTableID:PDBID;out ppRowset:IUnknown):HRESULT;stdcall;
    // DropTable :
   function DropTable(var pTableID:TDBID):HRESULT;stdcall;
    // AddColumn :
   function AddColumn(var pTableID:TDBID;var pColumnDesc:DBCOLUMNDESC;out ppColumnID:PDBID):HRESULT;stdcall;
    // DropColumn :
   function DropColumn(var pTableID:TDBID;var pColumnID:TDBID):HRESULT;stdcall;
  end;


// IOpenRowset :

 IOpenRowset = interface(IUnknown)
   ['{0C733A69-2A1C-11CE-ADE5-00AA0044773D}']
    // OpenRowset :
   function OpenRowset(pUnkOuter:IUnknown;var pTableID:TDBID;var pIndexID:TDBID;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppRowset:IUnknown):HRESULT;stdcall;
  end;
*)

// IDBSchemaRowset :

  IDBSchemaRowset = interface(IUnknown)
    ['{0C733A7B-2A1C-11CE-ADE5-00AA0044773D}']
    // GetRowset :
    function GetRowset(pUnkOuter:IUnknown; const rguidSchema:TGUID;
     cRestrictions:ULONG; const rgRestrictions: Pointer;
     const riid:TGUID;cPropertySets:ULONG; rgPropertySets:PDBPropSetArray;
     out ppRowset:IUnknown):HRESULT;stdcall;
    // GetSchemas :
    function GetSchemas(var pcSchemas:ULONG;out prgSchemas:PGUID;
      out prgRestrictionSupport:PULONG_Array):HRESULT;stdcall;
  end;
(*

// IMDDataset :

 IMDDataset = interface(IUnknown)
   ['{A07CCCD1-8148-11D0-87BB-00C04FC33942}']
    // FreeAxisInfo :
   function FreeAxisInfo(cAxes:LongWord;var rgAxisInfo:MDAXISINFO):HRESULT;stdcall;
    // GetAxisInfo :
   function GetAxisInfo(var pcAxes:LongWord;out prgAxisInfo:PMDAXISINFO):HRESULT;stdcall;
    // GetAxisRowset :
   function GetAxisRowset(pUnkOuter:IUnknown;iAxis:LongWord;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppRowset:IUnknown):HRESULT;stdcall;
    // GetCellData :
   function GetCellData(hAccessor:ULONG_PTR;ulStartCell:LongWord;ulEndCell:LongWord;out pData:pointer):HRESULT;stdcall;
    // GetSpecification :
   function GetSpecification(var riid:GUID;out ppSpecification:IUnknown):HRESULT;stdcall;
  end;


// IMDFind :

 IMDFind = interface(IUnknown)
   ['{A07CCCD2-8148-11D0-87BB-00C04FC33942}']
    // FindCell :
   function FindCell(ulStartingOrdinal:LongWord;cMembers:LongWord;var rgpwszMember:PWideChar;out pulCellOrdinal:LongWord):HRESULT;stdcall;
    // FindTuple :
   function FindTuple(ulAxisIdentifier:LongWord;ulStartingOrdinal:LongWord;cMembers:LongWord;var rgpwszMember:PWideChar;out pulTupleOrdinal:LongWord):HRESULT;stdcall;
  end;


// IMDRangeRowset :

 IMDRangeRowset = interface(IUnknown)
   ['{0C733AA0-2A1C-11CE-ADE5-00AA0044773D}']
    // GetRangeRowset :
   function GetRangeRowset(pUnkOuter:IUnknown;ulStartCell:LongWord;ulEndCell:LongWord;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppRowset:IUnknown):HRESULT;stdcall;
  end;


// IAlterTable :

 IAlterTable = interface(IUnknown)
   ['{0C733AA5-2A1C-11CE-ADE5-00AA0044773D}']
    // AlterColumn :
   function AlterColumn(var pTableID:TDBID;var pColumnID:TDBID;dwColumnDescFlags:LongWord;var pColumnDesc:DBCOLUMNDESC):HRESULT;stdcall;
    // AlterTable :
   function AlterTable(var pTableID:TDBID;var pNewTableId:TDBID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
  end;


// IAlterIndex :

 IAlterIndex = interface(IUnknown)
   ['{0C733AA6-2A1C-11CE-ADE5-00AA0044773D}']
    // AlterIndex :
   function AlterIndex(var pTableID:TDBID;var pIndexID:TDBID;var pNewIndexId:TDBID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
  end;


// IRowsetChapterMember :

 IRowsetChapterMember = interface(IUnknown)
   ['{0C733AA8-2A1C-11CE-ADE5-00AA0044773D}']
    // IsRowInChapter :
   function IsRowInChapter(hChapter:ULONG_PTR;hRow:ULONG_PTR):HRESULT;stdcall;
  end;


// ICommandPersist :

 ICommandPersist = interface(IUnknown)
   ['{0C733AA7-2A1C-11CE-ADE5-00AA0044773D}']
    // DeleteCommand :
   function DeleteCommand(var pCommandID:TDBID):HRESULT;stdcall;
    // GetCurrentCommand :
   function GetCurrentCommand(out ppCommandID:PDBID):HRESULT;stdcall;
    // LoadCommand :
   function LoadCommand(var pCommandID:TDBID;dwFlags:LongWord):HRESULT;stdcall;
    // SaveCommand :
   function SaveCommand(var pCommandID:TDBID;dwFlags:LongWord):HRESULT;stdcall;
  end;


// IRowsetRefresh :

 IRowsetRefresh = interface(IUnknown)
   ['{0C733AA9-2A1C-11CE-ADE5-00AA0044773D}']
    // RefreshVisibleData :
   function RefreshVisibleData(hChapter:ULONG_PTR;cRows:LongWord;var rghRows:ULONG_PTR;fOverWrite:Integer;out pcRowsRefreshed:LongWord;out prghRowsRefreshed:PULONG_PTR;out prgRowStatus:PLongWord):HRESULT;stdcall;
    // GetLastVisibleData :
   function GetLastVisibleData(hRow:ULONG_PTR;hAccessor:ULONG_PTR;out pData:pointer):HRESULT;stdcall;
  end;


// IParentRowset :

 IParentRowset = interface(IUnknown)
   ['{0C733AAA-2A1C-11CE-ADE5-00AA0044773D}']
    // GetChildRowset :
   function GetChildRowset(pUnkOuter:IUnknown;iOrdinal:LongWord;var riid:GUID;out ppRowset:IUnknown):HRESULT;stdcall;
  end;

*)
// IErrorRecords :

  IErrorRecords = interface(IUnknown)
    ['{0C733A67-2A1C-11CE-ADE5-00AA0044773D}']
    // AddErrorRecord :
    function AddErrorRecord(pErrorInfo:PERRORINFO;dwLookupID:DWORD;
      const pDispParams:DISPPARAMS; punkCustomError:IUnknown;
      dwDynamicErrorID:DWORD):HRESULT;stdcall;
    // GetBasicErrorInfo :
    function GetBasicErrorInfo(ulRecordNum:ULONG;out pErrorInfo:PERRORINFO):HRESULT;stdcall;
    // GetCustomErrorObject :
    function GetCustomErrorObject(ulRecordNum:ULONG;var riid:TGUID;
      out ppObject:IUnknown):HRESULT;stdcall;
    // GetErrorInfo :
    function GetErrorInfo(ulRecordNum:ULONG;lcid:LCID;out ppErrorInfo:IErrorInfo):HRESULT;stdcall;
    // GetErrorParameters :
    function GetErrorParameters(ulRecordNum:ULONG;out pDispParams:DISPPARAMS):HRESULT;stdcall;
    // GetRecordCount :
    function GetRecordCount(out pcRecords:ULONG):HRESULT;stdcall;
  end;

(*
// IErrorInfo :

 IErrorInfo = interface(IUnknown)
   ['{1CF2B120-547D-101B-8E65-08002B2BD119}']
    // GetGUID :
   function GetGUID(out pguid:GUID):HRESULT;stdcall;
    // GetSource :
   function GetSource(out pBstrSource:WideString):HRESULT;stdcall;
    // GetDescription :
   function GetDescription(out pBstrDescription:WideString):HRESULT;stdcall;
    // GetHelpFile :
   function GetHelpFile(out pBstrHelpFile:WideString):HRESULT;stdcall;
    // GetHelpContext :
   function GetHelpContext(out pdwHelpContext:LongWord):HRESULT;stdcall;
  end;


// IErrorLookup :

 IErrorLookup = interface(IUnknown)
   ['{0C733A66-2A1C-11CE-ADE5-00AA0044773D}']
    // GetErrorDescription :
   function GetErrorDescription(hrError:HResult;dwLookupID:LongWord;var pDispParams:DISPPARAMS;lcid:LongWord;out pBstrSource:WideString;out pBstrDescription:WideString):HRESULT;stdcall;
    // GetHelpInfo :
   function GetHelpInfo(hrError:HResult;dwLookupID:LongWord;lcid:LongWord;out pBstrHelpFile:WideString;out pdwHelpContext:LongWord):HRESULT;stdcall;
    // ReleaseErrors :
   function ReleaseErrors(dwDynamicErrorID:LongWord):HRESULT;stdcall;
  end;


// ISQLErrorInfo :

 ISQLErrorInfo = interface(IUnknown)
   ['{0C733A74-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSQLInfo :
   function GetSQLInfo(out pbstrSQLState:WideString;out plNativeError:Integer):HRESULT;stdcall;
  end;


// IGetDataSource :

 IGetDataSource = interface(IUnknown)
   ['{0C733A75-2A1C-11CE-ADE5-00AA0044773D}']
    // GetDataSource :
   function GetDataSource(var riid:GUID;out ppDataSource:IUnknown):HRESULT;stdcall;
  end;

*)
// ITransaction :
  {MSSDK transact.h}
  ITransaction = interface(IUnknown)
    ['{0FB15084-AF41-11CE-BD2B-204C4F4F5020}']
    // Commit :
    function Commit(fRetaining:BOOL;grfTC:DWORD;grfRM:DWORD):HRESULT;stdcall;
    // Abort :
    function Abort(const pboidReason:PBOID;fRetaining:BOOL;fAsync:BOOL):HRESULT;stdcall;
    // GetTransactionInfo :
    function GetTransactionInfo(out pinfo: TXACTTRANSINFO):HRESULT;stdcall;
  end;

// ITransactionLocal :
  // optional interface on OleDB sessions, used to start, commit, and abort
  // transactions on the session
  ITransactionLocal = interface(ITransaction)
    ['{0C733A5F-2A1C-11CE-ADE5-00AA0044773D}']
    // GetOptionsObject :
    procedure GetOptionsObject(out ppOptions: ITransactionOptions);safecall;
    // StartTransaction :
    procedure StartTransaction(isoLevel:ISOLEVEL;isoFlags:ULONG;
      pOtherOptions:ITransactionOptions;out pulTransactionLevel: PULONG);safecall;
  end;

// ITransactionOptions :

 ITransactionOptions = interface(IUnknown)
   ['{3A6AD9E0-23B9-11CF-AD60-00AA00A74CCD}']
    // SetOptions :
   function SetOptions(var pOptions:TXACTOPT):HRESULT;stdcall;
    // GetOptions :
   function GetOptions(var pOptions:TXACTOPT):HRESULT;stdcall;
  end;

(*
// ITransactionJoin :

 ITransactionJoin = interface(IUnknown)
   ['{0C733A5E-2A1C-11CE-ADE5-00AA0044773D}']
    // GetOptionsObject :
   function GetOptionsObject(out ppOptions:ITransactionOptions):HRESULT;stdcall;
    // JoinTransaction :
   function JoinTransaction(punkTransactionCoord:IUnknown;isoLevel:Integer;isoFlags:LongWord;pOtherOptions:ITransactionOptions):HRESULT;stdcall;
  end;


// ITransactionObject :

 ITransactionObject = interface(IUnknown)
   ['{0C733A60-2A1C-11CE-ADE5-00AA0044773D}']
    // GetTransactionObject :
   function GetTransactionObject(ulTransactionLevel:LongWord;out ppTransactionObject:ITransaction):HRESULT;stdcall;
  end;


// ITrusteeAdmin :

 ITrusteeAdmin = interface(IUnknown)
   ['{0C733AA1-2A1C-11CE-ADE5-00AA0044773D}']
    // CompareTrustees :
   function CompareTrustees(var pTrustee1:_TRUSTEE_W;var pTrustee2:_TRUSTEE_W):HRESULT;stdcall;
    // CreateTrustee :
   function CreateTrustee(var pTrustee:_TRUSTEE_W;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
    // DeleteTrustee :
   function DeleteTrustee(var pTrustee:_TRUSTEE_W):HRESULT;stdcall;
    // SetTrusteeProperties :
   function SetTrusteeProperties(var pTrustee:_TRUSTEE_W;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET):HRESULT;stdcall;
    // GetTrusteeProperties :
   function GetTrusteeProperties(var pTrustee:_TRUSTEE_W;cPropertyIDSets:LongWord;rgPropertyIDSets:PDBPropIDSetArray;var pcPropertySets:LongWord;out prgPropertySets:PDBPROPSET):HRESULT;stdcall;
  end;


// ITrusteeGroupAdmin :

 ITrusteeGroupAdmin = interface(IUnknown)
   ['{0C733AA2-2A1C-11CE-ADE5-00AA0044773D}']
    // AddMember :
   function AddMember(var pMembershipTrustee:_TRUSTEE_W;var pMemberTrustee:_TRUSTEE_W):HRESULT;stdcall;
    // DeleteMember :
   function DeleteMember(var pMembershipTrustee:_TRUSTEE_W;var pMemberTrustee:_TRUSTEE_W):HRESULT;stdcall;
    // IsMember :
   function IsMember(var pMembershipTrustee:_TRUSTEE_W;var pMemberTrustee:_TRUSTEE_W;out pfStatus:Integer):HRESULT;stdcall;
    // GetMembers :
   function GetMembers(var pMembershipTrustee:_TRUSTEE_W;out pcMembers:LongWord;out prgMembers:P_TRUSTEE_W):HRESULT;stdcall;
    // GetMemberships :
   function GetMemberships(var pTrustee:_TRUSTEE_W;out pcMemberships:LongWord;out prgMemberships:P_TRUSTEE_W):HRESULT;stdcall;
  end;


// IObjectAccessControl :

 IObjectAccessControl = interface(IUnknown)
   ['{0C733AA3-2A1C-11CE-ADE5-00AA0044773D}']
    // GetObjectAccessRights :
   function GetObjectAccessRights(var pObject:_SEC_OBJECT;var pcAccessEntries:LongWord;var prgAccessEntries:P_EXPLICIT_ACCESS_W):HRESULT;stdcall;
    // GetObjectOwner :
   function GetObjectOwner(var pObject:_SEC_OBJECT;out ppOwner:P_TRUSTEE_W):HRESULT;stdcall;
    // IsObjectAccessAllowed :
   function IsObjectAccessAllowed(var pObject:_SEC_OBJECT;var pAccessEntry:_EXPLICIT_ACCESS_W;out pfResult:Integer):HRESULT;stdcall;
    // SetObjectAccessRights :
   function SetObjectAccessRights(var pObject:_SEC_OBJECT;cAccessEntries:LongWord;var prgAccessEntries:_EXPLICIT_ACCESS_W):HRESULT;stdcall;
    // SetObjectOwner :
   function SetObjectOwner(var pObject:_SEC_OBJECT;var pOwner:_TRUSTEE_W):HRESULT;stdcall;
  end;


// ISecurityInfo :

 ISecurityInfo = interface(IUnknown)
   ['{0C733AA4-2A1C-11CE-ADE5-00AA0044773D}']
    // GetCurrentTrustee :
   function GetCurrentTrustee(out ppTrustee:P_TRUSTEE_W):HRESULT;stdcall;
    // GetObjectTypes :
   function GetObjectTypes(out cObjectTypes:LongWord;out rgObjectTypes:PGUID):HRESULT;stdcall;
    // GetPermissions :
   function GetPermissions(ObjectType:TGUID;out pPermissions:LongWord):HRESULT;stdcall;
  end;


// ITableCreation :

 ITableCreation = interface(ITableDefinition)
   ['{0C733ABC-2A1C-11CE-ADE5-00AA0044773D}']
    // GetTableDefinition :
   procedure GetTableDefinition(var pTableID:TDBID;out pcColumnDescs:LongWord;out prgColumnDescs:PDBCOLUMNDESC;out pcPropertySets:LongWord;out prgPropertySets:PDBPROPSET;out pcConstraintDescs:LongWord;out prgConstraintDescs:PDBCONSTRAINTDESC;out ppwszStringBuffer:PWord);safecall;
  end;


// ITableDefinitionWithConstraints :

 ITableDefinitionWithConstraints = interface(ITableCreation)
   ['{0C733AAB-2A1C-11CE-ADE5-00AA0044773D}']
    // AddConstraint :
   procedure AddConstraint(var pTableID:TDBID;var pConstraintDesc:DBCONSTRAINTDESC);safecall;
    // CreateTableWithConstraints :
   procedure CreateTableWithConstraints(pUnkOuter:IUnknown;var pTableID:TDBID;cColumnDescs:LongWord;var rgColumnDescs:DBCOLUMNDESC;cConstraintDescs:LongWord;var rgConstraintDescs:DBCONSTRAINTDESC;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppTableID:PDBID;out ppRowset:IUnknown);safecall;
    // DropConstraint :
   procedure DropConstraint(var pTableID:TDBID;var pConstraintID:TDBID);safecall;
  end;


// IRow :

 IRow = interface(IUnknown)
   ['{0C733AB4-2A1C-11CE-ADE5-00AA0044773D}']
    // GetColumns :
   function GetColumns(cColumns:LongWord;var rgColumns:DBCOLUMNACCESS):HRESULT;stdcall;
    // GetSourceRowset :
   function GetSourceRowset(var riid:GUID;out ppRowset:IUnknown;out phRow:ULONG_PTR):HRESULT;stdcall;
    // Open :
   function Open(pUnkOuter:IUnknown;var pColumnID:TDBID;var rguidColumnType:GUID;dwBindFlags:LongWord;var riid:GUID;out ppUnk:IUnknown):HRESULT;stdcall;
  end;


// IRowChange :

 IRowChange = interface(IUnknown)
   ['{0C733AB5-2A1C-11CE-ADE5-00AA0044773D}']
    // SetColumns :
   function SetColumns(cColumns:LongWord;var rgColumns:DBCOLUMNACCESS):HRESULT;stdcall;
  end;


// IRowSchemaChange :

 IRowSchemaChange = interface(IRowChange)
   ['{0C733AAE-2A1C-11CE-ADE5-00AA0044773D}']
    // DeleteColumns :
   procedure DeleteColumns(cColumns:LongWord;var rgColumnIDs:TDBID;var rgdwStatus:LongWord);safecall;
    // AddColumns :
   procedure AddColumns(cColumns:LongWord;var rgNewColumnInfo:TDBCOLUMNINFO;var rgColumns:DBCOLUMNACCESS);safecall;
  end;


// IGetRow :

 IGetRow = interface(IUnknown)
   ['{0C733AAF-2A1C-11CE-ADE5-00AA0044773D}']
    // GetRowFromHROW :
   function GetRowFromHROW(pUnkOuter:IUnknown;hRow:ULONG_PTR;var riid:GUID;out ppUnk:IUnknown):HRESULT;stdcall;
    // GetURLFromHROW :
   function GetURLFromHROW(hRow:ULONG_PTR;out ppwszURL:PWideChar):HRESULT;stdcall;
  end;


// IBindResource :

 IBindResource = interface(IUnknown)
   ['{0C733AB1-2A1C-11CE-ADE5-00AA0044773D}']
    // Bind :
   function Bind(pUnkOuter:IUnknown;pwszURL:PWideChar;dwBindURLFlags:LongWord;var rguid:GUID;var riid:GUID;pAuthenticate:IAuthenticate;var pImplSession:DBIMPLICITSESSION;var pdwBindStatus:LongWord;out ppUnk:IUnknown):HRESULT;stdcall;
  end;


// IAuthenticate :

 IAuthenticate = interface(IUnknown)
   ['{79EAC9D0-BAF9-11CE-8C82-00AA004BA90B}']
    // Authenticate :
   function Authenticate(out phwnd:wireHWND;out pszUsername:PWideChar;out pszPassword:PWideChar):HRESULT;stdcall;
  end;


// IScopedOperations :

 IScopedOperations = interface(IBindResource)
   ['{0C733AB0-2A1C-11CE-ADE5-00AA0044773D}']
    // Copy :
   procedure Copy(cRows:LongWord;var rgpwszSourceURLs:PWideChar;var rgpwszDestURLs:PWideChar;dwCopyFlags:LongWord;pAuthenticate:IAuthenticate;var rgdwStatus:LongWord;out rgpwszNewURLs:PWideChar;out ppStringsBuffer:PWord);safecall;
    // Move :
   procedure Move(cRows:LongWord;var rgpwszSourceURLs:PWideChar;var rgpwszDestURLs:PWideChar;dwMoveFlags:LongWord;pAuthenticate:IAuthenticate;var rgdwStatus:LongWord;out rgpwszNewURLs:PWideChar;out ppStringsBuffer:PWord);safecall;
    // Delete :
   procedure Delete(cRows:LongWord;var rgpwszURLs:PWideChar;dwDeleteFlags:LongWord;var rgdwStatus:LongWord);safecall;
    // OpenRowset :
   procedure OpenRowset(pUnkOuter:IUnknown;var pTableID:TDBID;var pIndexID:TDBID;var riid:GUID;cPropertySets:LongWord;var rgPropertySets:TDBPROPSET;out ppRowset:IUnknown);safecall;
  end;


// ICreateRow :

 ICreateRow = interface(IUnknown)
   ['{0C733AB2-2A1C-11CE-ADE5-00AA0044773D}']
    // CreateRow :
   function CreateRow(pUnkOuter:IUnknown;pwszURL:PWideChar;dwBindURLFlags:LongWord;var rguid:GUID;var riid:GUID;pAuthenticate:IAuthenticate;var pImplSession:DBIMPLICITSESSION;var pdwBindStatus:LongWord;out ppwszNewURL:PWideChar;out ppUnk:IUnknown):HRESULT;stdcall;
  end;


// IDBBinderProperties :

 IDBBinderProperties = interface(IDBProperties)
   ['{0C733AB3-2A1C-11CE-ADE5-00AA0044773D}']
    // Reset_ :
   procedure Reset_;safecall;
  end;


// IColumnsInfo2 :

 IColumnsInfo2 = interface(IColumnsInfo)
   ['{0C733AB8-2A1C-11CE-ADE5-00AA0044773D}']
    // GetRestrictedColumnInfo :
   procedure GetRestrictedColumnInfo(cColumnIDMasks:LongWord;var rgColumnIDMasks:TDBID;dwFlags:LongWord;var pcColumns:LongWord;out prgColumnIDs:PDBID;out prgColumnInfo:PDBCOLUMNINFO;out ppStringsBuffer:PWord);safecall;
  end;


// IRegisterProvider :

 IRegisterProvider = interface(IUnknown)
   ['{0C733AB9-2A1C-11CE-ADE5-00AA0044773D}']
    // GetURLMapping :
   function GetURLMapping(pwszURL:PWideChar;dwReserved:LongWord;out pclsidProvider:GUID):HRESULT;stdcall;
    // SetURLMapping :
   function SetURLMapping(pwszURL:PWideChar;dwReserved:LongWord;var rclsidProvider:GUID):HRESULT;stdcall;
    // UnregisterProvider :
   function UnregisterProvider(pwszURL:PWideChar;dwReserved:LongWord;var rclsidProvider:GUID):HRESULT;stdcall;
  end;


// IGetSession :

 IGetSession = interface(IUnknown)
   ['{0C733ABA-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSession :
   function GetSession(var riid:GUID;out ppSession:IUnknown):HRESULT;stdcall;
  end;


// IGetSourceRow :

 IGetSourceRow = interface(IUnknown)
   ['{0C733ABB-2A1C-11CE-ADE5-00AA0044773D}']
    // GetSourceRow :
   function GetSourceRow(var riid:GUID;out ppRow:IUnknown):HRESULT;stdcall;
  end;


// IRowsetCurrentIndex :

 IRowsetCurrentIndex = interface(IRowsetIndex)
   ['{0C733ABD-2A1C-11CE-ADE5-00AA0044773D}']
    // GetIndex :
   procedure GetIndex(out ppIndexID:PDBID);safecall;
    // SetIndex :
   procedure SetIndex(var pIndexID:TDBID);safecall;
  end;


// ICommandStream :

 ICommandStream = interface(IUnknown)
   ['{0C733ABF-2A1C-11CE-ADE5-00AA0044773D}']
    // GetCommandStream :
   function GetCommandStream(out piid:GUID;var pguidDialect:GUID;out ppCommandStream:IUnknown):HRESULT;stdcall;
    // SetCommandStream :
   function SetCommandStream(var riid:GUID;var rguidDialect:GUID;pCommandStream:IUnknown):HRESULT;stdcall;
  end;


// IRowsetBookmark :

 IRowsetBookmark = interface(IUnknown)
   ['{0C733AC2-2A1C-11CE-ADE5-00AA0044773D}']
    // PositionOnBookmark :
   function PositionOnBookmark(hChapter:ULONG_PTR;cbBookmark:LongWord;var pBookmark:Byte):HRESULT;stdcall;
  end;
*)
//start add from msdasc.h
  // create an OleDB data source object using a connection string
  IDataInitialize = interface(IUnknown)
    ['{2206CCB1-19C1-11D1-89E0-00C04FD7A829}']
    function GetDataSource(const pUnkOuter:IUnknown; dwClsCtx:DWORD;
      pwszInitializationString:POleStr; const riid: TIID;
      var DataSource: IUnknown): HResult; stdcall;
    function GetInitializationString(const DataSource: IUnknown;
      fIncludePassword: Boolean; out pwszInitString: POleStr): HResult; stdcall;
    function CreateDBInstance(const clsidProvider: TGUID;
      const pUnkOuter: IUnknown; dwClsCtx: DWORD; pwszReserved: POleStr;
        const riid: TIID; out DataSource: IUnknown): HResult; stdcall;
    function CreateDBInstanceEx(const clsidProvider: TGUID;
      const pUnkOuter: IUnknown; dwClsCtx:DWORD; pwszReserved: POleStr;
      pServerInfo: PCoServerInfo; cmq: ULONG; rgmqResults: PMultiQI): HResult; stdcall;
    function LoadStringFromStorage(pwszFileName: POleStr;
      out pwszInitializationString: POleStr):HResult; stdcall;
    function WriteStringToStorage(pwszFileName,pwszInitializationString:POleStr;
      dwCreationDisposition: DWORD):HResult; stdcall;
  end;

  DBSOURCETYPE = DWORD; //oledb.h
  PDBSOURCETYPE = ^DBSOURCETYPE;

  IDBPromptInitialize = interface(IUnknown)
    ['{2206CCB0-19C1-11D1-89E0-00C04FD7A829}']
    function PromptDataSource(const pUnkOuter:IUnknown;hWndParent:HWND;
      dwPromptOptions:DBPROMPTOPTIONS;cSourceTypeFilter:ULONG;
      rgSourceTypeFilter:PDBSOURCETYPE;pszProviderFilter:POleStr;
      const riid: TIID; var DataSource: IUnknown): HResult; stdcall;
    function PromptFileName(hWndParent:HWND;dwPromptOptions:DBPROMPTOPTIONS;
      pwszInitialDirectory,pwszInitialFile:POleStr;
      var ppwszSelectedFile:POleStr): HResult; stdcall;
  end;
//end add from msdasc.h

//CoClasses

{.$ENDIF ENABLE_ADO}
implementation

end.

