$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'socket'
require 'logger'

module Prong
  module Server
    class Server
      def initialize(host='', port=6854, log_file=STDOUT, log_level=Logger::DEBUG)
        @logger = Logger.new(log_file)
        @logger.level = log_level
        @logger.debug "Logger initialized"
        
        @socket = UDPSocket.new
        @host, @port = host, port
      end
      
      def bind
        begin
          @socket.bind(@host, @port)
        rescue Exception => e
          @logger.fatal "Bind to #{@host}:#{@port} failed: #{e}"
          @logger << e.backtrace.join("\n")
          return false
        end
        @logger.info "Bound to #{@host}:#{@port}"
      end
      
      def run
        while true
          begin
            packet, sender = @socket.recvfrom(65536)
          rescue Exception => e
            @logger.fatal "Recvfrom failed: #{e}"
            @logger << e.backtrace.join("\n")
            return
          end
          @logger.debug "#{sender} - #{packet.inspect}"
        end
      end
      
      def start
        @logger.info "Starting server..."
        @thread = Thread.new { run }
      end
      
      def stop
        @logger.info "Stopping server..."
        @thread.kill
        @socket.close
      end
    end
  end
end
