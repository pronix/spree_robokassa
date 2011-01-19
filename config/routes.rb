Rails.application.routes.draw do
  # Add your extension routes here
  namespace :gateway do
    match '/robokassa/:gateway_id/:order_id' => 'robokassa#show',    :as => :robokassa
    match '/robokassa/result'                => 'robokassa#result',  :as => :robokassa_result
    match '/robokassa/success'               => 'robokassa#success', :as => :robokassa_success
    match '/robokassa/fail'                  => 'robokassa#fail',    :as => :robokassa_fail
  end

end
