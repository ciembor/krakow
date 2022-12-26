desc "Transform location, correct street and extract building number."

task transform_location: [:environment] do
  LocationTransformer::Transformer.new.transform_locations
end
