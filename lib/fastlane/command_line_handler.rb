module Fastlane
  class CommandLineHandler
    # This method handles command line inputs and properly transforms them to a usable format
    # @param [Array] args An array of all arguments (not options)
    # @param [Array] args A hash of all options (e.g. --env NAME)
    def self.handle(args, options)
      lane_parameters = {} # the parameters we'll pass to the lane
      platform_lane_info = [] # the part that's responsible for the lane/platform definition
      args.each do |current|
        if current.include?":" # that's a key/value which we want to pass to the lane
          key, value = current.split(":")          
          raise "Please pass values like this: key:value" unless (key.length > 0 and value.length > 0)
          value = convert_value(value)
          Helper.log.debug "Using #{key}: #{value}".green
          lane_parameters[key.to_sym] = value
        else
          platform_lane_info << current
        end
      end

      platform = nil
      lane = platform_lane_info[1]
      if lane
        platform = platform_lane_info[0]
      else
        lane = platform_lane_info[0]
      end

      dot_env = options.env rescue nil # we don't really care about this option in tests

      Fastlane::LaneManager.cruise_lane(platform, lane, lane_parameters, dot_env)
    end

    private
      # Conert into the right data type
      def self.convert_value(value)
        return true if (value == 'true' or value == 'yes')
        return false if (value == 'false' || value == 'no')
        
        # Default case:
        return value
      end
  end
end