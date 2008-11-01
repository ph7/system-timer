module SystemTimer
  class ThreadTimer
    attr_reader :trigger_time, :thread
    
    # Save current thread as Ruby signals are always delivered to main thread.
    def initialize(trigger_time, thread)
      @trigger_time = trigger_time
      @thread = thread
    end
    
    def to_s
      "<ThreadTimer :time => #{trigger_time}, :thread => #{thread}>"
    end
    
  end
end
