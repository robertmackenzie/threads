Thread.abort_on_exception = true

$file ||= File.open(ARGV[0])

def accept
  [$file.readline, $file.lineno]
end

def work &blk
  blk.call(accept)
end

threads = []
read_lines = []

WORKERS = 50

WORKERS.times do
  threads << Thread.new do
    begin
      work { |line, line_number|
        read_lines << line_number
        puts "line #{line_number}: #{line}"
      }
    rescue EOFError
      puts "No more lines to read. Terminating thread"
      break
    end while true
  end
end

threads.each do |thread|
  thread.join
end

puts "Read lines: #{read_lines.sort}"
