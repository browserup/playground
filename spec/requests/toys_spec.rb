# spec/requests/toys_spec.rb
require 'swagger_helper'

describe 'BrowserUp Playground - Toys API' do

  path '/api/toys' do

    get 'Retrieves all toys.' do
      consumes 'application/json'
      produces 'application/json'
      tags 'Toys'

      response '200', 'Toys found' do
        before { create_list(:toy, 2) }
        run_test!
      end
    end

    post 'Creates a toy' do
      tags 'Toys'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          toy: {
            type: :object,
            properties: {
              name: { type: :string, required: true, minLength: 1 },
              description: { type: :string }
            },
            required: ['name', 'description']
          }
        },
        required: ['toy']
      }
      
      response '200', 'toy created' do
        let(:params) { { name: "foo #{rand(999999999)}", description: 'bar' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:params) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/toys/{id}' do
    get 'Retrieves a toy' do
      tags 'Toys'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'

      response '200', 'toy found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string }
               },
               required: [ 'id', 'name', 'description' ]

        let(:id) { Toy.create(name: 'foo', description: 'bar').id }
        run_test!
      end

      delete 'Delete a toy.' do
        consumes 'application/json'
        produces 'application/json'
        tags 'Toys'
        parameter name: :id, in: :path, type: :string
        produces 'application/json'

        response '204', 'Destroy the toy' do
          let(:id) { create(:toy).id }
          run_test!
        end
      end

      response '404', 'toy not found' do
        let(:id) { '99999' }
        run_test!
      end

    end
  end
end
