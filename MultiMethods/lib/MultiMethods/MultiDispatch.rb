module MultiDispatch

  def self.included(a_class)
    a_class.extend MultiDispatchClassMethods
    a_class.extend MultiDispatchAccessories
    a_class.send :include, MultiDispatchAccessories
  end

  def method_missing method, *args
    print "\nMetodo: #{method}"
    method_missing_acc method, inst_methods, *args
  end

  # def method_missing method, *args
  #   if respond_to? method then
  #     method_missing_acc method, inst_methods, *args
  #   else
  #     super
  #   end
  # end

  def respond_to_missing? method, *args
    respond? method, inst_methods or (padre.inst_methods.has_key? method)
  end

  def inst_methods
    self.class.inst_methods
  end

  def padre
    self.class.padre
  end
end

module MultiDispatchAccessories


  # def method_missing_acc method, hash, *args
  #     finder = hash.find{|elem| elem.first == method}
  #     if finder.nil? then
  #       behaviour = padre.get_match method, *args
  #       behaviour.call(args)
  #     else
  #       finder = finder.last
  #       call_behaviour finder, method, *args
  #     end
  # end


  def method_missing_acc method, hash, *args
    if respond_to? method.to_sym then
      finder = hash.find{|elem| elem.first == method}
      if finder.nil? then
        behaviour = padre.get_match method, *args
        self.instance_exec(args, &behaviour)
      else
      finder = finder.last
      call_behaviour finder, method, *args
      end
    else
      raise NoMethodError
    end
  end

  def call_behaviour finder, method, *args
    behaviour = finder.find_match args
    if behaviour.nil? then
      behaviour = padre.get_match method, *args
    end

    self.define_singleton_method method, behaviour
    self.send method, *args
    # borrar metodo
    # self.instance_exec(args, &behaviour)
  end

  def respond? method, hash
    hash.has_key?(method.to_sym)
  end
end

module MultiDispatchClassMethods

  def inst_methods
    @instance_methods ||= {}
  end

  def class_methods
    @class_methods ||= {}
  end

  def multimethod selector, &block
    create_multimethod selector, inst_methods, &block
  end

  def self_multimethod selector, &block
    create_multimethod selector, class_methods, &block
  end

  def create_multimethod selector, hash, &block
    finder = Finder.new
    finder.instance_exec(&block)
    hash.store(selector, finder)
  end

  def method_missing method, *args
    method_missing_acc method, class_methods, *args
  end

  # def method_missing method, *args
  #   if respond_to? method then
  #     method_missing_acc method, inst_methods, *args
  #   else
  #     super
  #   end
  # end


  def respond_to_missing? method, *args, &block
    respond? method, class_methods
  end

  def instance_respond_to? method
    self.new.respond_to? method
  end

  def get_match method, *args
    finder = inst_methods.find{|elem| elem.first == method}
    if !finder.nil? then
      finder = finder.last
      behaviour = finder.find_match args
      if !behaviour.nil? then
        behaviour
      else
        padre.get_match method, *args
      end
    else
      padre.get_match method, *args
    end
  end

  def padre
    ancestors[1]
  end
end



class Finder

  attr_accessor :signatures

  def signatures
    @signatures ||= {}
  end

  def define_for *params, &block
    signatures.store(*params,block)
  end

  def find_match *params
    #print("Las firmas son: #{signatures} y los parametros son: #{params}")
    finded = self.signatures.find {|signature| self.is_a_match?(signature.first, *params)}
    if !finded.nil? then
      finded =finded.last
    end
    finded
  end

  def is_a_match? (signature, params)
    #print("La firma es: #{signature} y los parametros son: #{params}")
    boolean = true
    for i in 0..signature.size
      boolean = boolean && (self.match signature[i], params[i])
    end
    boolean
  end

  def match elem, parameter
    #print("El elemento es: #{elem} y el parametro es: #{parameter}")
    if elem.is_a? Proc then
      elem.call parameter
    elsif elem.is_a? Class then
      parameter.is_a? elem
    else
      elem == parameter
    end
  end

  def duck *selectors
    Proc.new {|instance| selectors.all? {|selector| instance.respond_to? selector } }
  end
end