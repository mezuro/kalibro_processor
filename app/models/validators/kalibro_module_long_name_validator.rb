class KalibroModuleLongNameValidator < ActiveModel::Validator
  def validate(record)
    duplicate_names = KalibroModule.joins(:module_result).where(long_name: record.long_name, 'module_results.processing_id' => record.module_result.processing_id, granularity: record.granularity.to_s).count
    if duplicate_names > 0
      record.errors[:long_name] << 'KalibroModule#long_name should be unique within a processing'
    end
  end
end