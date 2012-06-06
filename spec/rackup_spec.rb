require "spec_helper"

describe Guard::Rackup do
  subject { Guard::Rackup.new }
  let(:runner) { subject.runner }

  %W!run_all run_on_changes reload!.each do |method|
    it "##{method} call runner#reload" do
      runner.should_receive(:reload)
      subject.__send__(method.to_sym)
    end
  end

  it "#stop call runner#stop" do
    runner.should_receive(:stop)
    subject.stop
  end
end
