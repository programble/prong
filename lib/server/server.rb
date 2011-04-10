$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'socket'
require 'logger'

require 'protocol'

module Prong
  module Server
    class Server
      def initialize(host='', port=6854, log_file=STDOUT, log_level=Logger::DEBUG)
        @logger = Logger.new(log_file)
        @logger.level = log_level
        @logger.debug "Logger initialized"
        
        @socket = UDPSocket.new
        @host, @port = host, port
        
        @clients = {}
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
      
      def send(addr, packet)
        @socket.send(packet, 0, addr[2], addr[1])
      end
      
      def reject_connection(sender)
        send(sender, [Protocol::Replies::CONNECTION_REJECTED, Protocol::VERSION].pack('n n'))
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
          
          command = packet.unpack('n')
          
          # Ignore commands from unconnected users
          if !@clients.include?(sender) && command != Protocol::Commands::CONNECT
            @logger.warn "Received #{packet.inspect} from unconnected client #{sender}"
            next
          elsif command == Protocol::Commands::CONNECT
            command, protocol_version, name = packet.unpack('n n Z*')
            if protocol_version != Protocol::VERSION
              @logger.info "Client rejected: #{sender} '#{name}' #{protocol_version}"
              reject_connection(sender)
              next
            end
          end
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
