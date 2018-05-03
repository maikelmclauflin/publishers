class LogException
  def self.call(error, user: {}, params: {}, force: false)
    if Rails.env.production? || force
      NewRelic::Agent.notice_error(error, new_relic_params(user, params))
      Raven.capture_exception(error, sentry_params(user, params))
      true
    end
  end

  private

  def self.new_relic_params(user_params, params)
    formatted = {
      custom_params: params
    }
    formatted[:custom_params].merge(user: user_params) if user_params.present?
    formatted
  end

  def self.sentry_params(user_params, params)
    {
      user: user_params,
      extra: params
    }
  end
end

