require 'basic'
REDIS = Redis.new({host:xiongdl2009.vicp.cc,port:11073})
# Time.class_eval("def self.demongoize(object);(ret=super(object)) ? ret+(8*60*60) : ret;end")