require File.dirname(__FILE__) + '/../test_helper'

unit_tests do
  
  test "trigger_time returns the time given in the constructor" do
    timer = SystemTimer::ThreadTimer.new(:a_tigger_time, :a_thread)
    assert_equal :a_tigger_time, timer.trigger_time
  end

  test "thread returns the thread given in the constructor" do
    timer = SystemTimer::ThreadTimer.new(:a_tigger_time, :a_thread)
    assert_equal :a_thread, timer.thread
  end

  test "to_s give a human friendly description" do
    assert_match /<ThreadTimer :time => 24, :thread => #<Thread(.*)>>/, 
                 SystemTimer::ThreadTimer.new(24, Thread.current).to_s                 
  end
    
end
