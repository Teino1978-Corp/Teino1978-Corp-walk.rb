module Walk

  refine Array do
    def walk(inner_f, outer_f)
      outer_f.(self.map(&inner_f))
    end
  end

  refine Hash do
    def walk(inner_f, outer_f)
      outer_f.(self.map(&inner_f).to_h)
    end
  end

  refine Object do
    def walk(_inner_f, outer_f)
      outer_f.(self)
    end
  end

  using self

  def self.walk(inner_f, outer_f, object)
    object.walk(inner_f, outer_f)
  end

  def self._postwalk(f, object)
    g = self.method(:_postwalk).curry.(f)
    walk(g, f, object)
  end

  def self.postwalk(object, &block)
    _postwalk(block, object)
  end

  def self._prewalk(f, object)
    g = self.method(:_prewalk).curry.(f)
    walk(g, :itself.to_proc, f.(object))
  end

  def self.prewalk(object, &block)
    _prewalk(block, object)
  end

end