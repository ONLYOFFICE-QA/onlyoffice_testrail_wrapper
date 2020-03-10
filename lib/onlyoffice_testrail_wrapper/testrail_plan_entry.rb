# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  class TestrailPlanEntry
    attr_accessor :suite_id, :name, :assigned_to, :include_all, :case_ids, :runs

    def initialize(params = {})
      @suite_id = params.fetch(:suite_id, nil)
      @name = params.fetch(:name, '')
      @include_all = params.fetch(:include_all, true)
      @case_ids = params.fetch(:case_ids, [])
      @assigned_to = params.fetch(:assigned_to, nil)
      @runs = params.fetch(:runs, [])
    end
  end
end
