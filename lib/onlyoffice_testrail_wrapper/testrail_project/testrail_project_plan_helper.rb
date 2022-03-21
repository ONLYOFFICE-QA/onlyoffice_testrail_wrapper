# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Mehtods to help working with Plan in Project
  module TestrailProjectPlanHelper
    def plan(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum', 'Integer'
        get_plan_by_id name_or_id
      when 'String'
        init_plan_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    def init_plan_by_name(name)
      found_plan = get_plan_by_name name
      found_plan.nil? ? create_new_plan(name) : found_plan
    end

    def get_plan_by_id(id)
      plan = HashHelper.parse_to_class_variable(Testrail2.http_get("index.php?/api/v2/get_plan/#{id}"), TestrailPlan)
      OnlyofficeLoggerHelper.log("Initialized plan: #{plan.name}")
      raise("`get_plan_by_id(#{id})` return an error: `#{plan.error}`") if plan.error

      plan.entries.each_with_index do |test_entry, index|
        entry = HashHelper.parse_to_class_variable(test_entry, TestrailPlanEntry)
        entry.runs.each_with_index { |run, i| entry.runs[i] = HashHelper.parse_to_class_variable(run, TestrailRun) }
        plan.entries[index] = entry
      end
      plan.instance_variable_set :@project, self
      plan
    end

    def get_plan_by_name(name)
      get_plans if @plans_names.empty?
      @plans_names[StringHelper.warnstrip!(name.to_s)].nil? ? nil : get_plan_by_id(@plans_names[name])
    end

    extend Gem::Deprecate
    deprecate :get_plan_by_name, 'plan_by_name', 2069, 1

    # @param [String] name of plan
    # @return [TestrailPlan, nil] result of plan search
    def plan_by_name(name)
      plans.find { |plan| plan.name == name }
    end

    # Get list of all TestPlans
    # @param filters [Hash] filter conditions
    # @return [Array<Hash>] test plans
    def get_plans(filters = {})
      get_url = "index.php?/api/v2/get_plans/#{@id}"
      filters.each { |key, value| get_url += "&#{key}=#{value}" }
      plans = Testrail2.http_get(get_url)
      @plans_names = HashHelper.get_hash_from_array_with_two_parameters(plans, 'name', 'id') if @plans_names.empty?
      plans
    end

    extend Gem::Deprecate
    deprecate :get_plans, 'plans', 2069, 1

    # Get list of all TestPlans
    # @param filters [Hash] filter conditions
    # @return [Array<TestrailPlan>] test plans
    def plans(filters = {})
      get_url = "index.php?/api/v2/get_plans/#{@id}"
      filters.each { |key, value| get_url += "&#{key}=#{value}" }
      plans = Testrail2.http_get(get_url)
      plans.map { |suite| HashHelper.parse_to_class_variable(suite, TestrailPlan) }
    end

    # @param [String] name of test plan
    # @param [String] description
    # @param [Integer] milestone_id
    def create_new_plan(name, entries = [], description = '', milestone_id = nil)
      new_plan = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/add_plan/#{@id}", name: StringHelper.warnstrip!(name), description: description,
                                                                                                             milestone_id: milestone_id, entries: entries), TestrailPlan)
      OnlyofficeLoggerHelper.log "Created new plan: #{new_plan.name}"
      new_plan.entries.each_with_index do |entry, i|
        new_plan.entries[i] = HashHelper.parse_to_class_variable(entry, TestrailPlanEntry)
        new_plan.entries[i].runs.each_with_index { |run, j| new_plan.entries[i].runs[j] = HashHelper.parse_to_class_variable(run, TestrailRun) }
      end
      @plans_names[new_plan.name] = new_plan.id
      new_plan
    end
  end
end
