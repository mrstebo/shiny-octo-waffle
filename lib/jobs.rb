class Jobs
  def build_order(build_sequence)
    return '' if build_sequence.empty?
    build_sequence.keys.map(&:to_s).join
  end
end
