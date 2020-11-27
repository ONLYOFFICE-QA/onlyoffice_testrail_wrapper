# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to perform operations on milestones
  module TestrailProjectMilestoneMethods
    def milestone(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum'
        get_milestone_by_id name_or_id
      when 'String'
        init_milestone_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    def init_milestone_by_name(name)
      found_milestone = get_milestone_by_name name
      found_milestone.nil? ? create_new_milestone(name) : found_milestone
    end

    def get_milestone_by_id(id)
      milestone = HashHelper.parse_to_class_variable(Testrail2.http_get("index.php?/api/v2/get_milestone/#{id}"), TestrailMilestone)
      OnlyofficeLoggerHelper.log("Initialized milestone: #{milestone.name}")
      milestone
    end

    def get_milestone_by_name(name)
      get_milestones if @milestones_names.empty?
      @milestones_names[StringHelper.warnstrip!(name.to_s)].nil? ? nil : get_milestone_by_id(@milestones_names[name])
    end

    def get_milestones
      milestones = Testrail2.http_get("index.php?/api/v2/get_milestones/#{@id}")
      @milestones_names = HashHelper.get_hash_from_array_with_two_parameters(milestones, 'name', 'id') if @milestones_names.empty?
      milestones
    end

    # @param [String] name of milestone
    # @param [String] description of milestone
    def create_new_milestone(name, description = '')
      new_milestone = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/add_milestone/#{@id}", :name => StringHelper.warnstrip!(name.to_s), description => description), TestrailMilestone)
      OnlyofficeLoggerHelper.log "Created new milestone: #{new_milestone.name}"
      new_milestone
    end
  end
end
