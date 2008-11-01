 $: << File.dirname(__FILE__) + '/../lib'
 $: << File.dirname(__FILE__) + '/../ext/system_timer'
 $: << File.dirname(__FILE__) + "/../../../vendor/gems/dust-0.1.4/lib"
 $: << File.dirname(__FILE__) + "/../../../vendor/gems/mocha-0.5.3/lib"
require 'test/unit'
require 'system_timer'
require 'dust'
require 'mocha'
require 'stringio'
require "open-uri"
