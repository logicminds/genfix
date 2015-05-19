require 'spec_helper'
require 'genfix/adapters/fixtures'

describe "Genfix::Adapters::FixturesAdapter" do

  let(:subject) { Genfix::Adapters::FixturesAdapter.new(test_module_dir)}
  let(:environment) { Librarian::Puppet::Environment.new }
  let(:uri) { "https://forge.puppetlabs.com" }
  let(:source) { Librarian::Puppet::Source::Forge.new(environment, uri) }
  let(:blank_fixtures) { { 'fixtures' => {'forge' => {}, 'repositories' => {}, 'symlinks' => {}}} }
  let(:formatted_dependencies) do
   [Librarian::Puppet::Dependency.new('puppetlabs-stdlib', ["< 5.0.0"," >= 3.1.1"], source),
    Librarian::Puppet::Dependency.new('puppetlabs-concat', ["< 2.0.0"," >= 1.1.1"], source)]
  end

  let(:formatted_dependency_fixtures) do
    "---\nfixtures:\n  forge:\n    stdlib:\n      repo: puppetlabs-stdlib\n      ref: < 5.0.0, >= 3.1.1\n    concat:\n      repo: puppetlabs-concat\n      ref: < 2.0.0, >= 1.1.1\n  repositories: {}\n  symlinks: {}\n"
  end

  let(:fixture_data) do {
    "fixtures" => {"repositories"=>{"stdlib"=>{'repo' => "git://github.com/puppetlabs/puppetlabs-stdlib.git", 'ref' => "< 5.0.0, >= 3.1.1"},
                                    "chocolatey"=>"https://github.com/chocolatey/puppet-chocolatey.git",
                                    "powershell"=>"https://github.com/joshcooper/puppetlabs-powershell.git",
                                    "staging"=>"https://github.com/nanliu/puppet-staging.git",
                                    "helper"=>"https://github.com/bodeco/bodeco_module_helper.git",
                                    "pe_gem"=>{"repo"=>"https://github.com/puppetlabs/puppetlabs-pe_gem.git",
                                               "ref"=>"0.1.0"},
                                    "concat"=>{"repo"=>"git://github.com/puppetlabs/puppetlabs-concat.git", "branch"=>"1.2.x"},
                                    "portage"=>"git://github.com/gentoo/puppet-portage.git"},
                   "symlinks"=>{"apache"=>"\#{source_dir}"} }
  }
  end

  let(:produced_fixture_data) do
    "---\nfixtures:\n  forge: {}\n  repositories:\n    stdlib:\n      repo: git://github.com/puppetlabs/puppetlabs-stdlib.git\n      ref: \n    chocolatey:\n      repo: https://github.com/chocolatey/puppet-chocolatey.git\n      ref: \n    powershell:\n      repo: https://github.com/joshcooper/puppetlabs-powershell.git\n      ref: \n    staging:\n      repo: https://github.com/nanliu/puppet-staging.git\n      ref: \n    helper:\n      repo: https://github.com/bodeco/bodeco_module_helper.git\n      ref: \n    pe_gem:\n      repo: https://github.com/puppetlabs/puppetlabs-pe_gem.git\n      ref: 0.1.0\n    concat:\n      repo: git://github.com/puppetlabs/puppetlabs-concat.git\n      ref: 1.2.0\n    portage:\n      repo: git://github.com/gentoo/puppet-portage.git\n      ref: \n  symlinks:\n    apache: '\#{source_dir}'\n"
  end
  describe '#to_dependency_format' do
    it 'returns 9 elements' do
      allow(subject).to receive(:read_source).and_return(fixture_data)
      expect(subject.to_dependency_format.count).to eq(9)
    end

    it 'returns 0 elements' do
      allow(subject).to receive(:read_source).and_return(blank_fixtures)
      expect(subject.to_dependency_format.count).to eq(0)
    end

    it 'produces identical fixture data when converting from and to' do
      allow(subject).to receive(:read_source).and_return(fixture_data)
      dependencies = subject.to_dependency_format
      expect(subject.to_source_format(dependencies)).to eq(produced_fixture_data)
    end
  end

  it '#adapter_name' do
    expect(subject.adapter_name).to eq('fixtures')
  end

  it '#fixtures_path' do
    expect(subject.fixtures_path).to include('fixtures/modules/puppetlabs-apache/.fixtures.yml')
  end

  it '#read_source' do
    data = subject.read_source
    expect(data).to be_instance_of(Hash)
  end

  it '#read_source returns {} when fixtures does not exist' do
    allow(YAML).to receive(:load_file).and_raise(Errno::ENOENT)
    expect(subject.read_source).to eq(blank_fixtures)
  end

  it '#to_source_format' do
     expect(subject.to_source_format(formatted_dependencies)).to eq(formatted_dependency_fixtures)
  end

  xit '#write_to_source' do
     fixtures_file = File.join(test_module_dir, '.fixtures.yml')
     file = double('file')
     allow(:File).to receive(:open).with(fixtures_file, "w").and_yield(file)
     allow(file).to receive(:write).with("text")
     subject.write_to_source(formatted_dependencies)
  end
end
