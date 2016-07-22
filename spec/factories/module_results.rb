FactoryGirl.define do
  factory :module_result do
    kalibro_module { FactoryGirl.build(:kalibro_module) }
    parent nil
    grade 10.0
    tree_metric_results { [FactoryGirl.build(:tree_metric_result)] }
    hotspot_metric_results { [FactoryGirl.build(:hotspot_metric_result)] }
    processing { FactoryGirl.build(:processing, :with_id) }

    trait :class do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:class_granularity)) }
    end

    trait :package do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:package_granularity)) }
    end

    trait :software do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:software_granularity)) }
    end

    trait :with_id do
      sequence(:id, 1)
    end

    trait :kalibro_module_with_id do
      kalibro_module { FactoryGirl.build(:kalibro_module_with_id) }
    end

    trait :without_results do
      tree_metric_results []
      hotspot_metric_results []
    end

    factory :module_result_class_granularity, traits: [:class]
    factory :module_result_with_id, traits: [:with_id]
    factory :module_result_with_kalibro_module_with_id, traits: [:kalibro_module_with_id]
    initialize_with { ModuleResult.new({parent: parent, kalibro_module: kalibro_module}) }
  end

  # This factory is used to DRY the logic for creating MetricResult trees, so all methods that need them can become
  # simpler.
  # Input/output attributes:
  # - height:     the height the produced tree shall have. The root is included, so the minimum height is 1.
  # - width:      how many child nodes each non-leaf node should have. The total number of nodes will be (2 ** height) - 1
  # - with_ids:   whether to assign IDs to all the nodes. Only set it for test data that won't be saved to the DB.
  # - processing: the processing to set to all the nodes
  # - root:       the root node of the tree
  # Output attributes:
  # - all:        a list of all nodes in the three
  # - levels:     a list of lists of a breadth-firt search. The first list will contain only the root, the second the
  #               root's children, the third the root's grandchildren, and so forth.
  factory :module_results_tree, class: OpenStruct do
    height 3
    width 2
    with_ids false

    trait :with_id do
      with_ids true
    end

    transient do
      processing { build(:processing, root_module_result: root) }
    end

    root { build(:module_result, :without_results, *(with_ids ? [:with_id] : []), parent: nil) }

    after(:build) do |tree, evaluator|
      tree.root.processing = evaluator.processing

      parents = [tree.root]
      tree.all = [tree.root]
      tree.levels = [[tree.root]]

      (evaluator.height - 1).times.each do |_|
        parents = parents.flat_map do |parent|
          # Ensure AR won't look into the database for children - we're faking IDs, it makes no sense to query for them
          parent.association(:children).loaded! if evaluator.with_ids

          evaluator.width.times.map do |_|
            parent.children.build(attributes_for(:module_result, :without_results,
                                                 *(evaluator.with_ids ? [:with_id] : []),
                                                 parent: parent, processing: parent.processing))
          end
        end

        tree.all += parents
        tree.levels << parents
      end
    end
  end
end
