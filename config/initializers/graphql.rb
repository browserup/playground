initial_query = <<-INITIAL_QUERY
  # Welcome to the BrowserUp GraphQL Toy Playground. 
  # The documentation explorer button on the top left will show
  # you the schema and the doc for queries and mutations. 
  # 
  # Keyboard shortcuts:
  #  Run Query:  Ctrl-Enter (or press the play button)
  #  Auto Complete:  Ctrl-Space (or just start typing)

  {
    newToys
    {
      id
  	  name
  	  description
    }
  }

INITIAL_QUERY

GraphiQL::Rails.config.initial_query = initial_query
