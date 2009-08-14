class FlowState
  attr_reader :state, :template, :event_map
  
  def initialize (state, template)
    @state    = state
    @template = template
    @event_map = {}
  end

  def add_event(event, callable)
    @event_map[event] = callable
  end
  
  def remove_event(event)
    @event_map.delete(event)
  end
end
