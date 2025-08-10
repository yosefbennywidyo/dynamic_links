class Avo::Filters::DynamicLinks::ExpiredFilter < Avo::Filters::BooleanFilter
  self.name = "Expired"

  def apply(request, query, values)
    return query if values[:expired].blank?

    query_strategy = DynamicLinks::Constants::QUERY_STRATEGIES[values[:expired]]
    query_strategy.call(query)
  end

  def options
    {
      expired: "Show expired only"
    }
  end
end
