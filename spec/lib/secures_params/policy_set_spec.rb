require 'spec_helper'

module SecuresParams
  describe PolicySet do
    describe "#with_condition" do
      it "returns the definition for given condition" do
        subject.with_condition(:foo => :base).should respond_to :apply

        subject.with_condition(:foo => :bar).definition.should ==
          subject.with_condition(:foo => :bar).definition

        subject.with_condition(:foo => :bar).definition.should_not ==
          subject.with_condition(:bar => :baz).definition
      end

      context "with a block" do
        it "yields the definition" do
          definition = nil
          subject.with_condition :foo => :bar do |d|
            definition = d.definition
          end

          subject.with_condition(:foo => :bar).definition.should == definition
        end

        it "delegates to the definition" do
          proxy = nil
          subject.with_condition :foo => :bar do |d|
            proxy = d
          end
          defn = mock
          proxy.stub(:definition).and_return(defn)
          defn.should_receive(:apply)
          defn.should_receive(:required)
          defn.should_receive(:permitted)
          proxy.apply(:foo)
          proxy.required(:foo)
          proxy.permitted(:foo)
        end

        it "supports nesting conditions" do
          nested = nil
          subject.with_condition :foo => :bar do |d|
            d.with_condition :bar => :baz do |n|
              nested = n
            end
          end

          expected = nested.definition
          actual = subject.with_condition(:foo => :bar, :bar => :baz).definition

          expected.should == actual
        end
      end
    end
  end
end
