require 'lcdeploy/internal_dsl/step_def'

def defstep(name, &block)
  step = LCD::InternalDSL::StepDef.new(name, &block)
  puts "Created #{step}"
  step.classify!
end
