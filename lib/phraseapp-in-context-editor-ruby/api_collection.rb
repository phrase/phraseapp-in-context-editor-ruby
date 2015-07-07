class InContextEditor::ApiCollection

  def initialize(api_client, action, ids=[], query=nil)
    raise "Phraseapp API client can't handle action #{action}" unless api_client.respond_to?(action)

    @api_client = api_client
    @action = action
    @ids = ids
    @query = query
  end

  def collection
    results = []
    page = 1
    per_page = 100
    paginated, err = send_request(page, per_page)
    results << paginated

    while paginated.size == per_page
      break if page > 100

      page = page + 1
      paginated, err = send_request(page, per_page)
      results << paginated if paginated.present?
    end

    results.flatten.uniq
  end

  private

  def send_request(page, per_page)
    if @query.present?
      @api_client.send(@action, *@ids, page, per_page, @query)
    else
      @api_client.send(@action, *@ids, page, per_page)
    end
  end
end