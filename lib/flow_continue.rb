class FlowContinue
  attr_accessor :state
  attr_reader :flow_id
  
  def initialize(ns, flow_id)
    @ns = ns
    @flow_id = flow_id
    @attribute_holder = {}
  end
  
  public
  def self.instance(session, ns, flow_id = null)

    @ns = ns
    @flow_id = flow_id || self.random_string
    
    ins = session[ns + "_" + @flow_id + "flow_continue"]

    unless ins
      ins = self.new(@ns, @flow_id)
      session[ns + "_" + @flow_id + "flow_continue"] = ins
      ins.set_init(true)
    else
      ins.set_init(false)      
    end

    ins
  end
  
  def set_init(init)
    @init = init
  end
  
  def is_init?
    @init
  end

  def happen_event(event_name, params)
    if (params[event_name.to_s] || params[event_name.to_s + "_x"] || params[event_name.to_s + "_y"])
      true
    else
      false
    end
  end
  
  def set_state(state)
    self.state = state
  end
  
  def remove
    self.clearAttributes
  end
  
  def set_attribute(key, value)
    @attribute_holder[key] = value
  end
  
  def get_attribute(key)
    @attribute_holder[key]
  end
  
  def clear_attributes
    @attribute_holder = {}
  end
  
  def save(session)
    session[@ns + "_" + @flow_id + "flow_continue"] = self
  end
  
  def reset_all(session)
    session[@ns + "_" + @flow_id + "flow_continue"] = nil
  end
  
  def self.random_string (length = 8)
    source=("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a + ["_","-","."]
    key=""
    length.times{ key+= source[rand(source.size)].to_s }
    key
  end
  
end
