# frozen_string_literal: true

# Tailwind CSS configuration for Simple Form
SimpleForm.setup do |config|
  # Default class for buttons
  config.button_class = 'btn'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'inline-flex items-center cursor-pointer'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :nested

  # CSS class to add for error notification helper.
  config.error_notification_class = 'bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded'

  # Method used to tidy up errors.
  config.error_method = :to_sentence

  # Add validation classes to `input_field`
  config.input_field_error_class = 'border-red-500'
  config.input_field_valid_class = 'border-green-500'

  # Default wrapper for most inputs
  config.wrappers :tailwind, class: 'mb-4' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-[#1B2B4B] focus:border-[#1B2B4B]', error_class: 'border-red-500'
    b.use :full_error, wrap_with: { tag: :p, class: 'text-xs text-red-600 mt-1' }
    b.use :hint, wrap_with: { tag: :p, class: 'text-xs text-gray-500 mt-1' }
  end

  # Wrapper for boolean/checkbox inputs
  config.wrappers :tailwind_boolean, class: 'mb-4' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: :div, class: 'flex items-center' do |ba|
      ba.use :input, class: 'h-4 w-4 rounded border-gray-300 text-[#1B2B4B] focus:ring-[#1B2B4B] mr-2'
      ba.use :label, class: 'text-sm font-medium text-gray-700'
    end
    b.use :full_error, wrap_with: { tag: :p, class: 'text-xs text-red-600 mt-1' }
    b.use :hint, wrap_with: { tag: :p, class: 'text-xs text-gray-500 mt-1' }
  end

  # Wrapper for select inputs
  config.wrappers :tailwind_select, class: 'mb-4' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-[#1B2B4B] focus:border-[#1B2B4B]', error_class: 'border-red-500'
    b.use :full_error, wrap_with: { tag: :p, class: 'text-xs text-red-600 mt-1' }
    b.use :hint, wrap_with: { tag: :p, class: 'text-xs text-gray-500 mt-1' }
  end

  # Wrapper for file inputs
  config.wrappers :tailwind_file, class: 'mb-4' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:text-sm file:font-medium file:bg-[#1B2B4B] file:text-white hover:file:bg-[#85B7EB]'
    b.use :full_error, wrap_with: { tag: :p, class: 'text-xs text-red-600 mt-1' }
    b.use :hint, wrap_with: { tag: :p, class: 'text-xs text-gray-500 mt-1' }
  end

  # The default wrapper to be used by the FormBuilder
  config.default_wrapper = :tailwind

  # Custom wrappers for input types
  config.wrapper_mappings = {
    boolean:       :tailwind_boolean,
    check_boxes:   :tailwind,
    date:          :tailwind,
    datetime:      :tailwind,
    file:          :tailwind_file,
    radio_buttons: :tailwind,
    range:         :tailwind,
    time:          :tailwind,
    select:        :tailwind_select
  }

  # Browser validations
  config.browser_validations = false
end
