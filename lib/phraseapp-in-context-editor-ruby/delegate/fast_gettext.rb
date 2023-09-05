require_relative "../delegate"

module PhraseApp
  module InContextEditor
    module Delegate
      class FastGettext < Base
        def initialize(method, *args)
          @method = method
          params = params_from_args(args)
          @display_key = params[:msgid]
        end

        private

        def params_from_args(args)
          case @method
          when :_
            {msgid: args.first}
          when :n_
            {msgid: args.first, msgid_plural: args[1], count: args.last}
          when :s_
            {msgid: args.first}
          else
            self.class.log("Unsupported FastGettext method #{@method}")
            {}
          end
        end
      end
    end
  end
end
