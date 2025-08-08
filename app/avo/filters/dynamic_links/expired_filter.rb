class Avo::Filters::DynamicLinks::ExpiredFilter < Avo::Filters::BooleanFilter
  self.name = "Expired"

  # A hash to map the filter values to the corresponding query objects.
  QUERY_STRATEGIES = {
    true => ->(query) { query.where("expires_at < ?", Time.current) },
    false => ->(query) { query.where("expires_at IS NULL OR expires_at >= ?", Time.current) }
  }.freeze

  def apply(request, query, values)
    return query if values[:expired].blank?

    query_strategy = QUERY_STRATEGIES[values[:expired]]

    query_strategy.call(query)
  end

  def options
    {
      expired: "Show expired only"
    }
  end
end
