require 'genfix/dependency_base'
require 'genfix/adapters/fixtures'
require 'genfix/adapters/librarian'
require 'librarian/dependency'

module Genfix
  # gathers a list of dependencies from all adapters and merges them into one big dependency list
  # the list of resources:
  #
  # 2. .fixtures.yml if using puppetlabs_spec_helper
  def self.list_all(project_dir)
    deps = {}
    # once the adapters are loaded we can see which adapters are available
    # and iterate over all of them getting a list of dependencies.
    Adapters.constants.each do |adapter|
      klass = Adapters.const_get(adapter)
      k = klass.new(project_dir)
      deps[adapter] = k.list
    end
    deps
  end

  # only works with fixtures and librarian adapters
  def self.merged_list(project_dir)
    deps = list_all(project_dir).values.flatten
    #Librarian::Dependency.remove_duplicate_dependencies(deps)
  end

  def self.adapter_types
    Adapters.constants
  end

  def self.to_fixtures_format(project_dir)
    Genfix::Adapters::FixturesAdapter.to_source_format(merged_list(project_dir), project_dir)
  end

  def self.list_from_type(project_dir,type)
    klass = Adapters.const_get(type)
    k = klass.new(project_dir)
    k.list
  end

  # # merge dependencies with the same name into one
  # # with the source of the first one and merged requirements
  # def self.merge_dependencies(dependencies)
  #   requirement = Dependency::Requirement.new(*dependencies.map{|d| d.requirement})
  #   dependencies.last.class.new(dependencies.last.name, requirement, dependencies.last.source)
  # end
  #
  # # Avoid duplicated dependencies with different sources or requirements
  # # Return [merged dependnecies, duplicates as a map by name]
  # def self.remove_duplicate_dependencies(dependencies)
  #   uniq = []
  #   duplicated = {}
  #   dependencies_by_name = dependencies.group_by{|d| d.name}
  #   dependencies_by_name.map do |name, dependencies_same_name|
  #     if dependencies_same_name.size > 1
  #       duplicated[name] = dependencies_same_name
  #       uniq << merge_dependencies(dependencies_same_name)
  #     else
  #       uniq << dependencies_same_name.first
  #     end
  #   end
  #   [uniq, duplicated]
  # end

end
