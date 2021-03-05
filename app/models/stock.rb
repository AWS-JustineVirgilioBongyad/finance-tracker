class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks

    validates :name, :ticker, presence: true 
    def self.new_lookup(ticker_symbol)
        begin
            client = IEX::Api::Client.new(
                    publishable_token: 'Tpk_f803a2a285884265ab419b4c52f58bfd',
                    endpoint: 'https://sandbox.iexapis.com/v1'
                    )
            new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))    
        rescue => exception
            return nil
        end        
    end 
    
    def self.check_db(ticker_symbol)
        begin
            where(ticker: ticker_symbol).first
        rescue => exception
            return nil
        end
    end
end
