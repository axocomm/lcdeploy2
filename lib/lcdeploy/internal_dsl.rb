require 'lcdeploy/internal_dsl/step_def'
require 'lcdeploy/logging'

def defstep(name, &block)
  step = LCD::InternalDSL::StepDef.new(name, &block)
  puts "Created #{step}"
  step.classify!
end

%i[debug info warning error].each do |level|
  define_method("log_#{level}".to_sym) { |msg| LCD::Log.log(msg, level) }
end
