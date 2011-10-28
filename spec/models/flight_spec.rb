require 'spec_helper'

describe Flight do
  it { should validate_presence_of :origin }
  it { should validate_presence_of :destination }
  it { should validate_presence_of :date }
end
