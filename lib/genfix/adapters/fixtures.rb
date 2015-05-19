require 'yaml'

module Genfix
  module Adapters
    class FixturesAdapter < DependencyBase
      attr_accessor :fixtures_path

      def adapter_name
        'fixtures'
      end

      def fixtures_path
        @fixtures_path ||= File.join(project_path, '.fixtures.yml')
      end

      # reads the fixtures file
      def read_source
        begin
          YAML.load_file(fixtures_path)
        rescue Errno::ENOENT
          data = { 'fixtures' => {'forge' => {}, 'repositories' => {}, 'symlinks' => {}}}
        end
      end


      # converts the adapter source file to the dependency format and returns an array of dependencies
      def to_dependency_format
        dependencies = []
        read_source['fixtures'].each do |type, values|
          values.each do |name, fix|
            if fix.instance_of?(String)
              uri = fix
              version = nil
            elsif fix.instance_of?(Hash)
              uri = fix['repo']
              version = fix['ref'] || fix['branch'] || fix['tag']
              version = version.split(',') unless version.nil?
            else
              raise 'What kind of format is this?'
            end
            case type
              when 'forge'
                source = Librarian::Puppet::Source::Forge.new(environment, 'https://forgeapi.puppetlabs.com' )
              when 'repositories'
                source = Librarian::Puppet::Source::Git.new(environment, uri, {:ref => version})
              when 'symlinks'
                if uri == '#{source_dir}'
                  path = project_path
                else
                  path = uri
                end
                source = Librarian::Puppet::Source::Path.new(environment, path, {})
              else
                raise("Unsupported dependency type #{type}")
            end
            dependencies << Librarian::Puppet::Dependency.new(name, version, source)
          end
        end
        dependencies
      end

      # outputs to puppetlabs_spec_helper format
      # {"fixtures"=>
      #    {"repositories"=>
      #       {"stdlib"=>"git://github.com/puppetlabs/puppetlabs-stdlib.git"},
      #     "symlinks"=>{"nonrootlib"=>"\#{source_dir}"}}}
      def to_source_format(dependencies)
        fixtures = {'forge' => {}, 'repositories' => {}, 'symlinks' => {}}
        dependencies.each do |d|
           case d.source.class.to_s
             when 'Librarian::Puppet::Source::Forge'
              fixtures['forge'].merge!({normalize_name(d.name) => {'repo' => d.name,
                                                                   'ref' => version_map(d.requirement.to_s)}})
            when 'Librarian::Puppet::Source::Git'
              fixtures['repositories'].merge!({normalize_name(d.name) => {'repo' => d.source.uri.to_s,
                                                                          'ref' => version_map(d.requirement.to_s)}})
             when 'Librarian::Puppet::Source::Path'
               if d.source.path == project_path
                 path = "\#{source_dir}"
               else
                 path = d.source.path
               end
              fixtures['symlinks'].merge!({normalize_name(d.name) => path })
            else
              raise("Unsupported fixture type #{d.source.class.to_s}")
          end
        end
        {'fixtures' => fixtures}.to_yaml
      end

      # overwrites the current source file with the supplied data
      def write_to_source(dependencies)
        File.open(fixtures_path, 'w') do |file|
          file.write(to_source_format(dependencies))
        end
      end

      # used to map dependency requirements to a specific version
      def version_map(req)
        oper, ver = req.split(" ")
        case oper
          when '>='
            nil
          when '='
            ver
          when '~>'
            ver
          when '<='
            ver
          else
            req
        end
      end

      def self.to_source_format(dependencies, project_path)
        FixturesAdapter.new(project_path).to_source_format(dependencies)
      end

      def self.write_to_source(dependencies, project_path)
        FixturesAdapter.new(project_path).write_to_source(dependencies)
      end
    end
  end
end
