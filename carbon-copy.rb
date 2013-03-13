#!/usr/bin/env ruby

require 'json'
require 'trollop'
require 'httparty'
require 'socket'


def parse_cmd_line
  opts = Trollop::options do
    version "carbon-copy 1.0.0"
    banner <<-EOS
    Carbon-copy allows you to reload an event from graphite to avoid losing resolution due to
    aggregation. The default reloads all the data at once, making it as current as possible.
    You can also choose to replay, which will load each datapoint as if it were occurring live.

    Usage:
       carbon-copy [options] <data_source>
           
    Examples:
       carbon-copy example.json    => Loads data from local file example.json into Graphite
       carbon-copy -r example.json => Loads data as if it were live (i.e. replays the data)

    where [options] are:
    EOS
    opt :host,    "Graphite hostname",               :short => "h", :default => "localhost"
    opt :port,    "Graphite line port",              :short => "p", :default => 2003
    opt :verbose, "Enable verbose output",           :short => "v", :default => false
    opt :replay,  "Replays data as if it were live", :short => "r", :default => false
  end
  opts
end


def read_file(file_name)
  if not(file_name.nil?) && File.exist?(file_name)
    File.open(file_name, "r") do |file|
      data = file.read
      JSON.parse(data)
    end
  else
    Trollop::die "The file #{file_name} does not exist."
  end
end


def graphite_socket(host, port, &f)
  sock = TCPSocket.new(host, port)
  begin
    yield sock
  ensure
    sock.close if sock
  end
end


def load_data(jobj, host, port, verbose, replay, run_time)
  trap("INT") { puts " ABORTED"; exit }
  
  targets    = jobj.size - 1
  datapoints = jobj.first["datapoints"].size - 1
  interval   = jobj.first["datapoints"][1][1] - jobj.first["datapoints"][0][1]
  data_time  = replay ? jobj.first["datapoints"].first[1] : jobj.first["datapoints"].last[1]
  offset     = run_time - data_time

  graphite_socket host, port do |sock|
    for d in 0..datapoints
      for t in 0..targets
        metric   = jobj[t]["target"]
        value    = jobj[t]["datapoints"][d][0]
        new_time = jobj[t]["datapoints"][d][1] + offset
        message  = "#{metric} #{value || 0.0} #{new_time}\n"

        puts message if verbose
        sock.write message
      end
      sleep(interval)
    end
  end  
end


if __FILE__ == $0  
  opts     = parse_cmd_line
  host     = opts[:host]
  port     = opts[:port]
  verbose  = opts[:verbose]
  replay   = opts[:replay]  
  run_time = Time.now.to_i
  jobj     = read_file ARGV[0]
    
  load_data jobj, host, port, verbose, replay, run_time
end