include_errors =
  errors \
    .messages
    .map do |attribute, messages|
      messages.map do |message|
        {
          attribute: attribute,
          message: errors.full_message(attribute, message)
        }
      end
    end
json.set! :message, t('api.errors.invalid_request')
json.set! :errors, include_errors.flatten