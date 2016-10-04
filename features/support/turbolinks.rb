module CucumberWaitTurbolinksRequests
  def wait_turbolinks_requests(timeout = Capybara.default_max_wait_time)
    Timeout.timeout(timeout) do
      sleep 0.1 until all_turbolinks_requests_finished?
    end
  end

  def all_turbolinks_requests_finished?
    have_no_selector("html.turbolinks-load")
  end
end

World(CucumberWaitTurbolinksRequests)

# Auto wait turbolinks requests between steps
AfterStep do |scenario|
  if page.evaluate_script('typeof Turbolinks') != "undefined"
    evaluate_script %(
      $(document).on("turbolinks:before-visit", function(){
        $("html").addClass("turbolinks-load")
      })

      $(document).on("turbolinks:load", function(){
        $("html").removeClass("turbolinks-load")
      })
    )

    wait_turbolinks_requests
  end
end
