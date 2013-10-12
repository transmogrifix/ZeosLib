{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{        Dataset utility functions and classes            }
{                                                         }
{        Originally written by Sergey Seroukhov           }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2012 Zeos Development Group       }
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

unit ZDatasetUtils;

interface

{$I ZComponent.inc}

uses
  Types, Classes, SysUtils, {$IFDEF MSEgui}mclasses, mdb{$ELSE}Db{$ENDIF},
  Contnrs, {$IFDEF WITH_UNITANSISTRINGS}AnsiStrings, {$ENDIF}
  ZDbcIntfs, ZDbcCache, ZCompatibility, ZExpression, ZVariant, ZTokenizer;

{**
  Converts DBC Field Type to TDataset Field Type.
  @param Value an initial DBC field type.
  @return a converted TDataset field type.
}
function ConvertDbcToDatasetType(Value: TZSQLType): TFieldType;

{**
  Converts TDataset Field Type to DBC Field Type.
  @param Value an initial TDataset field type.
  @return a converted DBC field type.
}
function ConvertDatasetToDbcType(Value: TFieldType): TZSQLType;

{**
  Converts field definitions into column information objects.
  @param Fields a collection of field definitions.
  @return a collection of column information objects.
}
function ConvertFieldsToColumnInfo(Fields: TFields): TObjectList;

{**
  Fetches columns from specified resultset.
  @param ResultSet a source resultset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Fields a collection of field definitions.
  @param RowAccessor a destination row accessor.
}
procedure FetchFromResultSet(ResultSet: IZResultSet;
  const FieldsLookupTable: TIntegerDynArray; Fields: TFields;
  RowAccessor: TZRowAccessor);

{**
  Posts columns from specified resultset.
  @param ResultSet a source resultset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Fields a collection of field definitions.
  @param RowAccessor a destination row accessor.
}
procedure PostToResultSet(ResultSet: IZResultSet;
  const FieldsLookupTable: TIntegerDynArray; Fields: TFields;
  RowAccessor: TZRowAccessor);

{**
  Defines fields indices for the specified dataset.
  @param DataSet a dataset object.
  @param FieldNames a list of field names.
  @param OnlyDataFields <code>True</code> if only data fields selected.
}
function DefineFields(DataSet: TDataset; const FieldNames: string;
  var OnlyDataFields: Boolean): TObjectDynArray;

{**
  Defins a indices of filter fields.
  @param Dataset a dataset object.
  @param Expression a expression calculator.
  @returns an array with field object references.
}
function DefineFilterFields(DataSet: TDataset;
  Expression: IZExpression): TObjectDynArray;

{**
  Retrieves a set of specified field values.
  @param FieldRefs an array with interested field object references.
  @param ResultSet an initial result set object.
  @param ResultValues a container for result values.
  @return an array with field values.
}
procedure RetrieveDataFieldsFromResultSet(const FieldRefs: TObjectDynArray;
  ResultSet: IZResultSet; var ResultValues: TZVariantDynArray);

{**
  Retrieves a set of specified field values.
  @param FieldRefs an array with interested field object references.
  @param FieldIndices an array with interested field indices.
  @param RowAccessor a row accessor object.
  @param ResultValues a container for result values.
  @return an array with field values.
}
procedure RetrieveDataFieldsFromRowAccessor(const FieldRefs: TObjectDynArray;
  const FieldIndices: TIntegerDynArray; RowAccessor: TZRowAccessor;
  var ResultValues: TZVariantDynArray);

{**
  Copy a set of specified field values to variables.
  @param Fields an array with interested field object references.
  @param ResultSet an initial result set object.
  @param Variables a list of variables.
}
procedure CopyDataFieldsToVars(const Fields: TObjectDynArray;
  ResultSet: IZResultSet; Variables: IZVariablesList);

{**
  Prepares values for comparison by CompareFieldsFromResultSet.
  @param FieldRefs an array with interested field object references.
  @param DecodedKeyValues given values.
  @param ResultSet  a resultset to get field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
}
procedure PrepareValuesForComparison(const FieldRefs: TObjectDynArray;
  var DecodedKeyValues: TZVariantDynArray; ResultSet: IZResultSet;
  PartialKey: Boolean; CaseInsensitive: Boolean);

{**
  Compares row field values with the given ones.
  @param KeyValues given values.
  @param RowValues row field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
  @return <code> if values are equal.
}
function CompareDataFields(const KeyValues, RowValues: TZVariantDynArray;
  PartialKey: Boolean; CaseInsensitive: Boolean): Boolean;

{**
  Compares row field values with the given ones.
  @param FieldRefs an array with interested field object references.
  @param KeyValues given values.
  @param RowValues row field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
  @return <code> if values are equal.
}
function CompareFieldsFromResultSet(const FieldRefs: TObjectDynArray;
  const KeyValues: TZVariantDynArray; ResultSet: IZResultSet; PartialKey: Boolean;
  CaseInsensitive: Boolean): Boolean;

{**
  Defines a list of key field names.
  @param Fields a collection of dataset fields.
  @return a list of key field names.
}
function DefineKeyFields(Fields: TFields): string;

{**
  Converts datetime value into TDataset internal presentation.
  @param DataType a type of date-time field.
  @param Data a data which contains a value.
  @param Buffer a field buffer pointer
}
procedure DateTimeToNative(DataType: TFieldType; Data: TDateTime; Buffer: Pointer);

{**
  Converts date times from TDataset internal presentation into datetime value.
  @param DataType a type of date-time field.
  @param Buffer a field buffer pointer
  @return a data which contains a value.
}
function NativeToDateTime(DataType: TFieldType; Buffer: Pointer): TDateTime;

{**
  Compare values from two key fields.
  @param Field1 the first field object.
  @param ResultSet the resultset to read the first field value.
  @param Field2 the second field object.
}
function CompareKeyFields(Field1: TField; ResultSet: IZResultSet;
  Field2: TField): Boolean;

{**
  Defins a indices and directions for sorted fields.
  @param Dataset a dataset object.
  @param SortedFields an encoded fields for sorting in the format
    <Field Name> [ASC | DESC] [, ...]
  @param FieldRefs a decoded field object references.
  @param FieldDirs a decoded field directions.
  @param OnlyDataFields <code>True</code> if only data fields selected.
}
procedure DefineSortedFields(DataSet: TDataset;
  const SortedFields: string; var FieldRefs: TObjectDynArray;
  var FieldDirs: TBooleanDynArray; var OnlyDataFields: Boolean);

{**
  Creates a fields lookup table to define fixed position
  of the field in dataset.
  @param Fields a collection of TDataset fields in initial order.
  @returns a fields lookup table.
}
function CreateFieldsLookupTable(Fields: TFields): TIntegerDynArray;

{**
  Defines an original field index in the dataset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Field a TDataset field object.
  @returns an original fields index or -1 otherwise.
}
function DefineFieldIndex(const FieldsLookupTable: TIntegerDynArray;
  Field: TField): Integer;

{**
  Defines an original field indices in the dataset.
  @param FieldsLookupTable a lookup table to define original index.
  @param FieldRefs a TDataset field object references.
  @returns an array with original fields indices.
}
function DefineFieldIndices(const FieldsLookupTable: TIntegerDynArray;
  const FieldRefs: TObjectDynArray): TIntegerDynArray;

{**
  Splits up a qualified object name into pieces. Catalog, schema
  and objectname.
}
procedure SplitQualifiedObjectName(QualifiedName: string;
  var Catalog, Schema, ObjectName: string); overload;

{**
  Splits up a qualified object name into pieces. Catalog, schema
  and objectname.
}
procedure SplitQualifiedObjectName(QualifiedName: string;
  const SupportsCatalogs, SupportsSchemas: Boolean;
  var Catalog, Schema, ObjectName: string); overload;

{**
  Assigns a Statement value from a TParam
  @param Index the index of Statement.SetParam(Idex..);
  @param Statement the PrepredStatement where the values have been assigned
  @param Param the TParam where the value is assigned from
}
procedure SetStatementParam(Index: Integer;
  Statement: IZPreparedStatement; Param: TParam);

{** Common variables. }
var
  CommonTokenizer: IZTokenizer;

implementation

uses
  ZFastCode, ZMessages, ZGenericSqlToken, ZDbcResultSetMetadata, ZAbstractRODataset,
  ZDbcUtils, ZSysUtils {$IFDEF WITH_INLINE_ANSISTRLCOMP}, Windows{$ENDIF};

{**
  Converts DBC Field Type to TDataset Field Type.
  @param Value an initial DBC field type.
  @return a converted TDataset field type.
}
function ConvertDbcToDatasetType(Value: TZSQLType): TFieldType;
begin
  case Value of
    stBoolean:
      Result := ftBoolean;
    stByte, stShort:
      Result := ftSmallInt;
    stInteger:
      Result := ftInteger;
    stLong:
      Result := ftLargeInt;
    stFloat, stDouble, stBigDecimal:
      Result := ftFloat;
    stString:
      Result := ftString;
    stBytes{$IFNDEF WITH_FTGUID}, stGUID{$ENDIF}:
      Result := ftBytes;
    {$IFDEF WITH_FTGUID}
    stGUID:
      Result := ftGUID;
    {$ENDIF}
    stDate:
      Result := ftDate;
    stTime:
      Result := ftTime;
    stTimestamp:
      Result := ftDateTime;
    stAsciiStream:
      Result := ftMemo;
    stBinaryStream:
      Result := ftBlob;
    stUnicodeString:
      Result := ftWideString;
    stUnicodeStream:
      Result := {$IFNDEF WITH_WIDEMEMO}ftWideString{$ELSE}ftWideMemo{$ENDIF};
    {$IFDEF WITH_FTDATASETSUPPORT}
    stDataSet:
      Result := ftDataSet;
    {$ENDIF}
    else
      Result := ftUnknown;
  end;
end;

{**
  Converts TDataset Field Type to DBC Field Type.
  @param Value an initial TDataset field type.
  @return a converted DBC field type.
}
function ConvertDatasetToDbcType(Value: TFieldType): TZSQLType;
begin
  case Value of
    ftBoolean:
      Result := stBoolean;
    ftSmallInt:
      Result := stShort;
    ftInteger, ftAutoInc:
      Result := stInteger;
    ftFloat:
      Result := stDouble;
    ftLargeInt:
      Result := stLong;
    ftCurrency:
      Result := stBigDecimal;
    ftString:
      Result := stString;
    ftBytes:
      Result := stBytes;
    ftDate:
      Result := stDate;
    ftTime:
      Result := stTime;
    ftDateTime:
      Result := stTimestamp;
    ftMemo:
      Result := stAsciiStream;
    ftBlob:
      Result := stBinaryStream;
    ftWideString:
      Result := stUnicodeString;
    {$IFDEF WITH_FTGUID}
    ftGuid:
      Result := stGUID;
    {$ENDIF}
    {$IFDEF WITH_WIDEMEMO}
    ftWideMemo:
      Result := stUnicodeStream;
    {$ENDIF}
    {$IFDEF WITH_FTDATASETSUPPORT}
    ftDataSet:
      Result := stDataSet;
    {$ENDIF}
    else
      Result := stUnknown;
  end;
end;

{**
  Converts field definitions into column information objects.
  @param Fields a collection of field definitions.
  @return a collection of column information objects.
}
function ConvertFieldsToColumnInfo(Fields: TFields): TObjectList;
var
  I: Integer;
  Current: TField;
  ColumnInfo: TZColumnInfo;
begin
  Result := TObjectList.Create(True);
  for I := 0 to Fields.Count - 1 do
  begin
    Current := Fields[I];
    ColumnInfo := TZColumnInfo.Create;

    ColumnInfo.ColumnType := ConvertDatasetToDbcType(Current.DataType);
    ColumnInfo.ColumnName := Current.FieldName;
    ColumnInfo.Precision := Current.Size;
//This is a hack for stUnicodeStream because there is only ftWideString for both type
    if ColumnInfo.ColumnType = stUnicodeString then
      if Current.Size > 10240 then
        ColumnInfo.ColumnType := stUnicodeStream;
    ColumnInfo.Scale := 0;
    ColumnInfo.ColumnLabel := Current.DisplayName;
    ColumnInfo.ColumnDisplaySize := Current.DisplayWidth;
    ColumnInfo.DefaultExpression := Current.DefaultExpression;

    Result.Add(ColumnInfo);
  end;
end;

{**
  Fetches columns from specified resultset.
  @param ResultSet a source resultset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Fields a collection of field definitions.
  @param RowAccessor a destination row accessor.
}
procedure FetchFromResultSet(ResultSet: IZResultSet;
  const FieldsLookupTable: TIntegerDynArray; Fields: TFields;
  RowAccessor: TZRowAccessor);
var
  I, FieldIndex: Integer;
  Current: TField;
  ColumnIndex, ColumnCount: Integer;
begin
  RowAccessor.RowBuffer.Index := ResultSet.GetRow;
  ColumnCount := ResultSet.GetMetadata.GetColumnCount;

  for I := 0 to Fields.Count - 1 do
  begin
    Current := Fields[I];
    if not (Current.FieldKind in [fkData, fkInternalCalc]) then
      Continue;

    ColumnIndex := Current.FieldNo;
    FieldIndex := DefineFieldIndex(FieldsLookupTable, Current);
    if (ColumnIndex < 1) or (ColumnIndex > ColumnCount) then
      Continue;

    case Current.DataType of
      ftBoolean:
        RowAccessor.SetBoolean(FieldIndex, ResultSet.GetBoolean(ColumnIndex));
      ftSmallInt:
        RowAccessor.SetShort(FieldIndex, ResultSet.GetShort(ColumnIndex));
      ftInteger, ftAutoInc:
        RowAccessor.SetInt(FieldIndex, ResultSet.GetInt(ColumnIndex));
      ftFloat:
        RowAccessor.SetDouble(FieldIndex, ResultSet.GetDouble(ColumnIndex));
      ftLargeInt:
        RowAccessor.SetLong(FieldIndex, ResultSet.GetLong(ColumnIndex));
      ftCurrency:
        RowAccessor.SetBigDecimal(FieldIndex, ResultSet.GetBigDecimal(ColumnIndex));
      ftString, ftWideString:
        if ResultSet.GetConSettings^.ClientCodePage^.IsStringFieldCPConsistent then
          RowAccessor.SetRawByteString(FieldIndex, ResultSet.GetRawByteString(ColumnIndex))
        else
          RowAccessor.SetUnicodeString(FieldIndex, ResultSet.GetUnicodeString(ColumnIndex));
      ftBytes{$IFDEF WITH_FTGUID}, ftGuid{$ENDIF}:
        RowAccessor.SetBytes(FieldIndex, ResultSet.GetBytes(ColumnIndex));
      ftDate:
        RowAccessor.SetDate(FieldIndex, ResultSet.GetDate(ColumnIndex));
      ftTime:
        RowAccessor.SetTime(FieldIndex, ResultSet.GetTime(ColumnIndex));
      ftDateTime:
        RowAccessor.SetTimestamp(FieldIndex, ResultSet.GetTimestamp(ColumnIndex));
      ftMemo, ftBlob {$IFDEF WITH_WIDEMEMO}, ftWideMemo{$ENDIF}:
        RowAccessor.SetBlob(FieldIndex, ResultSet.GetBlob(ColumnIndex));
      {$IFDEF WITH_FTDATASETSUPPORT}
      ftDataSet:
        RowAccessor.SetDataSet(FieldIndex, ResultSet.GetDataSet(ColumnIndex));
      {$ENDIF}
    end;

    if ResultSet.WasNull then
      RowAccessor.SetNull(FieldIndex);
  end;
end;

{**
  Posts columns from specified resultset.
  @param ResultSet a source resultset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Fields a collection of field definitions.
  @param RowAccessor a destination row accessor.
}
procedure PostToResultSet(ResultSet: IZResultSet;
  const FieldsLookupTable: TIntegerDynArray; Fields: TFields;
  RowAccessor: TZRowAccessor);
var
  I, FieldIndex: Integer;
  Current: TField;
  WasNull: Boolean;
  ColumnIndex, ColumnCount: Integer;
  Stream: TStream;
begin
  WasNull := False;
  RowAccessor.RowBuffer.Index := ResultSet.GetRow;
  ColumnCount := ResultSet.GetMetadata.GetColumnCount;

  for I := 0 to Fields.Count - 1 do
  begin
    Current := Fields[I];
    if Current.FieldKind <> fkData then
      Continue;

    ColumnIndex := Current.FieldNo;
    FieldIndex := DefineFieldIndex(FieldsLookupTable, Current);
    if (ColumnIndex < 1) or (ColumnIndex > ColumnCount) then
      Continue;

//    if (Current.Required = True) and (WasNull = True) then
//      raise EZDatabaseError.Create(Format(SFieldCanNotBeNull, [Current.FieldName]));
    case Current.DataType of
      ftBoolean:
        ResultSet.UpdateBoolean(ColumnIndex, RowAccessor.GetBoolean(FieldIndex, WasNull));
      ftSmallInt:
        ResultSet.UpdateShort(ColumnIndex, RowAccessor.GetShort(FieldIndex, WasNull));
      ftInteger, ftAutoInc:
        ResultSet.UpdateInt(ColumnIndex, RowAccessor.GetInt(FieldIndex, WasNull));
      ftFloat:
        ResultSet.UpdateDouble(ColumnIndex, RowAccessor.GetDouble(FieldIndex, WasNull));
      ftLargeInt:
        ResultSet.UpdateLong(ColumnIndex, RowAccessor.GetLong(FieldIndex, WasNull));
      ftCurrency:
        ResultSet.UpdateBigDecimal(ColumnIndex,
          RowAccessor.GetBigDecimal(FieldIndex, WasNull));
      ftString, ftWidestring:
        if ResultSet.GetConSettings^.ClientCodePage^.IsStringFieldCPConsistent then
          ResultSet.UpdateRawByteString(ColumnIndex,
            RowAccessor.GetRawByteString(FieldIndex, WasNull))
        else
          ResultSet.UpdateUnicodeString(ColumnIndex,
            RowAccessor.GetUnicodeString(FieldIndex, WasNull));
      ftBytes{$IFDEF WITH_FTGUID}, ftGuid{$ENDIF}:
        ResultSet.UpdateBytes(ColumnIndex, RowAccessor.GetBytes(FieldIndex, WasNull));
      ftDate:
        ResultSet.UpdateDate(ColumnIndex, RowAccessor.GetDate(FieldIndex, WasNull));
      ftTime:
        ResultSet.UpdateTime(ColumnIndex, RowAccessor.GetTime(FieldIndex, WasNull));
      ftDateTime:
        ResultSet.UpdateTimestamp(ColumnIndex,
          RowAccessor.GetTimestamp(FieldIndex, WasNull));
      ftMemo:
        begin
          Stream := RowAccessor.GetAsciiStream(FieldIndex, WasNull);
          try
            ResultSet.UpdateAsciiStream(ColumnIndex, Stream);
          finally
            Stream.Free;
          end;
        end;
      {$IFDEF WITH_WIDEMEMO}
      ftWideMemo:
        begin
          Stream := RowAccessor.GetUnicodeStream(FieldIndex, WasNull);
          try
            ResultSet.UpdateUnicodeStream(ColumnIndex, Stream);
          finally
            Stream.Free;
          end;
        end;
      {$ENDIF}
      ftBlob:
        begin
          Stream := RowAccessor.GetBinaryStream(FieldIndex, WasNull);
          try
            ResultSet.UpdateBinaryStream(ColumnIndex, Stream);
          finally
            Stream.Free;
          end;
        end;
      {$IFDEF WITH_FTDATASETSUPPORT}
      ftDataSet:
        ResultSet.UpdateDataSet(ColumnIndex, RowAccessor.GetDataSet(FieldIndex, WasNull));
      {$ENDIF}
    end;

    if WasNull then
      begin
        // Performance thing :
        // The default expression will only be set when necessary : if the value really IS null
        Resultset.UpdateDefaultExpression(ColumnIndex, RowAccessor.GetColumnDefaultExpression(FieldIndex));
        ResultSet.UpdateNull(ColumnIndex);
      end;
  end;
end;

{**
  Defines fields indices for the specified dataset.
  @param DataSet a dataset object.
  @param FieldNames a list of field names.
  @param OnlyDataFields <code>True</code> if only data fields selected.
}
function DefineFields(DataSet: TDataset; const FieldNames: string;
  var OnlyDataFields: Boolean): TObjectDynArray;
var
  I: Integer;
  Tokens: TStrings;
  TokenType: TZTokenType;
  TokenValue: string;
  Field: TField;
  FieldCount: Integer;
begin
  OnlyDataFields := True;
  FieldCount := 0;
  SetLength(Result, FieldCount);
  Tokens := CommonTokenizer.TokenizeBufferToList(FieldNames,
    [toSkipEOF, toSkipWhitespaces, toUnifyNumbers, toDecodeStrings]);

  try
    for I := 0 to Tokens.Count - 1 do
    begin
      TokenType := TZTokenType({$IFDEF oldFPC}Pointer({$ENDIF}
        Tokens.Objects[I]{$IFDEF oldFPC}){$ENDIF});
      TokenValue := Tokens[I];
      Field := nil;

      if TokenType in [ttWord, ttQuoted] then
      begin
        Field := DataSet.FieldByName(TokenValue);
      end
      else if (TokenType = ttNumber)
        and (StrToIntDef(TokenValue, 0) < Dataset.Fields.Count) then
      begin
        Field := Dataset.Fields[StrToIntDef(TokenValue, 0)];
      end
      else if (TokenValue <> ',') and (TokenValue <> ';') then
      begin
        raise EZDatabaseError.Create(Format(SIncorrectSymbol, [TokenValue]));
      end;

      if Field <> nil then
      begin
        OnlyDataFields := OnlyDataFields and (Field.FieldKind = fkData);
        Inc(FieldCount);
        SetLength(Result, FieldCount);
        Result[FieldCount - 1] := Field;
      end;
    end;
  finally
    Tokens.Free;
  end;

  if Length(Result) = 0 then
    Result := nil;
end;

{**
  Defins a indices of filter fields.
  @param Dataset a dataset object.
  @param Expression a expression calculator.
  @returns an array with field object references.
}
function DefineFilterFields(DataSet: TDataset;
  Expression: IZExpression): TObjectDynArray;
var
  I: Integer;
  Current: TField;
begin
  if Expression.Expression <> '' then
  begin
    SetLength(Result, Expression.DefaultVariables.Count);
    for I := 0 to Expression.DefaultVariables.Count - 1 do
    begin
      Current := DataSet.FindField(Expression.DefaultVariables.Names[I]);
      if Current <> nil then
        Result[I] := Current
      else
        Result[I] := nil;
    end;
  end
  else
    SetLength(Result, 0);
end;

{**
  Retrieves a set of specified field values.
  @param FieldRefs an array with interested field object references.
  @param ResultSet an initial result set object.
  @param ResultValues a container for result values.
  @return an array with field values.
}
procedure RetrieveDataFieldsFromResultSet(const FieldRefs: TObjectDynArray;
  ResultSet: IZResultSet; var ResultValues: TZVariantDynArray);
var
  I, ColumnIndex: Integer;
begin
  for I := 0 to High(FieldRefs) do
  begin
    ColumnIndex := TField(FieldRefs[I]).FieldNo;
    if ColumnIndex >= 0 then
    begin
      case TField(FieldRefs[I]).DataType of
        ftString:
          ResultValues[I] := EncodeString(ResultSet.GetString(ColumnIndex));
        ftBoolean:
          ResultValues[I] := EncodeBoolean(ResultSet.GetBoolean(ColumnIndex));
        {$IFDEF WITH_FTBYTE}ftByte,{$ENDIF}{$IFDEF WITH_FTSHORTINT}ftShortInt,{$ENDIF}
        ftSmallInt, ftInteger, ftAutoInc:
          ResultValues[I] := EncodeInteger(ResultSet.GetInt(ColumnIndex));
        ftFloat, ftCurrency:
          ResultValues[I] := EncodeFloat(ResultSet.GetBigDecimal(ColumnIndex));
        ftLargeInt:
          ResultValues[I] := EncodeInteger(ResultSet.GetLong(ColumnIndex));
        ftDate, ftTime, ftDateTime:
          ResultValues[I] := EncodeDateTime(ResultSet.GetTimestamp(ColumnIndex));
        ftWidestring{$IFDEF WITH_WIDEMEMO},ftWideMemo{$ENDIF}:
          ResultValues[I] := EncodeUnicodeString(ResultSet.GetUnicodeString(ColumnIndex));
        ftBytes, ftBlob:
          ResultValues[I] := EncodeBytes(ResultSet.GetBytes(ColumnIndex));
        else
          ResultValues[I] := EncodeString(ResultSet.GetString(ColumnIndex));
      end;
      if ResultSet.WasNull then
        ResultValues[I] := NullVariant;
    end
    else
      ResultValues[I] := NullVariant;
  end;
end;

{**
  Retrieves a set of specified field values.
  @param FieldRefs an array with interested field object references.
  @param FieldIndices an array with interested field indices.
  @param RowAccessor a row accessor object.
  @param ResultValues a container for result values.
  @return an array with field values.
}
procedure RetrieveDataFieldsFromRowAccessor(const FieldRefs: TObjectDynArray;
  const FieldIndices: TIntegerDynArray; RowAccessor: TZRowAccessor;
  var ResultValues: TZVariantDynArray);
var
  I: Integer;
  ColumnIndex: Integer;
  WasNull: Boolean;
begin
  WasNull := False;
  for I := 0 to High(FieldRefs) do
  begin
    ColumnIndex := FieldIndices[I];
    case TField(FieldRefs[I]).DataType of
      ftString, ftMemo:
        ResultValues[I] := EncodeString(RowAccessor.GetString(ColumnIndex, WasNull));
      ftBoolean:
        ResultValues[I] := EncodeBoolean(RowAccessor.GetBoolean(ColumnIndex, WasNull));
      {$IFDEF WITH_FTBYTE}ftByte,{$ENDIF}{$IFDEF WITH_FTSHORTINT}ftShortInt,{$ENDIF}
      ftSmallInt, ftInteger, ftAutoInc:
        ResultValues[I] := EncodeInteger(RowAccessor.GetInt(ColumnIndex, WasNull));
      ftFloat, ftCurrency:
        ResultValues[I] := EncodeFloat(RowAccessor.GetBigDecimal(ColumnIndex, WasNull));
      ftLargeInt:
        ResultValues[I] := EncodeInteger(RowAccessor.GetLong(ColumnIndex, WasNull));
      ftDate, ftTime, ftDateTime:
        ResultValues[I] := EncodeDateTime(RowAccessor.GetTimestamp(ColumnIndex, WasNull));
      ftWidestring{$IFDEF WITH_WIDEMEMO},ftWideMemo{$ENDIF}:
        ResultValues[I] := EncodeUnicodeString(RowAccessor.GetUnicodeString(ColumnIndex, WasNull));
      ftBytes:
        ResultValues[I] := EncodeBytes(RowAccessor.GetBytes(ColumnIndex, WasNull));
      else
        ResultValues[I] := EncodeString(RowAccessor.GetString(ColumnIndex, WasNull));
    end;
    if WasNull then
      ResultValues[I] := NullVariant;
  end;
end;

{**
  Copy a set of specified field values to variables.
  @param Fields an array with interested field object references.
  @param ResultSet an initial result set object.
  @param Variables a list of variables.
}
{$IFDEF FPC}
  {$HINTS OFF} //Temp seems not to be init...
{$ENDIF}
procedure CopyDataFieldsToVars(const Fields: TObjectDynArray;
  ResultSet: IZResultSet; Variables: IZVariablesList);
var
  I, ColumnIndex: Integer;
begin
  for I := 0 to Length(Fields) - 1 do
  begin
    if Fields[I] = nil then
      Continue;

    ColumnIndex := TField(Fields[I]).FieldNo;
    if not ResultSet.IsNull(ColumnIndex) then
    begin
      case TField(Fields[I]).DataType of
        ftBoolean:
          Variables.Values[I] := EncodeBoolean(ResultSet.GetBoolean(ColumnIndex));
        {$IFDEF WITH_FTBYTE}ftByte,{$ENDIF}{$IFDEF WITH_FTSHORTINT}ftShortInt,{$ENDIF}
        ftSmallInt, ftInteger, ftAutoInc:
          Variables.Values[I] := EncodeInteger(ResultSet.GetInt(ColumnIndex));
        ftFloat:
          Variables.Values[I] := EncodeFloat(ResultSet.GetDouble(ColumnIndex));
        ftLargeInt:
          Variables.Values[I] := EncodeInteger(ResultSet.GetLong(ColumnIndex));
        ftCurrency:
          Variables.Values[I] := EncodeFloat(ResultSet.GetBigDecimal(ColumnIndex));
        ftDate:
          Variables.Values[I] := EncodeDateTime(ResultSet.GetDate(ColumnIndex));
        ftTime:
          Variables.Values[I] := EncodeDateTime(ResultSet.GetTime(ColumnIndex));
        ftDateTime:
          Variables.Values[I] := EncodeDateTime(ResultSet.GetTimestamp(ColumnIndex));
        ftString, ftMemo:
          Variables.Values[I] := EncodeString(ResultSet.GetString(ColumnIndex));
        ftWidestring{$IFDEF WITH_WIDEMEMO}, ftWideMemo{$ENDIF}:
          Variables.Values[I] := EncodeUnicodeString(ResultSet.GetUnicodeString(ColumnIndex));
        ftBytes:
          Variables.Values[I] := EncodeBytes(ResultSet.GetBytes(ColumnIndex));
        else
          Variables.Values[I] := EncodeString(ResultSet.GetString(ColumnIndex));
      end;
    end
    else
      Variables.Values[I] := NullVariant;
  end;
end;
{$IFDEF FPC}
  {$HINTS OFF}
{$ENDIF}

{**
  Compares row field values with the given ones.
  @param KeyValues given values.
  @param RowValues row field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
  @return <code> if values are equal.
}
function CompareDataFields(const KeyValues, RowValues: TZVariantDynArray;
  PartialKey: Boolean; CaseInsensitive: Boolean): Boolean;
var
  I: Integer;
  Value1, Value2: AnsiString;
  WValue1, WValue2: WideString;
begin
  Result := True;
  for I := 0 to High(KeyValues) do
  begin
    case KeyValues[I].VType of
      vtUnicodeString:
        begin
          if CaseInsensitive then
          begin
            WValue1 := WideUpperCase(SoftVarManager.GetAsUnicodeString(KeyValues[I]));
            WValue2 := WideUpperCase(SoftVarManager.GetAsUnicodeString(RowValues[I]));
            if PartialKey then
            begin
              {$IFDEF UNICODE}
              Result := SysUtils.AnsiStrLComp(PWideChar(WValue2), PWideChar(WValue1), Length(WValue1)) = 0;
              {$ELSE}
              Value1 := AnsiString(WValue1);
              Value2 := AnsiString(WValue2);
              Result := AnsiStrLComp(PAnsiChar(Value2), PAnsiChar(Value1), Length(Value1)) = 0;
              {$ENDIF}
            end
            else
              Result := WValue1 = WValue2
          end
          else
          begin
            WValue1 := SoftVarManager.GetAsUnicodeString(KeyValues[I]);
            WValue1 := SoftVarManager.GetAsUnicodeString(RowValues[I]);
            if PartialKey then
            begin
              {$IFDEF UNICODE}
              Result := SysUtils.AnsiStrLComp(PWideChar(WValue2), PWideChar(WValue1), Length(WValue1)) = 0;
              {$ELSE}
              Value1 := AnsiString(WValue1);
              Value2 := AnsiString(WValue2);
              Result := AnsiStrLComp(PAnsiChar(Value2), PAnsiChar(Value1), Length(Value1)) = 0;
              {$ENDIF}
            end
            else
              Result := SoftVarManager.Compare(KeyValues[I], RowValues[I]) = 0;
          end;
        end;
      else
      begin
        if CaseInsensitive then
        begin
          Value1 := {$IFDEF WITH_UNITANSISTRINGS}AnsiStrings.{$ENDIF}AnsiUpperCase(SoftVarManager.GetAsAnsiString(KeyValues[I]));
          Value2 := {$IFDEF WITH_UNITANSISTRINGS}AnsiStrings.{$ENDIF}AnsiUpperCase(SoftVarManager.GetAsAnsiString(RowValues[I]));
          if PartialKey then

            Result := {$IFDEF WITH_ANSISTRLCOMP_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrLComp(PAnsiChar(Value2), PAnsiChar(Value1), Length(Value1)) = 0
          else
            Result := Value1 = Value2
        end
        else
        begin
          Value1 := SoftVarManager.GetAsAnsiString(KeyValues[I]);
          Value2 := SoftVarManager.GetAsAnsiString(RowValues[I]);
          if PartialKey then
            Result := {$IFDEF WITH_ANSISTRLCOMP_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrLComp(PAnsiChar(Value2), PAnsiChar(Value1), Length(Value1)) = 0
          else
            Result := SoftVarManager.Compare(KeyValues[I], RowValues[I]) = 0;
        end;
      end;
    end;

    if not Result then
      Break;
  end;
end;

{**
  Prepares values for comparison by CompareFieldsFromResultSet.
  @param FieldRefs an array with interested field object references.
  @param DecodedKeyValues given values.
  @param ResultSet  a resultset to get field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
}
procedure PrepareValuesForComparison(const FieldRefs: TObjectDynArray;
  var DecodedKeyValues: TZVariantDynArray; ResultSet: IZResultSet;
  PartialKey: Boolean; CaseInsensitive: Boolean);
var
  I: Integer;
  Current: TField;
  CurrentType : TZSQLType;
begin
  { Preprocesses cycle variables. }
  for I := 0 to High(FieldRefs) do
  begin
    Current := TField(FieldRefs[I]);

    if DecodedKeyValues[I].VType = vtNull then
      Continue;
    CurrentType := ResultSet.GetMetadata.GetColumnType(Current.FieldNo);

    if PartialKey then
    begin
      if CurrentType = stUnicodeString then
      begin
        DecodedKeyValues[I] := SoftVarManager.Convert(
          DecodedKeyValues[I], vtUnicodeString);
        if CaseInsensitive then
        begin
          if DecodedKeyValues[I].VType = vtString then
          begin
            DecodedKeyValues[I].VString := Uppercase(DecodedKeyValues[I].VString);
            DecodedKeyValues[I].VUnicodeString := DecodedKeyValues[I].VString;
          end
          else
          begin
            DecodedKeyValues[I].VUnicodeString :=
              WideUpperCase(DecodedKeyValues[I].VUnicodeString);
          end;
        end;
      end
      else
      begin
        DecodedKeyValues[I] := SoftVarManager.Convert(
          DecodedKeyValues[I], vtString);
        if CaseInsensitive then
        begin
          {$IFDEF LAZARUSUTF8HACK} // Is this correct? Assumes the Lazarus convention all strings are UTF8. But is that
                       // true in this point, or should that be converted higher up?
          DecodedKeyValues[I].VString := 
            WideUpperCase(UTF8Decode (DecodedKeyValues[I].VString)); 
          {$ELSE} 
          DecodedKeyValues[I].VString := 
            AnsiUpperCase(DecodedKeyValues[I].VString); 
          {$ENDIF} 
        end;
      end;
    end
    else
    begin
      case CurrentType of
        stBoolean:
          DecodedKeyValues[I] := SoftVarManager.Convert(
            DecodedKeyValues[I], vtBoolean);
        stByte, stShort, stInteger, stLong:
          DecodedKeyValues[I] := SoftVarManager.Convert(
            DecodedKeyValues[I], vtInteger);
        stFloat, stDouble, stBigDecimal:
          DecodedKeyValues[I] := SoftVarManager.Convert(
            DecodedKeyValues[I], vtFloat);
        stUnicodeString:
          begin
            if CaseInsensitive then
            begin
              if DecodedKeyValues[I].VType = vtString then
              begin
                DecodedKeyValues[I].VString := Uppercase(DecodedKeyValues[I].VString);
                DecodedKeyValues[I].VUnicodeString := DecodedKeyValues[I].VString;
              end
              else
              begin
                DecodedKeyValues[I].VUnicodeString :=
                  WideUpperCase(DecodedKeyValues[I].VUnicodeString);
              end;
            end
            else
            begin
              DecodedKeyValues[I] := SoftVarManager.Convert(
                DecodedKeyValues[I], vtUnicodeString);
            end;
          end;
        stDate, stTime, stTimestamp:
          DecodedKeyValues[I] := SoftVarManager.Convert(
            DecodedKeyValues[I], vtDateTime);
        else
          if CaseInsensitive then
          begin
            DecodedKeyValues[I] := SoftVarManager.Convert( 
              DecodedKeyValues[I], vtString); 
            {$IFDEF LAZARUSUTF8HACK}
                    // Is this correct? Assumes the Lazarus convention all strings are UTF8. But is that
                    // true in this point, or should that be converted higher up?
            DecodedKeyValues[I].VString :=
              WideUpperCase(UTF8Decode (DecodedKeyValues[I].VString));
            {$ELSE}
            DecodedKeyValues[I].VString := 
              AnsiUpperCase(DecodedKeyValues[I].VString); 
            {$ENDIF} 
          end
          else
          begin
            DecodedKeyValues[I] := SoftVarManager.Convert(
              DecodedKeyValues[I], vtString);
          end;
      end;
    end;
  end;
end;

{**
  Compares row field values with the given ones.
  @param FieldRefs an array with interested field object references.
  @param KeyValues given values.
  @param ResultSet  a resultset to get field values.
  @param PartialKey <code>True</code> if values should be started with the keys.
  @param CaseInsensitive <code>True</code> if keys are case insensitive.
  @return <code> if values are equal.
}
function CompareFieldsFromResultSet(const FieldRefs: TObjectDynArray;
  const KeyValues: TZVariantDynArray; ResultSet: IZResultSet; PartialKey: Boolean;
  CaseInsensitive: Boolean): Boolean;
var
  I: Integer;
  ColumnIndex: Integer;
  AValue1, AValue2: AnsiString;
  WValue1, WValue2: WideString;
  CurrentType : TZSQLType;
begin
  Result := True;
  for I := 0 to High(KeyValues) do
  begin
    ColumnIndex := TField(FieldRefs[I]).FieldNo;

    if KeyValues[I].VType = vtNull then
    begin
      Result := ResultSet.IsNull(ColumnIndex);
      if not Result then
         Break;
      Continue;
    end;

    CurrentType := ResultSet.GetMetadata.GetColumnType(ColumnIndex);

    if PartialKey then
    begin
      if CurrentType = stUnicodeString then
      begin
        WValue1 := KeyValues[I].VUnicodeString;
        WValue2 := ResultSet.GetUnicodeString(ColumnIndex);

        if CaseInsensitive then
          WValue2 := WideUpperCase(WValue2);
        {$IFDEF UNICODE}
        Result := SysUtils.AnsiStrLComp(PWideChar(WValue2), PWideChar(WValue1), Length(WValue1)) = 0;
        {$ELSE}
          AValue1 := UTF8ToAnsi(UTF8Encode(WValue1));
          AValue2 := UTF8ToAnsi(UTF8Encode(WValue2));
          Result := AnsiStrLComp(PAnsiChar(AValue2), PAnsiChar(AValue1), Length(AValue1)) = 0;
        {$ENDIF}
      end
      else
      begin
        AValue1 := AnsiString(KeyValues[I].VString);
        if (ResultSet.GetConSettings.ClientCodePage^.Encoding = ceAnsi)
          or (ResultSet.GetConSettings.AutoEncode and ( ResultSet.GetConSettings.CTRL_CP <> 65001 )) then
          AValue2 := AnsiString(ResultSet.GetString(ColumnIndex))
        else
          AValue2 := AnsiString({$IFNDEF UNICODE}UTF8ToAnsi{$ENDIF}(ResultSet.GetString(ColumnIndex)));

        if CaseInsensitive then
          AValue2 := {$IFDEF WITH_UNITANSISTRINGS}AnsiStrings.{$ENDIF}AnsiUpperCase(AValue2);
        Result := {$IFDEF WITH_ANSISTRLCOMP_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrLComp(PAnsiChar(AValue2), PAnsiChar(AValue1), Length(AValue1)) = 0;
      end;

    end
    else
    begin
      case CurrentType of
        stBoolean:
          begin
            Result := KeyValues[I].VBoolean =
              ResultSet.GetBoolean(ColumnIndex);
          end;
        stByte,
        stShort,
        stInteger,
        stLong:
          Result := KeyValues[I].VInteger = ResultSet.GetLong(ColumnIndex);
        stFloat:
          Result := Abs(KeyValues[I].VFloat -
            ResultSet.GetBigDecimal(ColumnIndex)) < FLOAT_COMPARE_PRECISION_SINGLE;
        stDouble,
        stBigDecimal:
          Result := Abs(KeyValues[I].VFloat -
            ResultSet.GetBigDecimal(ColumnIndex)) < FLOAT_COMPARE_PRECISION;
        stDate,
        stTime,
        stTimestamp:
          Result := KeyValues[I].VDateTime = ResultSet.GetTimestamp(ColumnIndex);
        stUnicodeString:
          begin
            if CaseInsensitive then
            begin
              Result := KeyValues[I].VUnicodeString =
                WideUpperCase(ResultSet.GetUnicodeString(ColumnIndex));
            end
            else
            begin
              Result := KeyValues[I].VUnicodeString =
                ResultSet.GetUnicodeString(ColumnIndex);
            end;
          end;
        else
          if CaseInsensitive then
          begin
            {$IFDEF LAZARUSUTF8HACK}
            Result := KeyValues[I].VString =
              AnsiUpperCase (Utf8ToAnsi(ResultSet.GetString(ColumnIndex)));
            {$ELSE}
            Result := KeyValues[I].VString =
              AnsiUpperCase(ResultSet.GetString(ColumnIndex));
            {$ENDIF}
          end
          else
          begin
            Result := KeyValues[I].VString =
              ResultSet.GetString(ColumnIndex);
          end;
      end;
    end;

    Result := Result and not ResultSet.WasNull;
    if not Result then
      Break;
  end;
end;

{**
  Defines a list of key field names.
  @param Fields a collection of dataset fields.
  @return a list of key field names.
}
function DefineKeyFields(Fields: TFields): string;
var
  I: Integer;
  Temp: string;
begin
  Result := '';
  for I := 0 to Fields.Count - 1 do
  begin
    if (Fields[I].FieldKind = fkData)
      and not (Fields[I].DataType in [ftBlob, ftMemo, ftBytes {$IFDEF WITH_WIDEMEMO}, ftWideMemo{$ENDIF}]) then
    begin
      if Result <> '' then
        Result := Result + ',';
      Temp := Fields[I].FieldName;
      if (Pos(' ', Temp) > 0) or (Pos('-', Temp) > 0) or (Pos('.', Temp) > 0) then
        Temp := '"' + Temp + '"';
      Result := Result + Temp;
    end;
  end;
end;

{**
  Converts datetime value into TDataset internal presentation.
  @param DataType a type of date-time field.
  @param Data a data which contains a value.
  @param Buffer a field buffer pointer
}
procedure DateTimeToNative(DataType: TFieldType; Data: TDateTime;
  Buffer: Pointer);
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp := DateTimeToTimeStamp(Data);
  case DataType of
    ftDate: Integer(Buffer^) := TimeStamp.Date;
    ftTime: Integer(Buffer^) := TimeStamp.Time;
  else
    TDateTime(Buffer^) := TimeStampToMSecs(TimeStamp);
  end;
end;

{**
  Converts date times from TDataset internal presentation into datetime value.
  @param DataType a type of date-time field.
  @param Buffer a field buffer pointer
  @return a data which contains a value.
}
function NativeToDateTime(DataType: TFieldType; Buffer: Pointer): TDateTime;
{$IFNDEF OLDFPC}
var
  TimeStamp: TTimeStamp;
begin
  case DataType of
    ftDate:
      begin
        TimeStamp.Time := 0;
        TimeStamp.Date := Integer(Buffer^);
      end;
    ftTime:
      begin
        {$IFDEF WITH_FPC_FTTIME_BUG}
        TimeStamp := DateTimeToTimeStamp(TDateTime(Buffer^));
        {$ELSE}
        TimeStamp.Time := Integer(Buffer^);
        TimeStamp.Date := DateDelta;
        {$ENDIF}
      end;
  else
    try
      {$IF not defined(cpui386) and defined(FPC)}
      TimeStamp := MSecsToTimeStamp(System.Trunc(Int(TDateTime(Buffer^))));
      {$ELSE}
        TimeStamp := MSecsToTimeStamp(TDateTime(Buffer^));
      {$IFEND}
    except
      TimeStamp.Time := 0;
      TimeStamp.Date := 0;
    end;
  end;
  Result := TimeStampToDateTime(TimeStamp);
{$ELSE}
begin
  Result := TDateTime(Buffer^);
{$ENDIF}
end;

{**
  Compare values from two key fields.
  @param Field1 the first field object.
  @param ResultSet the resultset to read the first field value.
  @param Field2 the second field object.
}
function CompareKeyFields(Field1: TField; ResultSet: IZResultSet;
  Field2: TField): Boolean;
begin
  Result := False;
  if Field1.FieldNo >= 1 then
  begin
    case Field1.DataType of
      ftBoolean:
        Result := ResultSet.GetBoolean(Field1.FieldNo) = Field2.AsBoolean;
      ftSmallInt, ftInteger, ftAutoInc:
        Result := ResultSet.GetInt(Field1.FieldNo) = Field2.AsInteger;
      ftFloat:
        begin
          Result := Abs(ResultSet.GetFloat(Field1.FieldNo)
            - Field2.AsFloat) < FLOAT_COMPARE_PRECISION;
        end;
      ftLargeInt:
        begin
          if Field2 is TLargeIntField then
            Result := ResultSet.GetLong(Field1.FieldNo)
              = TLargeIntField(Field2).AsLargeInt
          else
            Result := ResultSet.GetInt(Field1.FieldNo) = Field2.AsInteger;
        end;
      ftCurrency:
        begin 
          Result := Abs(ResultSet.GetBigDecimal(Field1.FieldNo) 
            - Field2.{$IFDEF WITH_ASCURRENCY}AsCurrency{$ELSE}AsFloat{$ENDIF})
            < FLOAT_COMPARE_PRECISION;
        end;
      ftDate:
        Result := ResultSet.GetDate(Field1.FieldNo) = Field2.AsDateTime;
      ftTime:
        Result := ResultSet.GetTime(Field1.FieldNo) = Field2.AsDateTime;
      ftDateTime:
        Result := ResultSet.GetTimestamp(Field1.FieldNo) = Field2.AsDateTime;
      ftWideString:
        Result := ResultSet.GetUnicodeString(Field1.FieldNo) =
          Field2.{$IFDEF WITH_ASVARIANT}AsVariant{$ELSE}AsString{$ENDIF};
      else
        Result := ResultSet.GetString(Field1.FieldNo) = Field2.AsString;
    end;
  end;
end;

{**
  Defins a indices and directions for sorted fields.
  @param Dataset a dataset object.
  @param SortedFields an encoded fields for sorting in the format
    <Field Name> [ASC | DESC] [, ...]
  @param FieldRefs a decoded field object references.
  @param FieldDirs a decoded field directions.
  @param OnlyDataFields <code>True</code> if only data fields selected.
}
procedure DefineSortedFields(DataSet: TDataset;
  const SortedFields: string; var FieldRefs: TObjectDynArray;
  var FieldDirs: TBooleanDynArray; var OnlyDataFields: Boolean);
var
  I: Integer;
  Tokens: TStrings;
  TokenType: TZTokenType;
  TokenValue: string;
  Field: TField;
  FieldCount: Integer;
begin
  OnlyDataFields := True;
  FieldCount := 0;
  SetLength(FieldRefs, FieldCount);
  SetLength(FieldDirs, FieldCount);
  Tokens := CommonTokenizer.TokenizeBufferToList(SortedFields,
    [toSkipEOF, toSkipWhitespaces, toUnifyNumbers, toDecodeStrings]);

  try
    for I := 0 to Tokens.Count - 1 do
    begin
      TokenType := TZTokenType({$IFDEF OLDFPC}Pointer({$ENDIF}
        Tokens.Objects[I]{$IFDEF OLDFPC}){$ENDIF});
      TokenValue := Tokens[I];
      Field := nil;

      if ((UpperCase(TokenValue) = 'DESC')
        or (UpperCase(TokenValue) = 'ASC')) and (FieldCount > 0) then
      begin
        FieldDirs[FieldCount - 1] := (UpperCase(TokenValue) <> 'DESC');
      end
      else if TokenType in [ttWord, ttQuoted] then
      begin
        Field := DataSet.FieldByName(TokenValue)
      end
      else if (TokenType = ttNumber)
        and (StrToIntDef(TokenValue, 0) < Dataset.Fields.Count) then
      begin
        Field := Dataset.Fields[StrToIntDef(TokenValue, 0)];
      end
      else if (TokenValue <> ',') and (TokenValue <> ';') then
      begin
        raise EZDatabaseError.Create(Format(SIncorrectSymbol, [TokenValue]));
      end;

      if Field <> nil then
      begin
        OnlyDataFields := OnlyDataFields and (Field.FieldKind = fkData);
        Inc(FieldCount);
        SetLength(FieldRefs, FieldCount);
        SetLength(FieldDirs, FieldCount);
        FieldRefs[FieldCount - 1] := Field;
        FieldDirs[FieldCount - 1] := True;
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

{**
  Creates a fields lookup table to define fixed position
  of the field in dataset.
  @param Fields a collection of TDataset fields in initial order.
  @returns a fields lookup table.
}
function CreateFieldsLookupTable(Fields: TFields): TIntegerDynArray;
var
  I: Integer;
begin
  SetLength(Result, Fields.Count);
  for I := 0 to Fields.Count - 1 do
    Result[I] := Integer(Fields[I]);
end;

{**
  Defines an original field index in the dataset.
  @param FieldsLookupTable a lookup table to define original index.
  @param Field a TDataset field object.
  @returns an original fields index or -1 otherwise.
}
function DefineFieldIndex(const FieldsLookupTable: TIntegerDynArray;
  Field: TField): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FieldsLookupTable) do
  begin
    if FieldsLookupTable[I] = Integer(Field) then
    begin
      Result := I + 1;
      Break;
    end;
  end;
end;

{**
  Defines an original field indices in the dataset.
  @param FieldsLookupTable a lookup table to define original index.
  @param FieldRefs a TDataset field object references.
  @returns an array with original fields indices.
}
function DefineFieldIndices(const FieldsLookupTable: TIntegerDynArray;
  const FieldRefs: TObjectDynArray): TIntegerDynArray;
var
  I: Integer;
begin
  if FieldRefs = nil then
  begin
    Result := nil;
    Exit;
  end;

  SetLength(Result, Length(FieldRefs));
  for I := 0 to High(Result) do
    Result[I] := DefineFieldIndex(FieldsLookupTable, TField(FieldRefs[I]));
end;

{**
  Splits up a qualified object name into pieces. Catalog, schema
  and objectname.
}
procedure SplitQualifiedObjectName(QualifiedName: string;
  var Catalog, Schema, ObjectName: string);

{$IFDEF OLDFPC}
function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar;
  Strings: TStrings): Integer;
var
  Head, Tail: PChar;
  EOS, InQuote: Boolean;
  QuoteChar: Char;
  Item: string;
begin
  Result := 0;
  if (Content = nil) or (Content^ = #0) or (Strings = nil) then
     Exit;
  Tail := Content;
  InQuote := False;
  QuoteChar := #0;
  Strings.BeginUpdate;
  try
    repeat
      while CharInSet(Tail^, WhiteSpace + [#13, #10]) do
        Inc(Tail);
      Head := Tail;
      while True do
      begin
        while (InQuote and not CharInSet(Tail^, [QuoteChar, #0])) or
               not CharInSet(Tail^, Separators + [#0, #13, #10, '''', '"']) do
           Inc(Tail);
        if CharInSet(Tail^, ['''', '"']) then
        begin
          if (QuoteChar <> #0) and (QuoteChar = Tail^) then
            QuoteChar := #0
          else
            QuoteChar := Tail^;
          InQuote := QuoteChar <> #0;
          Inc(Tail);
        end
        else
          Break;
      end;
      EOS := Tail^ = #0;
      if (Head <> Tail) and (Head^ <> #0) then
      begin
        if Strings <> nil then
        begin
          SetString(Item, Head, Tail - Head);
          Strings.Add(Item);
        end;
        Inc(Result);
      end;
      Inc(Tail);
    until EOS;
  finally
    Strings.EndUpdate;
  end;
end;
{$ENDIF}

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    Catalog := '';
    Schema := '';
    ObjectName := QualifiedName;
    ExtractStrings(['.'], [' '], PChar(QualifiedName), SL);
    case SL.Count of
      0, 1: ;
      2: begin
           Schema := SL.Strings[0];
           ObjectName := SL.Strings[1];
         end;
      3: begin
           Catalog := SL.Strings[0];
           Schema := SL.Strings[1];
           ObjectName := SL.Strings[2];
         end;
    else
      begin
        ObjectName := SL.Strings[SL.Count - 1];
        Schema := SL.Strings[SL.Count - 2];
        for I := 0 to SL.Count - 3 do
        begin
          Catalog := Catalog + SL.Strings[I];
          if I < SL.Count - 3 then
            Catalog := Catalog + '.';
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;

{**
  Splits up a qualified object name into pieces. Catalog, schema
  and objectname.
}
procedure SplitQualifiedObjectName(QualifiedName: string;
  const SupportsCatalogs, SupportsSchemas: Boolean;
  var Catalog, Schema, ObjectName: string);
var
  SL: TStringList;
  I: Integer;
begin
  if SupportsCatalogs and SupportsSchemas then
    SplitQualifiedObjectName(QualifiedName, Catalog, Schema, ObjectName)
  else
  begin
    SL := TStringList.Create;
    try
      Catalog := '';
      Schema := '';
      ObjectName := QualifiedName;
      ExtractStrings(['.'], [' '], PChar(QualifiedName), SL);
      case SL.Count of
        0, 1: ;
        2:
          begin
            if SupportsCatalogs then
            begin
              Catalog := SL.Strings[0];
              if SupportsSchemas then
                Schema := SL.Strings[1]
              else
                ObjectName := SL.Strings[1];
            end
            else
              if SupportsSchemas then
              begin
                Schema := SL.Strings[0];
                ObjectName := SL.Strings[1];
              end
              else
                ObjectName := SL.Strings[0]+'.'+SL.Strings[1];
          end;
        3:
          if SupportsCatalogs then
          begin
            Catalog := SL.Strings[0];
            if SupportsSchemas then
            begin
              Schema := SL.Strings[1];
              ObjectName := SL.Strings[2]
            end
            else
              ObjectName := SL.Strings[1]+'.'+SL.Strings[2];
          end
          else
            if SupportsSchemas then
            begin
              Schema := SL.Strings[0];
              ObjectName := SL.Strings[1]+'.'+SL.Strings[2];
            end
            else
              ObjectName := SL.Strings[0]+'.'+SL.Strings[1]+'.'+SL.Strings[2];
        else
          if SupportsCatalogs then
          begin
            Catalog := SL.Strings[0];
            if SupportsSchemas then
            begin
              Schema := SL.Strings[1];
              for i := 2 to SL.Count-1 do
                if i = 2 then
                  ObjectName := SL.Strings[i]
                else
                  ObjectName := ObjectName+'.'+SL.Strings[i];
            end
            else
            begin
              ObjectName := '';
              for i := 2 to SL.Count-1 do
                if I = 2 then
                  ObjectName := SL.Strings[i]
                else
                  ObjectName := ObjectName+'.'+SL.Strings[i];
            end;
          end
          else
            if SupportsSchemas then
            begin
              Schema := SL.Strings[0];
              for i := 1 to SL.Count-1 do
                if i = 1 then
                  ObjectName := SL.Strings[i]
                else
                  ObjectName := ObjectName+'.'+SL.Strings[i];
            end
            else
              for i := 0 to SL.Count-1 do
                if I = 0 then
                  ObjectName := SL.Strings[i]
                else
                  ObjectName := ObjectName+'.'+SL.Strings[i];
        end;
    finally
      SL.Free;
    end;
  end;
end;

{**
  Assigns a Statement value from a TParam
  @param Index the index of Statement.SetXxxx(ColumnIndex, xxx);
  @param Statement the PrepredStatement where the values have been assigned
  @param Param the TParam where the value is assigned from
}
procedure SetStatementParam(Index: Integer;
  Statement: IZPreparedStatement; Param: TParam);
var
  Stream: TStream;
  TempBytes: TByteDynArray;
  {$IFDEF WITH_ASBYTES}Bts: TBytes;{$ENDIF}
  {$IFDEF WITHOUT_VARBYTESASSTRING}V: Variant;{$ENDIF}
begin
  if Param.IsNull then
    Statement.SetNull(Index, ConvertDatasetToDbcType(Param.DataType))
  else
  begin
    case Param.DataType of
      ftBoolean:
        Statement.SetBoolean(Index, Param.AsBoolean);
      ftSmallInt{$IFDEF WITH_FTSHORTINT}, ftShortInt{$ENDIF}:
        Statement.SetShort(Index, Param.AsSmallInt);
      ftInteger, ftAutoInc{$IFDEF WITH_FTBYTE}, ftByte{$ENDIF}:
        Statement.SetInt(Index, Param.AsInteger);
      ftFloat{$IFDEF WITH_FTEXTENDED}, ftExtended{$ENDIF}:
        Statement.SetDouble(Index, Param.AsFloat);
      {$IFDEF WITH_FTLONGWORD}
      ftLongWord:
        Statement.SetInt(Index, Integer(Param.AsLongWord));
      {$ENDIF}
      ftLargeInt:
        Statement.SetLong(Index, StrToInt64(Param.AsString));
      ftCurrency, ftBCD:
        Statement.SetBigDecimal(Index, Param.AsCurrency);
      ftString, ftFixedChar:
        Statement.SetString(Index, Param.AsString);
      {$IFDEF WITH_FTWIDESTRING}
      ftWideString:
        Statement.SetUnicodeString(Index, Param.AsWideString);
      {$ENDIF}
      ftBytes, ftVarBytes{$IFDEF WITH_FTGUID}, ftGuid{$ENDIF}:
        begin
          {$IFDEF WITH_ASBYTES}
          Bts := Param.AsBytes;
          SetLength(TempBytes, High(Bts)+1);
          System.Move(PAnsichar(Bts)^, PAnsichar(TempBytes)^, High(Bts)+1);
          {$ELSE}
            {$IFDEF WITHOUT_VARBYTESASSTRING}
            V := Param.Value;
            TempBytes := V;
            {$ELSE}
            TempBytes := StrToBytes(Param.AsString);
            {$ENDIF}
          {$ENDIF}
          Statement.SetBytes(Index, TempBytes);
        end;
      ftDate:
        Statement.SetDate(Index, Param.AsDate);
      ftTime:
        Statement.SetTime(Index, Param.AsTime);
      ftDateTime:
        Statement.SetTimestamp(Index, Param.AsDateTime);
      ftMemo:
        begin
          {EgonHugeist: On reading a Param as Memo the Stream reads Byte-wise
            on Changing to stUnicodeString/Delphi12Up a String is from
            Type wide/unicode so we have to give him back as
            Stream!}
            {$IFDEF UNICODE}
            Stream := Param.AsStream;
            {$ELSE}
            Stream := TStringStream.Create(Param.AsMemo);
            {$ENDIF}
          try
            Statement.SetAsciiStream(Index, Stream);
          finally
            Stream.Free;
          end;
        end;
      {$IFDEF WITH_WIDEMEMO}
      ftWideMemo:
        begin
          Stream := WideStringStream(Param.AsWideString);
          try
            Statement.SetUnicodeStream(Index, Stream);
           finally
             Stream.Free;
           end;
        end;
      {$ENDIF}
      ftBlob, ftGraphic:
        begin
          Stream := TStringStream.Create(Param.AsBlob);
          try
            Statement.SetBinaryStream(Index, Stream);
          finally
            Stream.Free;
          end;
        end;
      else
        raise EZDatabaseError.Create(SUnKnownParamDataType + {$IFNDEF WITH_FASTCODE_INTTOSTR}ZFastCode.{$ENDIF}IntToStr(Ord(Param.DataType)));
    end;
  end;
end;

initialization
  CommonTokenizer := TZGenericSQLTokenizer.Create;
finalization
  CommonTokenizer := nil;
end.

