class Application
  attr_reader :name, :instances, :new_relic, :ha_proxy

  def initialize(name:, instances: {}, new_relic: {}, ha_proxy: {})
    @name = name
    @instances = instances
    @new_relic = new_relic
    @ha_proxy = ha_proxy
  end

  # Strange API, but its an easier way to share configs across jobs.
  def self.init
    [
      # Data Object for Zozi.com environment
      new(
        name: 'zozi',
        instances: {
          "i-814e011d" => "stinson-app1",
          "i-834e011f" => "stinson-app2",
          "i-f64e016a" => "stinson-app3",
          "i-f74e016b" => "stinson-app4",
          "i-431659df" => "stinson-load1",
          "i-357c33a9" => "stinson-util1",
          "i-e56d2279" => "stinson-es1"
        },
        new_relic: {
          app_name: "ZOZI (Production)",
          app_id: 161122
        },
        ha_proxy: {
          domain: 'zozi.com',
          status_match: /stinson-(app|cms)[0-4]/
        }
      ),
      # Data Object for a.zozi.com environment
      new(
        name: 'advance',
        instances: {
          "i-023df2e3" => "denali-load1",
          "i-17bb59f9" => "denali-web1",
          "i-1f6863f1" => "denali-web3",
          "i-27bc5ec9" => "denali-web2",
          "i-403754b1" => "denali-util1",
          "i-5830deb6" => "denali-data1"
        },
        new_relic: {
          app_name: "Advance 2.0 (Denali)",
          app_id: 4073662
        },
        ha_proxy: {
          domain: 'a.zozi.com',
          status_match: /denali-web[0-4]/
        }
      )
    ]
  end
end
