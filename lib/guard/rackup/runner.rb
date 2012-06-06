module Guard
  class Rackup
    class Runner
      DEFAULT_OPTIONS = {
        :command => "rackup ./config.ru -E development",
        :start => proc{ Process.spawn(command) },
        :stop => proc{|pid| Process.kill("INT", pid); Process.wait pid},
        :reload => proc{ stop; start },
      }

      attr_reader :pid, :options

      def initialize(options)
        @pid = nil
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def start
        return @pid if alive?
        @pid = instance_eval &@options[:start]
      end

      def stop
        if alive?
          instance_eval do
            @options[:stop].call(@pid)
            @pid = nil
          end
        end
      end

      def reload
        instance_eval &@options[:reload]
      end

      def restart
        stop if alive?
        start
      end

      def command
        @options[:command]
      end

      def alive?
        return false unless @pid

        begin
          Process.getpgid(@pid)
          true
        rescue Errno::ESRCH => e
          false
        end
      end
    end
  end
end
