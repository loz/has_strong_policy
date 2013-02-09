require 'spec_helper'

module SecuresParams

  class ExampleParams
    attr_writer :permitted
    def initialize(params = {})
      @params = params
    end

    def [](key)
      @params[key]
    end

    def to_hash
      @params
    end

    def require(key)
      found = @params.fetch(key) { raise 'RequiredMissing' }
      self.class.new found
    end

    def permit(*keys)
      permitted = self.class.new(@params.select {|k,v| keys.include? k})
      permitted.permitted = true
      permitted
    end

    def permitted?
      @permitted
    end
  end

  class ExamplePolicy < Policy
  end

  describe Policy do
    let(:params) do
      ExampleParams.new({
        :user => {
          :name => 'Joe Bloggs',
          :email => 'joe@bloggs.com',
          :age => 21,
          :phone => '12345',
          :role => 'admin'
        },
        :foo => {
          :something => 'bar'
        }
      })
    end

    subject { ExamplePolicy.new params }

    describe "Mocking of StrongParams" do
      it "does require" do
        params.require(:user)[:name].should == 'Joe Bloggs'
        params.require(:foo).should_not be_permitted

        expect { params.require(:not_present) }.to raise_error
      end

      it "does permit" do
        perm = params.require(:user).permit(:name, :age)
        perm.should be_permitted
        perm[:name].should == 'Joe Bloggs'
        perm[:age].should == 21
        perm[:email].should be_nil
      end
    end

    describe "Defining default policy" do
      let(:klass) { ExamplePolicy.dup }
      subject { klass.new params }

      before :each do
        klass.instance_eval do
          required :user
          permitted :name, :age, :phone
        end
      end

      it "is applied to result set" do
        secured = subject.secured
        secured.to_hash.should == {
          :name => 'Joe Bloggs',
          :age => 21,
          :phone => '12345'
        }
        secured.should be_permitted
      end
    end
  end
end
