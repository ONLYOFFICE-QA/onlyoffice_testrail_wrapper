# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Methods to perform operations on milestones
  module TestrailProjectMilestoneMethods
    # Get milestone data by parameter
    # @param [String, Integer] name_or_id id or name of milestone
    # @return [TestrailMilestone]
    def milestone(name_or_id)
      case name_or_id.class.to_s
      when 'Fixnum', 'Integer'
        get_milestone_by_id name_or_id
      when 'String'
        init_milestone_by_name name_or_id
      else
        raise 'Wrong argument. Must be name [String] or id [Integer]'
      end
    end

    # Get milestone data by it's name
    # Will create a new one if no one found
    # @param [String] name of milestone
    # @return [TestrailMilestone]
    def init_milestone_by_name(name)
      found_milestone = get_milestone_by_name name
      found_milestone.nil? ? create_new_milestone(name) : found_milestone
    end

    # Get milestone by it's id
    # @param [Integer] id of milestone
    # @return [TestrailMilestone]
    def get_milestone_by_id(id)
      milestone = HashHelper.parse_to_class_variable(Testrail2.http_get("index.php?/api/v2/get_milestone/#{id}"), TestrailMilestone)
      OnlyofficeLoggerHelper.log("Initialized milestone: #{milestone.name}")
      milestone
    end

    # Get milestone data by it's name
    # @param [String] name of milestone
    # @return [TestrailMilestone, nil] result or nil if not found
    def get_milestone_by_name(name)
      get_milestones if @milestones_names.empty?
      @milestones_names[StringHelper.warnstrip!(name.to_s)].nil? ? nil : get_milestone_by_id(@milestones_names[name])
    end

    # Get list of all milestones
    # @return [Array<TestrailMilestone>] list of all milestones
    def get_milestones
      milestones = Testrail2.http_get("index.php?/api/v2/get_milestones/#{@id}")
      @milestones_names = HashHelper.get_hash_from_array_with_two_parameters(milestones, 'name', 'id') if @milestones_names.empty?
      milestones
    end

    # Create new milestone
    # @param [String] name of milestone
    # @param [String] description of milestone
    # @return [TestrailMilestone]
    def create_new_milestone(name, description = '')
      new_milestone = HashHelper.parse_to_class_variable(Testrail2.http_post("index.php?/api/v2/add_milestone/#{@id}", :name => StringHelper.warnstrip!(name.to_s), description => description), TestrailMilestone)
      OnlyofficeLoggerHelper.log "Created new milestone: #{new_milestone.name}"
      new_milestone
    end
  end
end
