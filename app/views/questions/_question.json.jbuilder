json.extract! question, :id, :text, :options, :string_id, :time_condition, :required_place_types, :additional_place_types, :place_types_to_keep, :created_at, :updated_at
json.url question_url(question, format: :json)