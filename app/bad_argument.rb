class BadArgument

  def too_many_args(arg1, argdqsdqs, argdqsdq)
  end

  def good_args(arg1, arg2)
  end

  def test
  end

  def arg_is_not_a_boolean(arg1, arg2)
    arg1 = arg1 *2
    if arg1
      arg2
    else
      nil
    end
  end

  def arg_is_a_boolean(arg1, arg2)
    if arg1
      arg2
    else
      nil
    end
  end

  def complex_method(arg1, arg2)
    arg1 = arg1 * 3
    if arg1 > 20
      arg1 = arg2 + arg1
    else
      arg1 = arg2 - arg1
    end
    array = [1,2,3]
    array.each do |array|
      array + arg1
    end
    arg1 = arg1 + 1
    arg1
  end

  def law_of_demeters(arg1)
    arg1.call1.call2.call3
  end

  #
  # Commented code
  # blablab
  # blabla
  #

end

class TestClass
  def too_many_args(arg1, arg2, arg3)
  end
end