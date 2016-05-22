
def parse_debug_lines(infile)
  ###########################################
  ## Line number and pc

  info = `#{OBJDUMP} --dwarf=decodedline #{infile}`

  def is_number?(string)
    true if Float(string) rescue false
  end

  current_file = nil
  dbg_lines = {}
  info.each_line do |line|
    if line =~ /^CU:\s+(.*):.*$/
      current_file = $1
    elsif line =~/^\s*$/
    elsif current_file
      file, lineno, addr = line.split
      next unless is_number?(lineno)
      if dbg_lines.key? current_file
        dbg_lines[current_file][lineno.to_i] = addr.to_i(16)
      else
        dbg_lines[current_file] = { lineno.to_i => addr.to_i(16) }
      end
    end
  end

  dbg_lines
end
