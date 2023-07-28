# frozen_string_literal: true

module OnlyofficeTestrailWrapper
  # Module for working with requests
  module RequestsHelper
    # Send request to Testrail
    # @param [URI] uri uri to send request
    # @param [Net::HTTP::Get, Net::HTTP::Post] request request to send
    # @return [Net::HTTPResponse] response from Testrail
    def self.send_request(uri, request)
      request.basic_auth admin_user, admin_pass
      request.delete 'content-type'
      request.add_field 'content-type', 'application/json'
      is_ssl = (uri.scheme == 'https')
      @connection ||= Net::HTTP.start(uri.host, uri.port, use_ssl: is_ssl)
      @connection.start unless @connection.started?
      attempts = 0
      begin
        response = @connection.request(request)
      rescue Timeout::Error
        attempts += 1
        retry if attempts < 3
        raise 'Timeout error after 3 attempts'
      end
      response
    end

    # Perform http get on address
    # @param [String] request_url to perform http get
    # @return [Hash] Json with result data in hash form
    def http_get(request_url)
      uri = URI get_testrail_address + request_url
      request = Net::HTTP::Get.new uri.request_uri
      response = send_request(uri, request)
      JSON.parse response.body
    end

    # Perform http post on address
    # @param [String] request_url to perform http get
    # @param [Hash] data_hash headers to add to post query
    # @return [Hash] Json with result data in hash form
    def http_post(request_url, data_hash = {})
      uri = URI get_testrail_address + request_url
      request = Net::HTTP::Post.new uri.request_uri
      request.body = data_hash.to_json
      response = send_request(uri, request)
      return if response.body == ''

      JSON.parse response.body
    end
  end
end
