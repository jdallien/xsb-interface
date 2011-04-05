require 'rubygems'
require 'test/unit'
require 'xsb'

class XSBInterfaceTest < Test::Unit::TestCase

  def setup
    @my_interface = XSB::Interface.new(true)
  end

  def teardown
    @my_interface.xsb_terminate
  end

  def test_new_with_init 
    assert @my_interface.connected?
  end

  def test_init_terminate
    @another_interface = XSB::Interface.new
    @another_interface.xsb_init
    @another_interface.xsb_terminate
  end
  
  def test_simple_command
    assert_equal 0,@my_interface.xsb_command("shell('echo FRED').")
  end
  
  def test_command_assertion
    @my_interface.xsb_command('assert(before(1,2)).')
    assert_equal 0,@my_interface.xsb_command('before(1,2).')
    assert_equal 1,@my_interface.xsb_command('before(2,1).')
  end
  
  def test_query
    a_resp = @my_interface.xsb_query('path_sysop(cwd, Fred).')
    assert_kind_of String, a_resp
    assert File.exists?(a_resp)
  end

  def test_trap_segfault
    begin
      @my_interface.xsb_query('shell(\'pwd\').')
      flunk
    rescue
      assert_kind_of XSB::XSBQueryError, $!
    end
  end
end
