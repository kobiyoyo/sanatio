class Search < ApplicationRecord


	validates :first_name,presence: true
    validates :last_name,presence: true
    validates :url,presence: true
    validates :email,presence: { message: "No Record found" },uniqueness: true
 


	def self.getData
      response = RestClient::Resource.new(@url)
    end

    def self.retrieve_results(myParameter)
      @url = "https://apilayer.net/api/check?access_key=a8a75592573121b4c822a5206e7d3135&email=#{myParameter}"
      response = Search.getData.get
      response.code == 200 ? JSON.parse(response) : 'API request failed'
    end


    def self.check_valid_email(str)
      check = Search.retrieve_results(str)
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
        "#{l_name}.#{f_name}@#{url}",
        "#{f_name[0]}#{l_name}@#{url}",
        "#{f_name[0]}#{l_name[0]}@#{url}"
      ]
      email_combination.each do |email|
        email = email.downcase
        next if Search.check_valid_email(email) == nil
        newArr << Search.check_valid_email(email)
      end
      newArr.size >= 1 ?  newArr : nil 
    end      
   
	
end
