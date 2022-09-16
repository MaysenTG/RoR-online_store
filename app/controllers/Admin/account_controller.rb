module Admin
  class AccountController < ApplicationController
    before_action :set_account, only: %i[ show edit update destroy ]
    before_action :check_admin, only: %i[ new edit create update destroy ]
    
    def show
      @account_roles = account_roles.as_json
      #puts @account_roles
      puts current_user.inspect
    end

    def all
      @currently_logged_in = User.find(current_user.id)
      @other_accounts = User.where.not(id: current_user.id)
    end

    def edit
      @account.update(account_params)
      # respond_to do |format|
      #   if @account.update(account_params)
      #     format.html { redirect_to "/admin/account/#{@account.id}", notice: "Account was successfully updated." }
      #   end
      # end
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_account
        @account = User.find(params[:account_id])
      end

      # Only allow a list of trusted parameters through.
      def account_params
        params.require(:user).permit(:name, :role, :email, :account_id)
      end
      
      def check_admin
        unless current_user.role == "admin"
          redirect_to admin_accounts_url, notice: "You are not authorized to edit customers"
        end
      end
  end
end