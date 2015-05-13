module Cloudwatch
  module Sender
    module Fetcher
      class EC2
        def initialize(cloudwatch, sender, metric_prefix)
          @cloudwatch = cloudwatch
          @sender = sender
          @metric_prefix = metric_prefix
        end

        def metrics(component_meta, metric)
          ec2_metrics(instance_list(component_meta), component_meta, metric)
        end

        private

        attr_reader :metric_prefix, :cloudwatch, :sender

        START_TIME = 180

        def ec2_metrics(instance_list, component_meta, metric)
          instance_list.each do |instance|
            metric_data = aws_metric_meta(component_meta, metric, instance)
            resp = cloudwatch.get_metric_statistics metric_data
            name_metrics(resp, instance, component_meta["metric_name"], metric["statistics"])
          end
        end

        def aws_metric_meta(component_meta, metric, instance)
          {
            :namespace   => component_meta["namespace"],
            :metric_name => metric["name"],
            :dimensions  => [{ :name => "InstanceId", :value => instance }],
            :start_time  => Time.now - START_TIME,
            :end_time    => Time.now,
            :period      => 60,
            :statistics  => metric["statistics"],
            :unit        => metric["unit"]
          }
        end

        def ec2
          Cloudwatch::Sender::EC2.new
        end

        def instance_list(component_meta)
          ec2.list_instances(component_meta["ec2_component"], component_meta["metric_name"]).flatten
        end

        def name_metrics(resp, instance, name, statistics)
          resp.data["datapoints"].each do |data|
            check_statistics(instance, name, resp.data["label"], statistics, metric_time(data), data)
          end
        end

        def metric_time(data)
          data["timestamp"].to_i
        end

        def check_statistics(instanceid, name, label, statistics, time, data)
          statistics.each do |stat|
            sender.send_tcp("#{metric_prefix}.#{name}.#{instanceid}.#{label.downcase}.#{stat}" " " "#{data[stat.downcase]}" " "  "#{time}")
          end
        end
      end
    end
  end
end
