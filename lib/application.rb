class Application
  def initialize
    @app = NSApplication.sharedApplication
    @app.delegate = ApplicationDelegate.new
    create_window
    @app.run
  end
  
  #------WINDOW---------
  def create_window
    initialize_window
    @window.title = "RVM Switcher"
    create_table
    display_window
  end
  
  def display_window
    @window.display
    @window.orderFrontRegardless
  end
  
  def initialize_window
    @window = NSWindow.alloc.initWithContentRect([100,100,300,200],
      styleMask:  NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask,
      backing:    NSBackingStoreBuffered,
      defer:      false
    )
    @window.level = NSModalPanelWindowLevel
    @window.delegate = @app.delegate
  end
  
  #-------TABLE---------
  def create_table
    @table = NSTableView.alloc.initWithFrame([0,0,290,190])
    table_delegate = RVMTableDelegate.new
    table_delegate.create_columns_for_table(@table)
    @table.dataSource = table_delegate
    @table.delegate = table_delegate
    @table.reloadData
    a = table_delegate.indexes_of_default
    if a.any?
      my_index_set = NSIndexSet.alloc.initWithIndex(table_delegate.indexes_of_default.first)
      @table.selectRowIndexes(my_index_set, byExtendingSelection: false)
    end
    @window.contentView.addSubview(@table)
  end
end