module SystemTimer

  # Timer saving associated thread. This is needed because we trigger timers 
  # from a Ruby signal handler and Ruby signals are always delivered to 
  # main thread.
  class ThreadTimer
    attr_reader :trigger_time, :thread
    
    def initialize(trigger_time, thread)
      @trigger_time = trigger_time
      @thread = thread
    end
    
    def to_s
      "<ThreadTimer :time => #{trigger_time}, :thread => #{thread}>"
    end
    
  end
end
