# This class purposes is to be able to execute functions from a single thread
# It is mainly used for the dbus library, which does not react well to
# multithreaded execution

require 'thread'
require 'singleton'

class Henchman
  include Singleton

  def initialize
    @logger = Logger.new("log_henchman")
    @@in_queue = Queue.new
    @@out_queue = Queue.new
    unless defined? @@id
      @@id = 0
    end
  end

  def call_f(func)
    id = do_f(func)
    retrieve(id)
    @logger.info("Retrieved results from instruction n" + id.to_s)
  end

  def do_f (func)
    with_mutex {
    @@in_queue << {id: @@id, f: func}
    @@id += 1 }
    @logger.info("Sent instruction n" + (@@id - 1).to_s)
    @@id - 1
  end

  def retrieve(id)
    loop do
      res = @@out_queue.pop
      if res[:id] == id
        return res[:res]
      else
        @@out_queue << res
      end
    end
  end

  def run
    hench_logger = Logger.new("log2_henchman")
    loop do
      op = @@in_queue.pop
      hench_logger.info("Received instruction n" + op[:id].to_s)
      res = op[:f].call
      hench_logger.info("Called instruction n" + op[:id].to_s)
      @@out_queue << {id: op[:id], res:res}
      hench_logger.info("Returned results of instruction n" + op[:id].to_s)
    end
  end

  private

  def mutex
    @mutex ||= Mutex.new
  end

  def with_mutex
    mutex.synchronize {yield}
  end
end

