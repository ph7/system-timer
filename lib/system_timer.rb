require 'rubygems'
require 'timeout'

module SystemTimer 
 class << self

   def timeout_after(seconds)
     install_timer(seconds)
     return yield
   ensure
     cleanup_timer
   end

   protected
   
   def install_ruby_sigalrm_handler
     timed_thread = Thread.current  # Ruby signals are always delivered to main thread by default.
     @original_ruby_sigalrm_handler = trap('SIGALRM') do
        log_timeout_received(timed_thread) if SystemTimer.debug_enabled?
        timed_thread.raise Timeout::Error.new("time's up!")
      end
   end
  
   def restore_original_ruby_sigalrm_handler
     trap('SIGALRM', original_ruby_sigalrm_handler || 'DEFAULT')
   ensure
     reset_original_ruby_sigalrm_handler
   end
   
   def original_ruby_sigalrm_handler
     @original_ruby_sigalrm_handler
   end
 
   def reset_original_ruby_sigalrm_handler
     @original_ruby_sigalrm_handler = nil
   end

   def log_timeout_received(timed_thread)
     puts <<-EOS
       install_ruby_sigalrm_handler: Got Timeout in #{Thread.current}
           Main thread  : #{Thread.main}
           Timed_thread : #{timed_thread}
           All Threads  : #{Thread.list.inspect}
     EOS
   end
 end
end

require 'system_timer_native'