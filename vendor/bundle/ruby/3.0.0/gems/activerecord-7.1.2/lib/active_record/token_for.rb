# frozen_string_literal: true

require "active_support/core_ext/object/json"

module ActiveRecord
  module TokenFor
    extend ActiveSupport::Concern

    included do
      class_attribute :token_definitions, instance_accessor: false, instance_predicate: false, default: {}
      class_attribute :generated_token_verifier, instance_accessor: false, instance_predicate: false
    end

    TokenDefinition = Struct.new(:defining_class, :purpose, :expires_in, :block) do # :nodoc:
      def full_purpose
        @full_purpose ||= [defining_class.name, purpose, expires_in].join("\n")
      end

      def message_verifier
        defining_class.generated_token_verifier
      end

      def payload_for(model)
        block ? [model.id, model.instance_eval(&block).as_json] : [model.id]
      end

      def generate_token(model)
        message_verifier.generate(payload_for(model), expires_in: expires_in, purpose: full_purpose)
      end

      def resolve_token(token)
        payload = message_verifier.verified(token, purpose: full_purpose)
        model = yield(payload[0]) if payload
        model if model && payload_for(model) == payload
      end
    end

    module ClassMethods
      # Defines the behavior of tokens generated for a specific +purpose+.
      # A token can be generated by calling TokenFor#generate_token_for on a
      # record. Later, that record can be fetched by calling #find_by_token_for
      # (or #find_by_token_for!) with the same purpose and token.
      #
      # Tokens are signed so that they are tamper-proof. Thus they can be
      # exposed to outside world as, for example, password reset tokens.
      #
      # By default, tokens do not expire. They can be configured to expire by
      # specifying a duration via the +expires_in+ option. The duration becomes
      # part of the token's signature, so changing the value of +expires_in+
      # will automatically invalidate previously generated tokens.
      #
      # A block may also be specified. When generating a token with
      # TokenFor#generate_token_for, the block will be evaluated in the context
      # of the record, and its return value will be embedded in the token as
      # JSON. Later, when fetching the record with #find_by_token_for, the block
      # will be evaluated again in the context of the fetched record. If the two
      # JSON values do not match, the token will be treated as invalid. Note
      # that the value returned by the block <b>should not contain sensitive
      # information</b> because it will be embedded in the token as
      # <b>human-readable plaintext JSON</b>.
      #
      # ==== Examples
      #
      #   class User < ActiveRecord::Base
      #     has_secure_password
      #
      #     generates_token_for :password_reset, expires_in: 15.minutes do
      #       # Last 10 characters of password salt, which changes when password is updated:
      #       password_salt&.last(10)
      #     end
      #   end
      #
      #   user = User.first
      #
      #   token = user.generate_token_for(:password_reset)
      #   User.find_by_token_for(:password_reset, token) # => user
      #   # 16 minutes later...
      #   User.find_by_token_for(:password_reset, token) # => nil
      #
      #   token = user.generate_token_for(:password_reset)
      #   User.find_by_token_for(:password_reset, token) # => user
      #   user.update!(password: "new password")
      #   User.find_by_token_for(:password_reset, token) # => nil
      def generates_token_for(purpose, expires_in: nil, &block)
        self.token_definitions = token_definitions.merge(purpose => TokenDefinition.new(self, purpose, expires_in, block))
      end

      # Finds a record using a given +token+ for a predefined +purpose+. Returns
      # +nil+ if the token is invalid or the record was not found.
      def find_by_token_for(purpose, token)
        raise UnknownPrimaryKey.new(self) unless primary_key
        token_definitions.fetch(purpose).resolve_token(token) { |id| find_by(primary_key => id) }
      end

      # Finds a record using a given +token+ for a predefined +purpose+. Raises
      # ActiveSupport::MessageVerifier::InvalidSignature if the token is invalid
      # (e.g. expired, bad format, etc). Raises ActiveRecord::RecordNotFound if
      # the token is valid but the record was not found.
      def find_by_token_for!(purpose, token)
        token_definitions.fetch(purpose).resolve_token(token) { |id| find(id) } ||
          (raise ActiveSupport::MessageVerifier::InvalidSignature)
      end
    end

    # Generates a token for a predefined +purpose+.
    #
    # Use ClassMethods#generates_token_for to define a token purpose and
    # behavior.
    def generate_token_for(purpose)
      self.class.token_definitions.fetch(purpose).generate_token(self)
    end
  end
end
