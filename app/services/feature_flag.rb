# frozen_string_literal: true
class FeatureFlag
  attr_accessor :name, :description, :owner

  def initialize(name:, description:, owner:)
    self.name = name
    self.description = description
    self.owner = owner
  end

  def feature
    Feature.find_or_initialize_by(name:)
  end

  PERMANENT_SETTINGS = [].freeze

  TEMPORARY_FEATURE_FLAGS = [
    [:service_open, "Allow users to access the service", "Malcolm Baig"]
  ].freeze

  FEATURES =
    (PERMANENT_SETTINGS + TEMPORARY_FEATURE_FLAGS)
      .to_h do |name, description, owner|
        [name, FeatureFlag.new(name:, description:, owner:)]
      end
      .with_indifferent_access
      .freeze

  def self.activate(feature_name)
    raise unless feature_name.in?(FEATURES)

    sync_with_database(feature_name, true)
  end

  def self.deactivate(feature_name)
    raise unless feature_name.in?(FEATURES)

    sync_with_database(feature_name, false)
  end

  def self.active?(feature_name)
    raise unless feature_name.in?(FEATURES)

    feature_statuses[feature_name].presence || false
  end

  def self.sync_with_database(feature_name, active)
    feature = Feature.find_or_initialize_by(name: feature_name)
    feature.active = active

    feature.save!
  end

  def self.feature_statuses
    Feature
      .where(name: FEATURES.keys)
      .pluck(:name, :active)
      .to_h
      .with_indifferent_access
  end
end
