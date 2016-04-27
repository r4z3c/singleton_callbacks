module SingletonCallbacks extend ActiveSupport::Concern

  SUBSTITUTE_METHOD_PREFIX = 'complex_'
  ORIGINAL_METHOD_PREFIX = 'original_'

  included do |base|
    base.class_eval do

      @callbacks = { before: [], after: [] }

      class << self

        def before(method_sym, callback_sym, options=nil)
          setup_callback :before, method_sym, callback_sym, options
        end

        def after(method_sym, callback_sym, options=nil)
          setup_callback :after, method_sym, callback_sym, options
        end

        private

        def setup_callback(callback_type, method_sym, callback_sym, options)
          add_to_callback_list callback_type, method_sym, callback_sym, options
          replace_original_method method_sym
        end

        def add_to_callback_list(callback_type, method_sym, callback_sym, options)
          @callbacks[callback_type] << {
              method_sym: method_sym,
              callback_sym: callback_sym,
              options: options
          }
        end

        def eval_as_singleton
          self.singleton_class.class_eval &Proc.new if block_given?
        end

        def replace_original_method(method_sym)
          substitute_method_name = substitute_method_name_for method_sym
          return if substitute_method_already_exists? substitute_method_name

          save_original_method method_sym
          create_substitute_method method_sym, substitute_method_name
          eval_as_singleton { alias_method method_sym, substitute_method_name }
        end

        def substitute_method_name_for(method_sym)
          "#{SingletonCallbacks::SUBSTITUTE_METHOD_PREFIX}#{method_sym}"
        end

        def substitute_method_already_exists?(substitute_method_name)
          already_exists = true
          eval_as_singleton { already_exists = method_defined? substitute_method_name }
          already_exists
        end

        def save_original_method(method_sym)
          original_method_sym = original_method_name_for(method_sym).to_sym
          eval_as_singleton { alias_method original_method_sym, method_sym }
        end

        def original_method_name_for(method_sym)
          "#{SingletonCallbacks::ORIGINAL_METHOD_PREFIX}#{method_sym}"
        end

        def create_substitute_method(method_sym, substitute_method_name)
          eval_as_singleton do
            define_method substitute_method_name do
              execute_callbacks_for :before, method_sym
              r = send original_method_name_for(method_sym)
              execute_callbacks_for :after, method_sym
              r
            end
          end
        end

        def execute_callbacks_for(callback_type, method_sym)
          @callbacks[callback_type].select{ |c| c[:method_sym].eql? method_sym }.each do |callback|
            send callback[:callback_sym]
          end
        end

      end
    end
  end

end