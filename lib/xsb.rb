require 'dl/import'

$xsb_LIB_NAME = ''
if RUBY_PLATFORM =~ /darwin/i
  $xsb_LIB_NAME = '/xsbinterface.bundle'
elsif RUBY_PLATFORM =~ /win32/i
  $xsb_LIB_NAME = '/xsbinterface.dll'
else
  $xsb_LIB_NAME = '/xsbinterface.so'
end

module XSB
  class XSBQueryError < RuntimeError; end
  class XSBCommandError < RuntimeError; end
  class XSBInitializeError < RuntimeError; end

  class Interface
    attr_accessor :xsb_interface

    # Create a new instance of interface, optionally connecting
    # on creation - default is false.
    def initialize(connect_at_create = nil)
      @xsb_interface = nil
      xsb_init if connect_at_create
    end

    # Consult an XSB .P file, optionally in a directory a_path.
    # If no path is given, the file is assumed to exist in the working
    # directory.
    # Be warned that giving a_path is provided, the class will cd to the
    # directory specified, consult the file, and then cd back.
    def consult(a_p_file, a_path = nil)
      raise(XSBInitializeError, "XSB NOT INITIALIZED!") unless @connection_active
      cpf_func = @xsb_interface['consult_p_file', 'IS']
      if a_path
        cur_path = Dir.pwd
        xsb_command("cd('#{a_path}').")
        cpf_func.call(a_p_file)
        xsb_command("cd('#{cur_path}').")
      else
        cpf_func.call(a_p_file)
      end

    end

    # Execute a vanilla XSB command string.
    def xsb_command(a_xsb_command)
      raise(XSBInitializeError, "XSB NOT INITIALIZED!") unless @connection_active
      g,gs = @xsb_interface['command_xsb', 'IS'].call(a_xsb_command)
      #raise(XSBCommandError, "#{a_xsb_command}: returned #{g.to_s}") if g > 1
      g
    end

    # Execute an XSB query - note that this function expects an XSB
    # expression with a final parameter in which to return the result,
    # i.e.:  my_command(p1, p2, ... , pN, result_param)
    # Returns a string containing the value of the result parameter.
    def xsb_query(a_xsb_query)
      raise(XSBInitializeError, "XSB NOT INITIALIZED!") unless @connection_active
      a_r_str = ''.to_ptr
      g,gs = @xsb_interface['query_xsb', 'ISP'].call(a_xsb_query, a_r_str)
      raise(XSBQueryError, "#{a_xsb_query}: returned #{g.to_s}") if g > 0
      a_r_str.ptr.to_s
    end

    # Initialize an interface.  Will raise an error if the interface is
    # already initialized.
    def xsb_init
      raise(XSBInitializeError, "XSB ALREADY INITIALIZED!") if @connection_active
      @xsb_interface = DL.dlopen(File.dirname(__FILE__) + $xsb_LIB_NAME)
      g = @xsb_interface['initialize_xsb', 'I'].call[0] 
      raise(XSBInitializeError, "XSB FAILED TO INITIALIZE!") if g > 1
      @connection_active = true
    end

    # Disconnect an interface.  Will raise an error if the interface is
    # not connected.
    def xsb_terminate
      raise(XSBInitializeError, "XSB NOT INITIALIZED!") unless @connection_active
      g = @xsb_interface['disconnect_xsb', 'I'].call[0]
      @xsb_interface = nil
      @connection_active = false
    end

    # Is the interface connected?
    def connected?
      @connection_active
    end
    
    private 
    
    attr_accessor :connection_active
  end
end
