# encoding: utf-8

class TestrailPlanEntry
  attr_accessor :suite_id, :name, :assigned_to, :include_all, :case_ids, :runs

  def initialize(suite_id = nil, name = '', include_all = true, case_ids = [], runs = [], assigned_to = nil)
    @suite_id = suite_id
    @name = name
    @include_all = include_all
    @case_ids = case_ids
    @assigned_to = assigned_to
    @runs = runs
  end
end
