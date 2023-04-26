module Mutations
  # Note; the generated one was a problem and I had to replage it!
  # see here:  https://stackoverflow.com/questions/60458080/graphql-mutation-error-field-createuser-is-missing-required-arguments-input

  class BaseMutation < GraphQL::Schema::Mutation
    null false
  end

end
