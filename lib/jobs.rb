class Jobs
  def build_order(build_sequence)
    return '' if build_sequence.empty?
    visited = []
    stack = []

    build_sequence.keys.each do |key|
      next if visited.include?(key)
      visited << key
      find_dependencies(key, build_sequence).reverse.each do |dependency|
        next if visited.include?(dependency)
        visited << dependency
        stack << dependency
      end
      stack << key
    end

    stack.map(&:to_s).join
  end

  private

  def find_dependencies(key, sequence, visited=[])
    return [] if sequence[key].nil?
    raise RuntimeError if key == sequence[key]
    raise RuntimeError if visited.include?(key)
    [sequence[key]] + find_dependencies(sequence[key], sequence, visited + [key])
  end
end
