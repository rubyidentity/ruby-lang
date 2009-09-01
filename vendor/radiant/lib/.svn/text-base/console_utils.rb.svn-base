autoload 'FileUtils', 'fileutils'
autoload 'Pathname', 'pathname'

module ConsoleUtils
  def stdout
    @stdout ||= $stdout
  end
  
  def stdin
    @stdin ||= $stdin
  end

  def print(*args)
    stdout << args
    stdout.flush
  end
  
  def indent_level
    @indent_level.to_i
  end
  
  def indent_level=(value)
    @indent_level = value.to_i
  end
  
  def indentation
    '  ' * indent_level
  end
  
  def indent
    self.indent_level += 1
    if block_given?
      yield
      unindent
    end
    nil
  end
  
  def unindent
    self.indent_level -= 1
    nil
  end

  def puts(*args)
    args << '' if args.empty?
    print *(args.map { |a| "#{ indentation }#{ a }\n" })
  end
  
  def announce(text)
    puts text
    indent do
      yield
    end
  end
  
  def gets
    stdin.gets
  end

  def ask_yes_or_no(question, default = :yes)
    prompt = (default == :yes) ? "[Yn]" : "[yN]"
    loop do
      print "#{ indentation }#{ question }? #{ prompt } "
      case gets.strip.downcase
      when "yes", "y"
        break true
      when "no", "n"
        break false
      when ""
        break default == :yes
      else
        invalid_option
      end
    end
  end
  
  def copy_files(from, to, options = {})
    ignore = @ignore || []
    make_path(to)
    Dir.foreach(from) do |file|
      unless ignore.include?(file)
        full_name = File.join(from, file)
        if File.directory?(full_name)
          copy_files full_name, File.join(to, file), options
        else
          copy_file full_name, File.join(to, file), options
        end
      end
    end
  end

  def copy_file(from, to, options = {})
    overwrite = options[:overwrite] || @overwrite
    exists = File.file?(to)
    overwrite = (exists and ask_yes_or_no("overwrite #{to}")) unless overwrite
    return unless overwrite or not exists
    make_path(File.dirname(to))
    FileUtils.cp from, to
    action = overwrite ? "overwrote" : "created"
    puts "#{action} #{to}"
  end
  
  def backup_file(filename)
    if File.file?(filename)
      backup = "#{ filename }.#{ Time.now.strftime("%Y%m%d") }.bak"
      FileUtils.cp filename, backup
      puts "backed up #{filename} as #{File.basename(backup)}"
    end
  end

  def make_dir(dir)
    unless File.directory?(dir)
      FileUtils.mkdir dir
      puts "created #{dir}"
    end
  end

  def make_path(path)
    unless File.directory?(path)
      parts = path.split(%r{\\|/})
      if parts.size > 1
        parts.pop
        make_path File.join(*parts)
      end
      make_dir path
    end
  end
  
  def read_file(filename)
    contents = ''
    open(filename) { |f| contents = f.read }
    contents
  end
  
  def write_file(filename, contents)
    open(filename, 'w+') do |file|
      file.puts contents
    end
  end

  def create_file(filename, contents, options = {})
    overwrite = options[:overwrite] || @overwrite
    exists = File.file?(filename)
    overwrite = (exists and ask_yes_or_no("overwrite #{filename}")) unless overwrite
    return unless overwrite or not exists
    write_file(filename, contents)
    puts "created #{filename}"
  end
  
  def remove_file(filename, options = {})
    force = options[:force] || @overwrite
    exists = File.file?(filename)
    force = (exists and ask_yes_or_no("remove #{filename}")) unless force
    return unless exists and force
    FileUtils.rm filename
    puts "removed #{filename}"
  end
  
  def make_executable(filename)
    FileUtils.chmod(0775, filename)
    puts "made #{filename} executable"
  end
  
  def clean_path(path)
    Pathname.new(path).cleanpath(true).to_s unless path.nil?
  end
end