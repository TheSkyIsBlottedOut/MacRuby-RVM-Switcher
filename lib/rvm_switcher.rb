module RVMSwitcher
  class << self
    def default_ruby
      File.readlink(self.default_path)
    end
  
    def default_path
      self.path + '/rubies/default'
    end
  
    def hashed_list
      my_default = self.default_ruby
      self.rubies.sort.collect do |rby|
        foldername = rby.split(/\//).last
        next if foldername =~ /^default$/
        {
          path:         rby,
          name:         foldername,
          default:      (rby == my_default)
        }
      end.compact
    end
    
    def rubies
      Dir.glob(self.path + '/rubies/*')
    end
  
    def path
      unless @rvm_path
        @rvm_path ||= `which rvm`.sub(/\/bin\/rvm$/, '')
        @rvm_path.chomp!
      end
      @rvm_path
    end
    
    def switch!(foldername)
      #File.unlink(default_path) if File.exists?(default_path)
      #File.symlink(default_path, "#{self.path}/rubies/#{foldername}")
      `rvm --default use #{foldername}`
    end
  end
end

class RVMTableDelegate
  def initialize
    @data = RVMSwitcher.hashed_list
    @columns = []
  end
  
  def create_columns_for_table(t)
    @columns = [NSTableColumn.alloc.initWithIdentifier('Rubies')]
    @columns.each do |x| 
      x.setWidth(250)
      t.addTableColumn(x)
    end
  end
  
  
  
  def indexes_of_default
    retval = []
    @data.each_with_index do |value, idx|
      retval << idx if value[:default]
    end
    retval
  end
  
  def numberOfRowsInTableView(t)
    @data.length
  end
  
  def tableView(table, objectValueForTableColumn: table_column, row: table_row)
    #return false unless @columns.include?(table_column)
    return false if table_row >= @data.length
    #@data[table_row][:name]
    RVMSwitcher.hashed_list[table_row][:name]
  end
  
  def tableViewSelectionDidChange(notification)
    tableview = notification.object
    RVMSwitcher.switch!(@data[tableview.selectedRow][:name])
  end
end