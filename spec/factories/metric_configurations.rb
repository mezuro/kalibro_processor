# This file is part of KalibroGatekeeperClient
# Copyright (C) 2013  it's respectives authors (please see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FactoryGirl.define do
  factory :metric_configuration, class: KalibroClient::Configurations::MetricConfiguration do
    id 1
    code 'code'
    metric { FactoryGirl.build(:metric) }
    metric_collector_name "Analizo"
    weight 1
    aggregation_form :AVERAGE
    reading_group_id 1
    configuration_id 1

    trait :compound_metric do
      metric { FactoryGirl.build(:compound_metric) }
    end

    trait :sum_metric_configuration do
      aggregation_form :SUM
    end

    factory :compound_metric_configuration, traits: [:compound_metric]

    factory :sum_metric_configuration, traits: [:sum_metric_configuration]
  end

  factory :another_metric_configuration, class: KalibroClient::Configurations::MetricConfiguration do
    id 2
    code 'another_code'
    metric { FactoryGirl.build(:metric) }
    metric_collector_name "Analizo"
    weight 1
    aggregation_form :COUNT
    reading_group_id 2
    configuration_id 2
  end
end
