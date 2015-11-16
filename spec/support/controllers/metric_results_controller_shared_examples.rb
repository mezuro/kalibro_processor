shared_examples 'MetricResultsController' do
  describe 'method' do
    let(:model_class) { subject.controller_path.classify.constantize }
    let(:model_factory) { subject.controller_path.singularize }

    describe 'repository_id' do
      let(:metric_result) { FactoryGirl.build(model_factory, id: 1) }
      let(:processing) { FactoryGirl.build(:processing) }
      let(:repository) { FactoryGirl.build(:repository, id: 2) }

      context 'with valid ModuleResult instance' do
        before :each do
          model_class.expects(:find).with(metric_result.id).returns(metric_result)
          metric_result.expects(:processing).returns(processing)
          processing.expects(:repository).returns(repository)

          get :repository_id, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the repository_id' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({repository_id: repository.id}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        let(:error_hash) { {errors: 'RecordNotFound'} }

        before :each do
          model_class.expects(:find).with(metric_result.id).raises(ActiveRecord::RecordNotFound)

          get :repository_id, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'metric_configuration' do
      let!(:metric_result) { FactoryGirl.build(model_factory, id: 1) }

      context 'with valid ModuleResult instance' do
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
        before :each do
          model_class.expects(:find).with(metric_result.id).returns(metric_result)
          metric_result.expects(:metric_configuration).returns(metric_configuration)

          get :metric_configuration, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the metric configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({metric_configuration: metric_configuration}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        let(:error_hash) { {errors: 'RecordNotFound'} }

        before :each do
          model_class.expects(:find).with(metric_result.id).raises(ActiveRecord::RecordNotFound)

          get :metric_configuration, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end
  end
end
