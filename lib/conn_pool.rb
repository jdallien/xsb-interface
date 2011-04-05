require File.dirname(__FILE__) + '/xsb'

module XSB

  class NoConnectionsLeftError < Exception; end

  class PoolItem
    attr_accessor :owner
    attr_accessor :last_use
    attr_accessor :xsb_con

    def initialize(connection_timeout = 180)
      @conn_timeout = connection_timeout
      @last_use = nil
      @owner = nil
      @xsb_con = XSB::Interface.new(true)
      yield @xsb_con if block_given?
    end

    def free_if_timed_out
      # HACK: this should not be needed, as
      # self.last_use and self.owner should always assigned or
      # nil together
      @last_use ||= Time.new
      if (Time.new - @last_use) > @conn_timeout
        @owner = nil
        @last_use = nil
      end
    end

    def release
      @owner = nil
      @last_use = nil
    end

  end

  class ConnectionPool
    attr_accessor :items

    def initialize(num_cons = 4, conn_timeout = 180)
      @items = [ ]
      num_cons.times do
        an_item = XSB::PoolItem.new(conn_timeout)
        yield an_item.xsb_con if block_given?
        @items = @items.push(an_item)
      end
    end

    def release_xsb(a_sess_id)
      already_existing_session = (@items.select { |aItm| aItm.owner == a_sess_id }).first
      return(false) unless already_existing_session
      already_existing_session.release
      true
    end

    def get_xsb(a_sess_id)
      a_result = nil
      free_up_timedout
      already_has_one = (@items.select { |aItm| aItm.owner == a_sess_id }).first
      if already_has_one
        a_result = already_has_one
      else
       a_new_conn = (@items.select { |aT| aT.owner.nil? }).first
       raise NoConnectionsLeftError.new("There are no more connections available!") unless a_new_conn
       a_new_conn.owner = a_sess_id
       a_result = a_new_conn
      end
      a_result
    end

    protected

    def free_up_timedout
      owned_items = [ ]
      owned_items = @items.select { |aItm| aItm.owner }
      owned_items.each { |aOI| aOI.free_if_timed_out }
    end

  end

end

