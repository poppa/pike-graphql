#charset utf-8
#pike __REAL_VERSION__
#require constant(Parser@module@)

/* Parser.GraphQL
 *
 * Copyright (C) 2021 Pontus Östlund <https://github.com/poppa>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

//! Module that converts GraphQL source code into a GraphQL AST as JSON
//! This is a wrapper for @tt{libgraphql@}.

//! @ignore
inherit Parser@module@ : parent;
//! @endignore

public typedef mapping(string(8bit):mixed) ast_mapping;

public mapping(string(8bit):mixed) to_json(string gql_src)
//! Convert GraphQL code @[gql_src] to a GraphQL AST as JSON.
//!
//! @note
//!  This method doesn't handle GraphQL types.
//!
//! @seealso
//!   @[with_schema_support_to_json()]
//!
//! @param gql_src
//!  GraphQL input
{
  string raw = parent::to_json(gql_src);
  return Standards.JSON.decode(raw);
}

public mapping(string(8bit):mixed) with_schema_support_to_json(string gql_src) {
  string raw = parent::with_schema_support_to_json(gql_src);
  return Standards.JSON.decode(raw);
}

public enum node_kind {
  DOCUMENT_KIND = "Document",
  OPERATION_DEFINITION_KIND = "OperationDefinition",
  SELECTION_SET_KIND = "SelectionSet",
  ARGUMENT_KIND = "Argument",
  NAME_KIND = "Name",
  STRING_VALUE_KIND = "StringValue",
  INT_VALUE_KIND = "IntValue",
  FLOAT_VALUE_KIND = "FloatValue",
  BOOLEAN_VALUE_KIND = "BooleanValue",
  NULL_VALUE_KIND = "NullValue",
  OBJECT_VALUE_KIND = "ObjectValue",
  LIST_VALUE_KIND = "ListValue",
  ENUM_VALUE_KIND = "EnumValue",
  FIELD_KIND = "Field",
  NAMED_TYPE_KIND = "NamedType",
  VARIABLE_KIND = "Variable",
  VARIABLE_DEFINITION_KIND = "VariableDefinition",
  NON_NULL_TYPE_KIND = "NonNullType",
  FRAGMENT_SPREAD_KIND = "FragmentSpread",
  FRAGMENT_DEFINITION_KIND = "FragmentDefinition",
  DIRECTIVE_KIND = "Directive",
  // Schema types
  OBJECT_TYPE_DEFINITION_KIND = "ObjectTypeDefinition",
  FIELD_DEFINITION_KIND = "FieldDefinition",
  INPUT_VALUE_DEFINITION_KIND = "InputValueDefinition",
}

public bool is_kind(ast_mapping input, node_kind kind) {
  return mappingp(input) &&
    has_index(input, "kind") &&
    input->kind == kind;
}

public bool is_document(ast_mapping data) {
  return is_kind(data, DOCUMENT_KIND);
}

public bool has_node(ast_mapping data, string key) {
  return mappingp(data) &&
    has_index(data, key) &&
    data[key] != Val.null;
}

public bool has_name_node(ast_mapping data) {
  return has_node(data, "name") && mappingp(data->name);
}

public bool has_selection_set_node(ast_mapping data) {
  return has_node(data, "selectionSet") && mappingp(data->selectionSet);
}

public bool has_selections_node(ast_mapping data) {
  return has_node(data, "selections") && arrayp(data->selections);
}

public bool has_definitions_node(ast_mapping data) {
  return has_node(data, "definitions") && arrayp(data->definitions);
}

public bool has_arguments_node(ast_mapping data) {
  return has_node(data, "arguments") && arrayp(data->arguments);
}

public bool has_value_node(ast_mapping data) {
  return has_node(data, "value");
}
