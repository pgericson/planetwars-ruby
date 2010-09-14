class Array
  def avg
    return 0 if self.empty?
    self.inject(0) {|t, i| t + i} / self.size
  end
end

