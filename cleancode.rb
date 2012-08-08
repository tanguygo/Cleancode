require 'ruby_parser'

module CleanCode
  class Checker

    def initialize(file)
      @file = file
      file_content = File.open(file).read
      @ruby_parser = RubyParser.new.parse(file_content)
      recursive_call(@ruby_parser)
    end

    def recursive_call(sexps)
      set_current_class(sexps)
      set_current_method(sexps)
      set_current_args(sexps)
      remove_args_from_current_args_if_changed(sexps)
      sexps.each do |sexp|
        if sexp.kind_of? Sexp
          check_for_too_many_args(sexp)
          check_for_boolean_in_args(sexp)
          check_for_complexity(sexp)
          check_for_law_of_demeter(sexp)
          recursive_call(sexp)
        end
      end
    end

    def set_current_class(sexps)
      @current_class = sexps.sexp_body.first if sexps.node_type == :class
    end    

    def set_current_method(sexps)
      if sexps.node_type == :defn
        @current_method = sexps.sexp_body.first 
      end
    end

    def set_current_args(sexps)
      @current_args = sexps.entries if args_definition?(sexps)
    end

    def check_for_too_many_args(sexp)
      if args_definition?(sexp) && too_many_args?(sexp)
        puts "#{@file}: Warning, too many arguments found in class #{@current_class} for #{@current_method}"
        puts "#{@file}: Maximum 3 arguments per method recommended."
      end
    end

    def args_definition?(sexp)
      sexp.node_type == :args
    end

    def too_many_args?(sexp)
      sexp.entries.size > 3
    end

    def check_for_boolean_in_args(sexp)
      if if_definition?(sexp) && arg_used_in_if?(sexp)
        puts "#{@file}: Warning, an argument is used as a boolean #{@current_class} for #{@current_method}"
        puts "#{@file}: Split this method in 2 cases. One for the true, one for the false."
      end
    end

    def if_definition?(sexp)
      sexp.node_type == :if
    end

    def arg_used_in_if?(sexp)
      sexp.sexp_body.first.node_type == :lvar && @current_args.include?(sexp.sexp_body.first.sexp_body.to_sym)
    end

    def remove_args_from_current_args_if_changed(sexps)
      if sexps.node_type == :lasgn
        @current_args.delete(sexps.sexp_body.first)
      end
    end

    def check_for_complexity(sexp)
      if sexp.node_type == :defn && sexp.mass > 40
        puts "#{@file}: Warning, the method #{@current_method} in #{@current_class} is too complex (mass: #{sexp.mass})"
        puts "#{@file}: Split this method with the extract method refactoring pattern."
      end
    end

    def check_for_law_of_demeter(sexp)
      if is_a_call_statement?(sexp)
        second_call = sexp.sexp_body.first
        if is_a_call_statement?(second_call)
          third_call = second_call.sexp_body.first
          if is_a_call_statement?(third_call) && @current_method != @last_check_for_demeter
            @last_check_for_demeter = @current_method
            puts "#{@file}: Warning, the call in #{@current_method} in #{@current_class} violate the law of demeter"
            puts "#{@file}: Use the principe of 'Ask, don't tell."
          end
        end
      end
    end

    def is_a_call_statement?(sexp)
      sexp && sexp.node_type == :call
    end
  end

  class Parser

    def initialize
      d = Dir["./**/*.rb"]
      d.each do |file|
          puts "checking : #{file}"
          puts '=================='
          Checker.new(file)
      end
    end

  end
end

CleanCode::Parser.new