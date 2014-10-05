require_relative '../../lib/MultiMethods/MultiDispatch'
class StringUtils
  include MultiDispatch

  multimethod :concat do
    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Integer] do |s, n|
      s * n
    end

    define_for [Array] do |a|
      a.join
    end

  end

  multimethod :concat2 do
    define_for [nil] do |o|
      nil
    end

    define_for [String, -1] do |s, n|
      s.reverse
    end

    define_for [String, proc{|o| o.odd? or o == 42}] do |s, n|
      true
    end

    define_for [String, Integer] do |s, n|
      s * n
    end
  end

  multimethod :concat3 do
    define_for [String, duck(:nombre, :apellido)] do |s, p|
      "#{s} #{p.nombre} #{p.apellido}!"
    end

    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Integer] do |s, n|
      s * n
    end
  end

  self_multimethod :concat do
    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Integer] do |s, n|
      s * n
    end
  end

  multimethod :concat5 do
    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Integer] do |s, n|
      s * n
    end
  end

end

class SuperStringUtils < StringUtils

  multimethod :concat5 do
    define_for [String, String] do |s1, s2|
      s2 + s1
    end

    define_for [String, Array] do |s, a|
      a.join s
    end
  end

end

class SuperSuperStringUtils < SuperStringUtils

end

class Persona

  attr_accessor :nombre, :apellido

  def initialize
    @nombre="Johan Sebastian"
    @apellido="Mastropiero"
  end
end