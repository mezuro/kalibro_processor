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
  factory :kalibro_configuration, class: KalibroClient::Entities::Configurations::KalibroConfiguration do
    name "Test Kalibro Configuration"
    description "Test Kalibro Configuration."

    trait :with_id do
      id 1
    end

    factory :kalibro_configuration_with_id, traits: [:with_id]
  end

  factory :another_kalibro_configuration, class: KalibroClient::Entities::Configurations::KalibroConfiguration do
    id 12
    name "Perl"
    description "Code metrics for Perl."
  end
end
