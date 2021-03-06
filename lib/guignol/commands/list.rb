# Copyright (c) 2012, HouseTrip SA.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are those
# of the authors and should not be interpreted as representing official policies, 
# either expressed or implied, of the authors.

require 'guignol/commands/base'
require 'guignol/models/instance'
require 'term/ansicolor'

module Guignol::Commands
  class List < Base
    def initialize(*argv)
      argv = ['.*'] if argv.empty?
      super(*argv)
    end

    def run_on_server(config)
      instance = Guignol::Models::Instance.new(config)

      puts "%-#{max_witdth}s %s" % [instance.name, colorize(instance.state)]
    end

    def self.short_usage
      ["[regexp]", "List known instances (matching the regexp) and their status."]
    end

  private

    def max_witdth
      @max_width ||= configs.map { |c| c[:name].size }.max
    end

    def colorize(state)
      case state
        when 'running'            then Term::ANSIColor.green(state)
        when /starting|stopping/  then Term::ANSIColor.yellow(state)
        when 'nonexistent'        then Term::ANSIColor.red(state)
        else state
      end
    end
  end
end

