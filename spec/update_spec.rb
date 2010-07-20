require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Updating" do
  before do
    @client = Client.create(:name => "test#{Time.now.to_f.to_s.gsub('.', '')}",
                            :longname => "Testing Datapathy-RFJ-Adapter",
                            :parent_href => Client.find_by_name("API").href)
  end

  it 'should work' do
    @client.longname = "Testing Updates"
    @client.save

    c = Client.detect { |c| c.name == @client.name }
    c.longname.should == "Testing Updates"
  end

  it 'should populate errors' do
    @client.longname = "L#{'o' * 128}ng"
    @client.save
    @client.should_not be_valid
    @client.errors[:longname].first.should =~ /is too long/
  end

end

