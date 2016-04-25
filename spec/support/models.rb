module Spec
  module Support
    module Models

      class << self

        def create_messages_model
          ModelBuilder.build 'Message', {
              attributes: {body: :string},
              validates: [:body, presence: true]
          }

          Message
        end

      end

    end
  end
end