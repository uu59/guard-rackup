require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class Rackup < Guard
    autoload :Runner, "guard/rackup/runner"

    attr_reader :runner

    def initialize(watchers = [], options = {})
      super(watchers, options)
      @runner = Runner.new(options)
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      run_all if options[:all_on_start]
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    #
    # @raise [:task_has_failed] when stop has failed
    # @return [Object] the task result
    #
    def stop
      @runner.stop
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    #
    # @raise [:task_has_failed] when reload has failed
    # @return [Object] the task result
    #
    def reload
      @runner.reload
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      run_on_changes
    end

    # Default behaviour on file(s) changes that the Guard watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    # @return [Object] the task result
    #
    def run_on_changes(paths = [])
      @runner.reload
    end
  end
end
