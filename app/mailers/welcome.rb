class Welcome < ActionMailer::Base
  default :from => "admin@UniversityCentreConnect.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to UCC")
  end

  def password_recover(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Password Recover")

  end
end
