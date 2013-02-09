require 'spec_helper'

module SecuresParams

  class ExampleController
    include ::SecuresParams::ControllerHelper

    attr_accessor :params

    def initialize(params = {})
      @params = params
    end
  end

  class XYZController < ExampleController; end
  class XYZParamsSecurer; end

  describe ControllerHelper do

    describe ".secures_params" do
      let(:klass) { ExampleController.dup }
      subject { klass.new }

      it "adds a secured_params helper into the controller" do
        subject.should_not respond_to :secured_params
        klass.secures_params
        subject.should respond_to :secured_params
      end
    end

    describe "#secured_params" do
      let(:klass) { XYZController }

      subject { klass.new({:example => :params})}

      before :each do
        klass.secures_params
      end

      it "returns params processed through XYZParamsSecurer for XYZController" do
        securer = stub
        XYZParamsSecurer.should_receive(:new).with(subject.params).and_return(securer)
        securer.should_receive(:secured).and_return({:secured => :params})
        subject.secured_params.should == {:secured => :params}
      end
    end
  end
end
