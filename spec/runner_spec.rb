require "spec_helper"

describe Guard::Rackup::Runner do
  def guard(options = {})
    Guard::Rackup.new([], options)
  end

  let(:runner) { @g.runner }

  describe "default options" do
    before(:each) do
      @g = guard(:command => "sleep 2")
    end

    it "#start return pid" do
      runner.pid.should be_nil
      runner.start.should_not be_nil
      runner.pid.should_not be_nil
    end

    it "#stop" do
      runner.start
      pid = runner.pid
      lambda{ Process.getpgid(pid) }.should_not raise_error
      runner.stop
      lambda{ Process.getpgid(pid) }.should raise_error(Errno::ESRCH)
      runner.pid.should be_nil
    end

    it "#reload" do
      runner.should_receive(:stop)
      runner.should_receive(:start)
      runner.reload
    end

    it "#start" do
      runner.should_not_receive(:stop)
      runner.should_receive(:start)
      runner.restart
    end
  end

  describe "respond to methods" do
    before(:each) do
      $start = nil
      $stop = nil
      $reload = nil
      @g = guard(
        :command => "sleep 3",
        :start => proc{ $start = :called; Process.spawn(command) },
        :stop => proc{ $stop = :called },
        :reload => proc{ $reload = :called },
      )
    end

    it "options[:start]" do
      runner.start
      $start.should_not be_nil
      $stop.should be_nil
      $reload.should be_nil
    end

    it "options[:stop]" do
      runner.start
      runner.stop
      $stop.should_not be_nil
      $reload.should be_nil
    end

    it "options[:reload]" do
      runner.reload
      $reload.should_not be_nil
      $start.should be_nil
      $stop.should be_nil
    end

    it "not call options[:stop] when @pid is nil" do
      runner.stop
      $stop.should be_nil
      $reload.should be_nil
      $start.should be_nil
    end
  end

  context "quality" do
    before(:each) do
      @g = guard(
        :command => "sleep 3",
      )
    end

    it "process killed by external thing" do
      pid = runner.start
      runner.alive?.should be_true
      Process.kill("INT", pid)
      Process.wait pid
      runner.alive?.should be_false
      lambda { runner.stop }.should_not raise_error
    end
  end

end
