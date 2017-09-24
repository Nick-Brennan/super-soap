class SoapController < ApplicationController
	soap_service namespace: 'urn:WashOut'

	class PersonInfo < WashOut::Type
	  map first_name: :string,
	      last_name: :string,
	      email_address: :string
	end

	class PersonInfoArray < WashOut::Type
	  map :PersonInfo => PersonInfo
	end

	soap_action "simple_signup",
	            :args   => { :first_name => :string,
	            						 :last_name => :string,
	            						 :email_address => :string},
	            :return => {status: :string}

	def simple_signup
		if !params[:first_name] || !params[:last_name] || ! params[:email_address]
			render :soap => {status: "missing required fields"}
		else
			Person.create(first_name: params[:first_name],
										last_name: params[:last_name],
										email_address: params[:email_address])
			render :soap => {status: "person saved"}
		end
	end

	soap_action "get_people",
							:args => {:count => :integer},
							:return => {:PersonInfoArray => {person: [{first_name: :string,
					                                               last_name: :string,
					                                               email_address: :string}]}}

	def get_people
		if !params[:count]
			render :soap => {:PersonInfoArray => {person: []}}
		end
		people = Person.last(params[:count])
		res = []
		people.each do |p|
			res << p.attributes.symbolize_keys.slice(:first_name, :last_name, :email_address)
		end
		render :soap => {:PersonInfoArray => {person: res}}
	end
end
