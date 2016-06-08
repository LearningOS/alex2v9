require 'pathname'
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
    if line =~ /^(CU:\s+)?(\/.*):$/
      current_file = Pathname.new($2).relative_path_from(Pathname.new(__FILE__)).to_s
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

def get_entry_point_file(dbg_lines, address)
  dbg_lines.each do |filename, lines|
    last_addr = lines.first.last
    lines.each do |_line, addr|
      if last_addr <= address && address < addr
        return filename
      end
    end
  end
  nil
end
