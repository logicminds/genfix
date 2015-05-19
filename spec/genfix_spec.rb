require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'spec_helper'

describe "Genfix" do

  it '#list_all' do
     expect(Genfix.list_all(test_module_dir).count).to eq(2)
  end

  it '#adapter_types' do
    expect(Genfix.adapter_types).to eq([:FixturesAdapter, :LibrarianAdapter])
  end

  it '#list_from_type' do
    expect(Genfix.list_from_type(test_module_dir, :FixturesAdapter).count).to be > 0
    expect(Genfix.list_from_type(test_module_dir, :LibrarianAdapter).count).to be > 0
  end

  it '#merge_adapter_dependencies' do
    expect(Genfix.merged_list(test_module_dir).count).to eq (6)
  end

  it '#to_fixtures_file' do
    expect(Genfix.to_fixtures_format(test_module_dir)).to eq('')
  end
end
