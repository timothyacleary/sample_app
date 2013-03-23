class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Load the user's profile or where they were trying to go
			sign_in user
			redirect_back_or root_url
		else
			# reload the sign-in page with errors
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
