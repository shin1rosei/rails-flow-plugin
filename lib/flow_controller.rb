class FlowController < ApplicationController

  attr_reader :continue
  
  public 
  def flow_initialize(ns, init_state)
    @flow = FlowContinue::instance(session, ns, params[:flow_id])
    if @flow.is_init?
      @flow.set_state(init_state)
      @flow.save(session)
    end
    @state_map = {}
  end

  def template
    state = @flow.state

    unless @state_map[state]
      raise sprintf('The state [%s] is not registered', state)
    end
    
    @state_map[state].template
  end
  
  def execute
    state = @flow.state
    unless @state_map[state]
      raise sprintf("The state[%s] is not registered", state)
    end

    @state_map[state].event_map.each do |event, callable|
      if @flow.happen_event(event, params)
        callable.call
        break
      end
    end
    
    self
  end
  
  def add_event(state, event, callback = null)
    unless @state_map[state]
      raise sprintf("The state[%s] is not registered", state)
    end

    @state_map[state].add_event(event, callback)
  end
  
  def remove_event(state, event)
    unless @state_map[state]
      raise sprintf("The state[%s] is not registered", state)
    end

    @state_map[state].remove_event(event, callback)
  end
  
  def add_state(state, template)
    @state_map[state] = FlowState.new(state, template)
  end
  
  def remove_state(state)
    @state_map[state].delete
  end

  def is_init?
    @flow.is_init?
  end
  
  def flow_id
    @flow.flow_id
  end
  
  def set_state(state)
    @flow.set_state(state)
  end
  
  def set_attribute(key, value)
    @flow.set_attribute(key, value)
    @flow.save(session)
  end
  
  def get_attribute(key)
    @flow.get_attribute(key)
  end
  
  def remove_flow
    @flow.reset_all(session)
  end
end 
