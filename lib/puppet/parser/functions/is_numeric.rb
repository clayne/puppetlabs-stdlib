# frozen_string_literal: true

#
# is_numeric.rb
#
module Puppet::Parser::Functions
  newfunction(:is_numeric, type: :rvalue, doc: <<-DOC
    @summary
      **Deprecated:** Returns true if the given value is numeric.

    Returns true if the given argument is a Numeric (Integer or Float),
    or a String containing either a valid integer in decimal base 10 form, or
    a valid floating point string representation.

    The function recognizes only decimal (base 10) integers and float but not
    integers in hex (base 16) or octal (base 8) form.

    The string representation may start with a '-' (minus). If a decimal '.' is used,
    it must be followed by at least one digit.

    @return [Boolean]
      Returns `true` or `false`

    > **Note:* **Deprecated** Will be removed in a future version of stdlib. See
    [`validate_legacy`](#validate_legacy).
    DOC
  ) do |arguments|
    function_deprecation([:is_numeric, 'This method is deprecated, please use the stdlib validate_legacy function,
                          with Stdlib::Compat::Numeric. There is further documentation for validate_legacy function in the README.'])

    if arguments.size != 1
      raise(Puppet::ParseError, "is_numeric(): Wrong number of arguments given #{arguments.size} for 1")
    end

    value = arguments[0]

    # Regex is taken from the lexer of puppet
    # puppet/pops/parser/lexer.rb but modified to match also
    # negative values and disallow invalid octal numbers or
    # numbers prefixed with multiple 0's (except in hex numbers)
    #
    # TODO these parameters should be constants but I'm not sure
    # if there is no risk to declare them inside of the module
    # Puppet::Parser::Functions

    # TODO: decide if this should be used
    # HEX numbers like
    # 0xaa230F
    # 0X1234009C
    # 0x0012
    # -12FcD
    # numeric_hex = %r{^-?0[xX][0-9A-Fa-f]+$}

    # TODO: decide if this should be used
    # OCTAL numbers like
    # 01234567
    # -045372
    # numeric_oct = %r{^-?0[1-7][0-7]*$}

    # Integer/Float numbers like
    # -0.1234568981273
    # 47291
    # 42.12345e-12
    numeric = %r{^-?(?:(?:[1-9]\d*)|0)(?:\.\d+)?(?:[eE]-?\d+)?$}

    if value.is_a?(Numeric) || (value.is_a?(String) &&
      value.match(numeric) # or
                                 #  value.match(numeric_hex) or
                                 #  value.match(numeric_oct)
                               )
      return true
    else
      return false
    end
  end
end
