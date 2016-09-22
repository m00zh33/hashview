require 'pony'

def sendEmail(recipient, sub, msg)
  smtp_settings = Settings.first
  smtp_server, smtp_port = smtp_settings.smtp_server.split(':')
  use_tls = true if smtp_settings.smtp_use_tls == '1'
  use_tls = false if smtp_settings.smtp_use_tls == '0'

  if smtp_settings.smtp_auth_type != 'None'
    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address              => smtp_server.to_s,
        :port                 => smtp_port.to_s,
        :enable_starttls_auto => use_tls.to_s,
        :user_name            => smtp_settings.smtp_user.to_s,
        :password             => smtp_settings.smtp_pass.to_s,
        :authentication       => smtp_settings.smtp_auth_type.to_s, 
        :domain               => 'localhost.localdomain'
      }
    }
  else
    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address              => smtp_server.to_s,
        :port                 => smtp_port.to_s,
        :enable_starttls_auto => false
      }
    }
  end

  Pony.mail :to => recipient,
            :from => smtp_settings.smtp_user,
            :subject => sub,
            :body => msg
end