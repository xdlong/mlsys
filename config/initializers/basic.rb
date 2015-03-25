require 'basic'
Time.class_eval("def self.demongoize(object);(ret=super(object)) ? ret+(8*60*60) : ret;end")