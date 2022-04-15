# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Class for describing milestone data
  class TestrailMilestone < TestrailApiObject
    # @return [Integer] id of milestone
    attr_accessor :id
    # @return [String] name of milestone
    attr_accessor :name
    # @return [String] description of milestone
    attr_accessor :description
    # @return [Boolean] is this milestone completed
    attr_accessor :is_completed

    def initialize(name = '', description = '', is_completed = false, id = nil)
      super()
      @id = id.to_i
      @name = name
      @description = description
      @is_completed = is_completed
    end

    # Update current milestone
    # @param [Boolean] is_completed is milestone should be completed
    # @param [String] name new name of milestone
    # @param [String] description new description of milestone
    # @return [TestrailMilestone] updated milestone data
    def update(is_completed = false, name = @name, description = @description)
      TestrailMilestone.new.init_from_hash(Testrail2.http_post("index.php?/api/v2/update_milestone/#{@id}",
                                                               name: name,
                                                               description: description,
                                                               is_completed: is_completed))
    end

    # Delete current milestone
    # @return [Hash] result of http request
    def delete
      Testrail2.http_post "index.php?/api/v2/delete_milestone/#{@id}", {}
    end
  end
end
