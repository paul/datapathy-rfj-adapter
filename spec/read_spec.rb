require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Reading" do

  describe "all" do
    it 'should work from service descriptors' do
      @clients = Client.all
      @clients.should be_a(Datapathy::Collection)
      @clients.map { |c| c.name }.should include("API")
    end

    it 'should work from a single href' do
      @client = Client.at('http://core.ssbe.localhost/clients/API')
      @client.should be_a(Client)
      @client.name.should == "API"
    end

    it 'should work from a collection href' do
      @hosts = Host.from("http://core.ssbe.localhost/clients/API/hosts")
      @hosts.should be_a(Datapathy::Collection)
      @hosts.to_a
    end
  end

end
