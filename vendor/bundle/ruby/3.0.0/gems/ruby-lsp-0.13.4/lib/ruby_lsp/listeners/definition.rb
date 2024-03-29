# typed: strict
# frozen_string_literal: true

module RubyLsp
  module Listeners
    class Definition < Listener
      extend T::Sig
      extend T::Generic

      ResponseType = type_member { { fixed: T.nilable(T.any(T::Array[Interface::Location], Interface::Location)) } }

      sig { override.returns(ResponseType) }
      attr_reader :_response

      sig do
        params(
          uri: URI::Generic,
          nesting: T::Array[String],
          index: RubyIndexer::Index,
          dispatcher: Prism::Dispatcher,
          typechecker_enabled: T::Boolean,
        ).void
      end
      def initialize(uri, nesting, index, dispatcher, typechecker_enabled)
        @uri = uri
        @nesting = nesting
        @index = index
        @typechecker_enabled = typechecker_enabled
        @_response = T.let(nil, ResponseType)

        super(dispatcher)

        dispatcher.register(
          self,
          :on_call_node_enter,
          :on_constant_read_node_enter,
          :on_constant_path_node_enter,
        )
      end

      sig { params(node: Prism::CallNode).void }
      def on_call_node_enter(node)
        message = node.name

        if message == :require || message == :require_relative
          handle_require_definition(node)
        else
          handle_method_definition(node)
        end
      end

      sig { params(node: Prism::ConstantPathNode).void }
      def on_constant_path_node_enter(node)
        find_in_index(node.slice)
      end

      sig { params(node: Prism::ConstantReadNode).void }
      def on_constant_read_node_enter(node)
        find_in_index(node.slice)
      end

      private

      sig { params(node: Prism::CallNode).void }
      def handle_method_definition(node)
        return unless self_receiver?(node)

        message = node.message
        return unless message

        target_method = @index.resolve_method(message, @nesting.join("::"))
        return unless target_method

        location = target_method.location
        file_path = target_method.file_path
        return if @typechecker_enabled && not_in_dependencies?(file_path)

        @_response = Interface::Location.new(
          uri: URI::Generic.from_path(path: file_path).to_s,
          range: Interface::Range.new(
            start: Interface::Position.new(line: location.start_line - 1, character: location.start_column),
            end: Interface::Position.new(line: location.end_line - 1, character: location.end_column),
          ),
        )
      end

      sig { params(node: Prism::CallNode).void }
      def handle_require_definition(node)
        message = node.name
        arguments = node.arguments
        return unless arguments

        argument = arguments.arguments.first
        return unless argument.is_a?(Prism::StringNode)

        case message
        when :require
          entry = @index.search_require_paths(argument.content).find do |indexable_path|
            indexable_path.require_path == argument.content
          end

          if entry
            candidate = entry.full_path

            @_response = Interface::Location.new(
              uri: URI::Generic.from_path(path: candidate).to_s,
              range: Interface::Range.new(
                start: Interface::Position.new(line: 0, character: 0),
                end: Interface::Position.new(line: 0, character: 0),
              ),
            )
          end
        when :require_relative
          required_file = "#{argument.content}.rb"
          path = @uri.to_standardized_path
          current_folder = path ? Pathname.new(CGI.unescape(path)).dirname : Dir.pwd
          candidate = File.expand_path(File.join(current_folder, required_file))

          @_response = Interface::Location.new(
            uri: URI::Generic.from_path(path: candidate).to_s,
            range: Interface::Range.new(
              start: Interface::Position.new(line: 0, character: 0),
              end: Interface::Position.new(line: 0, character: 0),
            ),
          )
        end
      end

      sig { params(value: String).void }
      def find_in_index(value)
        entries = @index.resolve(value, @nesting)
        return unless entries

        # We should only allow jumping to the definition of private constants if the constant is defined in the same
        # namespace as the reference
        first_entry = T.must(entries.first)
        return if first_entry.visibility == :private && first_entry.name != "#{@nesting.join("::")}::#{value}"

        @_response = entries.filter_map do |entry|
          location = entry.location
          # If the project has Sorbet, then we only want to handle go to definition for constants defined in gems, as an
          # additional behavior on top of jumping to RBIs. Sorbet can already handle go to definition for all constants
          # in the project, even if the files are typed false
          file_path = entry.file_path
          next if @typechecker_enabled && not_in_dependencies?(file_path)

          Interface::Location.new(
            uri: URI::Generic.from_path(path: file_path).to_s,
            range: Interface::Range.new(
              start: Interface::Position.new(line: location.start_line - 1, character: location.start_column),
              end: Interface::Position.new(line: location.end_line - 1, character: location.end_column),
            ),
          )
        end
      end
    end
  end
end
