# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  class TestrailMilestone
    attr_accessor :id, :name, :description, :is_completed

    def initialize(name = '', description = '', is_completed = false, id = nil)
      @id = id.to_i
      @name = name
      @description = description
      @is_completed = is_completed
    end

    def update(is_completed = false, name = @name, description = @description)
      HashHelper.parse_to_class_variable(Testrail2.http_post('index.php?/api/v2/update_milestone/' + @id.to_s, name: name, description: description,
                                                                                                               is_completed: is_completed), TestrailMilestone)
    end

    def delete
      Testrail2.http_post 'index.php?/api/v2/delete_milestone/' + @id.to_s, {}
    end
  end
end
