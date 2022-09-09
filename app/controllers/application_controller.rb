class ApplicationController < ActionController::Base    
    include ApplicationHelper
    #protect_from_forgery with: :null_session
    
    # Disable protect_from_forgery
    skip_before_action :verify_authenticity_token
    
end
