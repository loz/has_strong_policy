require 'spec_helper'

module HasStrongPolicy

  class ExampleController
    include ::HasStrongPolicy::ControllerHelper

    attr_accessor :params

    def initialize(params = {})
      @params = params
    end
  end

  class XYZController < ExampleController; end
  class XYZParamsPolicy; end
  class FooParamsPolicy; end

  describe ControllerHelper do

    describe ".secures_params" do
      let(:klass) { ExampleController.dup }
      subject { klass.new }

      it "adds a policy_params helper into the controller" do
        subject.should_not respond_to :policy_params
        klass.has_strong_policy
        subject.should respond_to :policy_params
      end

      context "when provided :using => " do
        before :each do
          klass.has_strong_policy :using => FooParamsPolicy
        end

        it "uses named constant as the securing class" do
          klass.policy_class.should == FooParamsPolicy
        end
      end
    end

    describe "#policy_params" do
      let(:klass) { XYZController }

      subject { klass.new({:example => :params})}

      before :each do
        klass.has_strong_policy
      end

      it "returns params processed through XYZParamsPolicy for XYZController" do
        policy = stub
        XYZParamsPolicy.should_receive(:new).with(subject.params).and_return(policy)
        policy.should_receive(:apply).and_return({:policy => :params})
        subject.policy_params.should == {:policy => :params}
      end
    end
  end
end
