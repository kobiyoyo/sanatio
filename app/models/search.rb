class Search < ApplicationRecord
  STATUSES = [:approved,:unapproved].freeze

  # default_scope { where(status: "approved") }

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
    notification = ''
    email_combinations = [
      "#{f_name}.#{l_name}@#{url}",
      "#{f_name}@#{url}",
      "#{f_name}#{l_name}@#{url}",
      "#{l_name}.#{f_name}@#{url}",
      "#{f_name[0]}.#{l_name}@#{url}",
      "#{f_name[0]}#{l_name[0]}@#{url}"
    ]
    email_combinations.each do |email|
      email = email.downcase.strip

      if Search.exists?(email:email)
        @email_status = Search.find_by_email(email)
        if @email_status.status ==  "approved" 
             notification =  'Record already found'
             break
        end
        notification =   "No Record Found"
      else

        if(!Search.check_valid_email(email).nil?)

          Search.create(first_name:f_name.strip,
            last_name:l_name.strip,
            email:email,
            url:url.strip,
            status: :approved)

          notification =  'Search was successfully created.'
          break
        else
            Search.create(first_name:f_name.strip,
            last_name:l_name.strip,
            email:email,
            url:url.strip,
            status: :unapproved)
          
          
        end
        notification =  "No Record Found"
      end

    end
    notification
  end
end
