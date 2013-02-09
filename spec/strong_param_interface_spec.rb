require 'spec_helper'

describe "The Interface for Strong Params" do
  let(:params) do
    MockStrongParams.new({
      :user => {
        :name => "Joe Bloggs",
        :age => 21,
        :phone => "12345",
        :email => "joe@bloggs.com"
      },
      :foo => {
    }
    })
  end

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
