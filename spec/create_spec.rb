require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Creating" do

  it 'should work from service descriptors' do
    @client = Client.create(:name => "test#{Time.now.to_i}",
                            :longname => "Testing Datapathy-RFJ-Adapter",
                            :parent_href => Client.find_by_name("API").href)
    @client.should be_valid
    @client.should_not be_new_record
  end

  it 'should populate errors' do
    @client = Client.create(:name => "API",
                            :longname => "Won't work",
                            :parent_href => Client.find_by_name('API').href)

    @client.should_not be_valid
    @client.errors[:name].should == ["has already been taken"]
  end

end
