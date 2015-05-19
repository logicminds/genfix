require 'spec_helper'
require 'genfix/adapters/librarian'

describe "Genfix::Adapters::LibrarianAdapter" do

  before :each do
    FileUtils.rm_f(File.join(test_module_dir, 'Puppetfile'))
    FileUtils.rm_f(File.join(test_module_dir, 'Puppetfile.lock'))

  end

  let(:formatted_dependencies) do
    []
  end

  let(:subject) { Genfix::Adapters::LibrarianAdapter.new(test_module_dir)}


  describe '#to_dependency_format' do
    it 'returns array' do
      expect(subject.to_dependency_format).to eq(subject.list)
    end
  end

  it '#adapter_name' do
    expect(subject.adapter_name).to eq('librarian')
  end

  it '#read_source' do
    data = subject.read_source
    expect(data).to be_instance_of(Array)
  end

end

