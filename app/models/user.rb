require 'rest-client'

class User < ApplicationRecord

    after_initialize(:set_default_email, { if: :new_record? })
    validates :first_name,presence: true
    validates :last_name,presence: true
    validates :url,presence: true
    validates :email,presence: { message: "No Record found" },uniqueness: true
 


    def self.getData
      response = RestClient::Resource.new(@url)
    end

    def self.retrieve_results(myParameter)
      @url = "https://apilayer.net/api/check?access_key=a8a75592573121b4c822a5206e7d3135&email=#{myParameter}"
      response = User.getData.get
      response.code ? JSON.parse(response) : ''
    end


    def self.check_valid_email(str)
      check = User.retrieve_results(str)
      if check['mx_found'] && check['format_valid'] && check['smtp_check'] 
         str
      end
    end

    def self.valid_email(f_name,l_name,url)
      newArr = []
      email_combination = [
        "#{f_name}.#{l_name}@#{url}",
        "#{f_name}@#{url}",
        "#{f_name}#{l_name}@#{url}",
        "#{l_name}.#{f_name}@#{url}"
        # "#{f_name.chars[0]}#{l_name}@#{url}",
        # "#{f_name.chars[0]}#{l_name.chars[0]}@#{url}"
      ]
      email_combination.each do |email|
        email = email.downcase
        next if User.check_valid_email(email) == nil
        newArr << User.check_valid_email(email)
      end
      newArr
    end      
   
	def set_default_email
		  self.email = "#{first_name}.#{last_name}@#{url}"
  end
end
