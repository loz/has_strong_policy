require 'spec_helper'

module HasStrongPolicy

  class ExamplePolicy < Policy
  end

  class AnotherPolicy < Policy
  end

  describe Policy do
    let(:params) do
      MockStrongParams.new({
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

    let(:klass) { ExamplePolicy.dup }
    subject { klass.new }

    it "has unique policy for each subclass" do
      klass1 = ExamplePolicy.dup
      klass2 = AnotherPolicy.dup
      klass1.policy do |p|
        p.required :user
      end
      klass2.policy do |p|
        p.required :foo
      end

      first = klass1.new
      second = klass2.new

      first.apply(params).to_hash.should_not == second.apply(params).to_hash
    end

    describe "Defining default policy" do

      before :each do
        klass.policy do |p|
          p.required :user
          p.permitted :name, :age, :phone
        end
      end

      it "is applied to result set" do
        applied = subject.apply(params)
        applied.to_hash.should == {
          :name => 'Joe Bloggs',
          :age => 21,
          :phone => '12345'
        }
        applied.should be_permitted
      end
    end

    describe "Conditional Policies" do
      describe "on" do
        before :each do
          klass.policy do |p|
            p.required :user
            p.permitted :name, :age, :phone

            p.on :create do |d|
              d.permitted :email
            end
          end
          params[:action] = :create
        end

        it "is applied when action is in params" do
          applied = subject.apply(params)
          applied[:email].should == 'joe@bloggs.com'
        end

        #This not working causes failure above too :(
        it "inherits prior conditions" do
          applied = subject.apply(params)
          applied[:name].should == 'Joe Bloggs'
          applied[:phone].should == '12345'
        end

        it "does not apply when action does not match" do
          params[:action] = :foo
          applied = subject.apply(params)

          applied[:email].should be_nil
        end
      end

      describe "as" do
        before :each do
          klass.policy do |p|
            p.required :user
            p.permitted :name, :age, :phone

            p.as :admin do |d|
              d.permitted :role
            end
          end
        end

        it "is applied when an :as => :role option is supplied" do
          applied = subject.apply(params, :as => :admin)
          applied[:role].should == 'admin'
        end
      end
    end
  end
end
