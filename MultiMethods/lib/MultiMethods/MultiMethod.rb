module MultiMethodAccs

  def method_missing selector, *args
    print "\nMethod Missing, soy: #{self}, selector: #{selector}"
    if respond_to? selector then
      exec_method selector, *args
    else
      super
    end
  end

  def exec_method selector, *args
    print "\nExec, soy: #{self}, selector: #{selector}"
    method = get_method selector, *args
    #Definir el método
    self.define_singleton_method selector, &method
    #Mandar el mensaje
    value = self.send selector, *args
    #Borrar el método
    self.singleton_class.send :remove_method, selector
    value
  end

  def get_method selector, *args
    print "\nGet, soy: #{self}, selector: #{selector}"
    #finder = hash[selector]
    finder = get_finder selector
    # if finder.nil? then
    #   finder = father?
    # end
    method = finder.get_method *args
    if method.nil? then
      method = father.get_method selector, *args
    end
    method
    end
end

module MultiMethod

  include MultiMethodAccs

  def self.included(a_class)
    a_class.extend MultiMethodClassMethods
    a_class.extend MultiMethodAccs
  end

  def inst_methods #Delega en la clase la responsabilidad del atributo.
    self.class.inst_methods
  end

  def respond_to_missing? method, *args
    (inst_methods.has_key? method) || (father.respond_to? method)
  end

  def get_finder selector
    finder = inst_methods[selector]
    if finder.nil? then
      finder = super
    end
    finder
  end

  def father
    self.class.father.new
  end

end

module MultiMethodClassMethods

  attr_accessor :inst_methods, :class_methods

  def inst_methods #Hash de métodos para la instancia, el value es un finder
    @inst_methods ||= {}
  end

  def class_methods #Hash de métodos para la clase, el value es un finder
    @class_methods ||= {}
  end

  def multimethod selector, &block
    multimethod_acc selector, inst_methods, &block
  end

  def self_multimethod selector, &block
    multimethod_acc selector, class_methods, &block
  end

  def multimethod_acc selector, hash, &block
    finder = MultiMethodFinder.new &block #Crea el finder que evalúa el bloque
    hash.store(selector, finder)
  end

  def respond_to_missing? method, *args
    (class_methods.has_key? method) || (father.respond_to? method)
  end

  def get_finder selector
    finder = class_methods[selector]
    if finder.nil? then
      finder = father.get_finder selector
    end
    finder
  end

  def father
    ancestors[1]
  end

end




class MultiMethodFinder

  def initialize &block
    self.instance_exec &block
  end

  def signatures #Constituido por la lista (firma) como key y el bloque como valor
    @signatures ||= {}
  end

  def define_for *args, &block
    signatures.store *args, block
  end

  def get_method *args
    behaviour = signatures.find {|signature| is_a_match? signature.first, *args}
    if !behaviour.nil? then
      behaviour = behaviour.last
    end
    behaviour
  end

  def is_a_match? signature, *args
    self.all_with_index? args, proc{|arg, i| match? signature[i], arg}
  end

  def all_with_index? list, block
    boolean = true
    for i in 0..list.size
      boolean = boolean && block.call(list[i], i)
    end
    boolean
  end

  def match? param, arg
    if param.is_a? Proc then
      param.call(arg)
    elsif param.is_a? Module then
      arg.is_a? param
    else
      arg.eql? param
    end
  end

  def duck *selectors
    Proc.new {|instance| selectors.all? {|selector| instance.respond_to? selector }}
  end
end