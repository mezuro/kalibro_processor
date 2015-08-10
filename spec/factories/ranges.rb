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
  factory :range, class: KalibroClient::Entities::Configurations::KalibroRange do
    beginning 1.1
    self.end 5.1
    reading_id 3
    comments "Comment"

    trait :with_id do
      id 1
    end

    trait :another_comment do
      comments "Another Comment"
    end

    trait :another_id do
      id 2
    end

    trait :another_beginning do
      beginning 5.2
    end

    trait :another_end do
      self.end 10.0
    end

    trait :infinite do
      beginning "-INF"
      self.end "INF"
    end

    factory :range_with_id, traits: [:with_id]
    factory :another_range, traits: [:another_comment, :another_id]
    factory :yet_another_range, traits: [:another_beginning, :another_end]
  end
end
