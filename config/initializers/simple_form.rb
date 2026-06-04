# frozen_string_literal: true

SimpleForm.setup do |config|
  # Tailwind CSS wrapper with explicit block display
  config.wrappers :tailwind, class: 'mb-4' do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    # Use label separately with block display
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'

    # Use input separately with block display
    b.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-[#1B2B4B] focus:border-[#1B2B4B]', error_class: 'border-red-500'

    b.use :hint, wrap_with: { tag: :p, class: 'text-xs text-gray-500 mt-1' }
    b.use :error, wrap_with: { tag: :p, class: 'text-xs text-red-600 mt-1' }
  end

  # Default wrapper (keeping for backwards compatibility)
  config.wrappers :default, class: :input,
    hint_class: :field_with_hint, error_class: :field_with_errors, valid_class: :field_without_errors do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :span, class: :hint }
    b.use :error, wrap_with: { tag: :span, class: :error }
  end

  # Set Tailwind as the default wrapper
  config.default_wrapper = :tailwind

  # Default class for buttons
  config.button_class = 'btn'

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :nested

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'error_notification'

  # Default class for the boolean label
  config.boolean_label_class = 'checkbox'

  # Tell browsers whether to use the native HTML5 validations
  config.browser_validations = false
end
