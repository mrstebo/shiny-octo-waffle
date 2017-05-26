require 'tsort'
require_relative 'circular_dependency_error'
require_relative 'self_dependency_error'

class Jobs
  def build_order(build_sequence)
    return '' if build_sequence.empty?
    hash = convert_to_tsortable_hash(build_sequence)
    TSortableHash[hash].tsort.map(&:chr).join
  end

  private

  def convert_to_tsortable_hash(build_sequence)
    build_sequence.inject({}) do |x, (k, _)|
      x[k.to_s.ord] = find_dependencies(k, build_sequence).map(&:to_s).map(&:ord)
      x
    end
  end

  def find_dependencies(job, build_sequence, visited=[])
    return [] if build_sequence[job].nil?
    raise SelfDependenyError, "#{job} cannot depend on itself" if job == build_sequence[job]
    raise CircularDependenyError, "#{job} is a circular dependency" if visited.include?(build_sequence[job])
    [build_sequence[job]] + find_dependencies(build_sequence[job], build_sequence, visited + [job])
  end

  class TSortableHash < Hash
    include TSort
    alias tsort_each_node each_key
    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end
end
