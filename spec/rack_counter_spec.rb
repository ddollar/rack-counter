require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rack::Counter" do

  include Rack::Test::Methods

  describe "with no options specified" do
    def app
      Rack::Builder.new do
        use Rack::Counter
        run BlankApplication.new
      end
    end

    describe "when hitting the app several times" do
      before(:each) do
        @stats_before = JSON.parse(get('/_stats.json').body)
        5.times do
          get '/'
        end
        @stats_after = JSON.parse(get('/_stats.json').body)
      end

      it "records the proper number of hits" do
        (@stats_after['hits'] - @stats_before['hits']).should == 5
      end
    end
  end

end
