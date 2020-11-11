class Search < ApplicationRecord


	  validates :first_name,presence: true
    validates :last_name,presence: true
    validates :url,presence: true
    validates :email,presence: { message: "No Record found" },uniqueness: true
 

    
	  def self.getData
      response = RestClient::Resource.new(@url)
    end

    def self.retrieve_results(myParameter)
      @api_key = "97cabe244c89fb2e16bbf182ee1b7030" #API KEY
      @url = "https://apilayer.net/api/check?access_key=#{@api_key}&email=#{myParameter}"
      response = Search.getData.get 
      begin
       JSON.parse(response) 
      rescue RestClient::ExceptionWithResponse => e
       e.response
      end
    end


    def self.check_valid_email(str)
      check = Search.retrieve_results(str)
      if check['mx_found'] && check['format_valid'] && check['smtp_check'] 
         str
      end
    end

    def self.valid_email(f_name,l_name,url)
      newArr = []
      email_combinations = [
        "#{f_name}.#{l_name}@#{url}",
        "#{f_name}@#{url}",
        "#{f_name}#{l_name}@#{url}",
        "#{l_name}.#{f_name}@#{url}",
        "#{f_name[0]}.#{l_name}@#{url}",
        "#{f_name[0]}#{l_name[0]}@#{url}"
      ]
      email_combinations.each do |email|
        email = email.downcase
        if(!Search.check_valid_email(email).nil?)
        	newArr << Search.check_valid_email(email)
        	break
        end
      end
      
      newArr.size >= 1 ?  newArr.join(' ') : nil 
    end      
   
	
end
