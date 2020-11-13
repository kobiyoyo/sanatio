class Search < ApplicationRecord
  STATUSES = [:approved,:unapproved].freeze

  enum status: STATUSES
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :url, presence: true
  validates :email, presence: { message: 'No Record found' }, uniqueness: true

  def self.url_link
    RestClient::Resource.new(@url)
  end

  def self.retrieve_results(my_param)
    @api_key = ENV['API_KEY'] # API KEY
    @url = "https://apilayer.net/api/check?access_key=#{@api_key}&email=#{my_param}"
    response = Search.url_link.get
    begin
      JSON.parse(response)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def self.check_valid_email(str)
    check = Search.retrieve_results(str)
    str if check['mx_found'] && check['format_valid'] && check['smtp_check']
  end

  def self.valid_email(f_name, l_name, url)
    email_data = ''
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

      if Search.exists?(email:email)
        
        if Search.where("email = ? AND status = ?", email , 1)

             flash[:notice] = 'Record already found'
             redirect_to searches_path

        elsif Search.where("email = ? AND status = ?", email , 2)

             flash[:notice] = 'No Record Found'
             redirect_to searches_path
        end
      else

        if(!Search.check_valid_email(email).nil?)
          Search.create(first_name:f_name,last_name:l_name,email:email,status: :approved)
          break
        else
          Search.create(first_name:f_name,last_name:l_name,email:email,status: :unapproved)
        end

      end

    end
  end
end
