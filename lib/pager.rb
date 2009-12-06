class Pager
  
  attr_accessor :links, :result_list, :current_page, :last_page
    
  
  def initialize(result_list, uri, current_page=1, max_results_per_page=15, filter_result_amount=false)
    @result_list, @max_results_per_page, @current_page, @uri, @filter_result_amount = result_list, max_results_per_page.to_i, current_page.to_i, uri, filter_result_amount
    
	__create
    
  end
  

  

  def __create
    
	self.result_list = []
    self.links = []
    
    return if @result_list.nil? || @result_list.empty?
      
  
    start_inx = (@current_page-1) * @max_results_per_page
    end_inx = start_inx + @max_results_per_page
    
    current_page_results = []
    self.links = []
    
    i = 0
    
    @result_list.each do |r|
      
      if i >= start_inx
        if i < end_inx
          current_page_results << r
        else
          break
        end  
      end
      
      i += 1
    end
    
    self.result_list = current_page_results
    
    pages_size = (@result_list.size.to_f / @max_results_per_page.to_f).ceil.to_i
    
    if pages_size <= 10
      
      (1..pages_size).each do |i|
          if i != @current_page
            self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          else
            self.links << Link.new(true, i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          end
      end
    else
      pages_size_end = pages_size -5
      
      if @current_page < 6
        (1..7).each do |i|
          if i != @current_page
            self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          else
            self.links << Link.new(true, i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          end
        end
        
        self.links << Link.new(false)
        
        i = pages_size-1;
        self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
        self.links << Link.new(pages_size.to_s, @uri.gsub(/%_PAGE/,pages_size.to_s))
        
      elsif @current_page >= pages_size_end    
        self.links << Link.new("1", @uri.gsub(/%_PAGE/,"1".to_s))
        self.links << Link.new("2", @uri.gsub(/%_PAGE/,"2".to_s))
        self.links << Link.new(false)
        
        ((pages_size_end-2)..pages_size).each do |i|
          if i != @current_page
            self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          else
            self.links << Link.new(true, i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          end
        end

      else
        self.links << Link.new("1", @uri.gsub(/%_PAGE/,"1".to_s))
        self.links << Link.new("2", @uri.gsub(/%_PAGE/,"2".to_s))
        self.links << Link.new(false)
        
        
        start_page = @current_page - 2;
        end_page = @current_page + 2;
        
        (start_page..end_page).each do |i|
          if i != @current_page
            self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          else
            self.links << Link.new(true, i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
          end
        end
        
        self.links << Link.new(false)

        i = pages_size-1;
        self.links << Link.new(i.to_s, @uri.gsub(/%_PAGE/,i.to_s))
        self.links << Link.new(pages_size.to_s, @uri.gsub(/%_PAGE/,pages_size.to_s))
      
      end
    end
    
    
    self.current_page = @current_page
    self.last_page = pages_size
  end

  
end



class Link
  
  attr_accessor :is_page, :is_current_page, :label, :uri
  
  def initialize(*args)
     self.is_page = true
     self.is_current_page = false
    
     case args.size
      when 1
         self.is_page = *args
      when 2
         self.label, self.uri = *args
      when 3
         self.is_current_page, self.label, self.uri = *args
    end
    
  end
end