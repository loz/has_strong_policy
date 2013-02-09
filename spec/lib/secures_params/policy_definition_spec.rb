require 'spec_helper'

describe SecuresParams::PolicyDefinition do
  describe "required" do
    it "adds a required constraint to be applied" do
      subject.required :foo
      params = mock

      params.should_receive(:require).with(:foo).and_return(:applied)

      subject.apply(params).should == :applied
    end
  end

  describe "permitted" do
    it "adds a permitted constraint to be applied" do
      subject.permitted :foo, :bar
      params = mock

      params.should_receive(:permit).with(:foo, :bar).and_return(:permitted)
      subject.apply(params).should == :permitted
    end

    it "appends new directives" do
      subject.permitted :foo, :bar
      subject.permitted :baz
      params = mock

      params.should_receive(:permit).with(:foo, :bar, :baz).and_return(:permitted)
      subject.apply(params).should == :permitted
    end
  end
end
