# frozen_string_literal: true

require_relative 'bugcrowd/current_jumping_controller_boundary'
require_relative 'bugcrowd/dangerous_env_mutation'
require_relative 'bugcrowd/faker'
require_relative 'bugcrowd/rails_configuration_mutation'

require_relative 'bugcrowd/database'
require_relative 'bugcrowd/dangerous_transaction'
require_relative 'bugcrowd/disable_ddl_only_with_non_ddl_statements'
require_relative 'bugcrowd/prefer_text_to_string_column'
require_relative 'bugcrowd/uuid_primary_key_required'
require_relative 'bugcrowd/no_commit_db_transaction'
require_relative 'bugcrowd/add_index_non_concurrently'

require_relative 'bugcrowd/faker_in_specs'
require_relative 'bugcrowd/faker_without_unique'

require_relative 'bugcrowd/constant_assignment_specs'
require_relative 'bugcrowd/deprecate_ams'
require_relative 'bugcrowd/sleepy_specs'
require_relative 'bugcrowd/can_with_class_const'
require_relative 'bugcrowd/controller_specs'
require_relative 'bugcrowd/flipper_in_app_code'
require_relative 'bugcrowd/travel_to_block_form'

require_relative 'bugcrowd/require_optional_for_belongs_to'
require_relative 'bugcrowd/no_unrestricted_polymorph'
require_relative 'bugcrowd/no_event_deprecated_publish'
require_relative 'bugcrowd/sidekiq_testing_inline'
