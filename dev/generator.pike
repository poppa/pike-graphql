
constant gql_query = #"
  query Basic($id: int = 3) {
    human(id: $id) {
      name
      height
    }
  }
";

int main() {
  Parser.GraphQL.ast_mapping res = Parser.GraphQL.to_json(gql_query);

  if (Parser.GraphQL.is_document(res)) {
    Parser.GraphQL.remove_locations(res);
    werror("%O\n", res);
  } else {
    werror("Result is not a GraphQL document\n");
  }
}
