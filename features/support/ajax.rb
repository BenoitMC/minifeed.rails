module CucumberWaitAjaxRequests
  def wait_ajax_requests
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.1 until all_ajax_requests_finished?
    end
  end

  def all_ajax_requests_finished?
    page.evaluate_script('jQuery.active').zero?
  end
end

World(CucumberWaitAjaxRequests)

# Auto wait ajax request between steps
AfterStep do |scenario|
  if page.evaluate_script('typeof jQuery') != "undefined"
    wait_ajax_requests
  end
end
