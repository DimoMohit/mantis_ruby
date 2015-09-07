require 'httpclient'
require 'savon'

class MantisRuby
  	def self.hi
    	puts "Hello world!"
  	end

  	def initialize(username,password,wsdl)
  		@username=username
  		@password=password
  		@wsdl=wsdl
  		puts connect_to_tracker
  	end

  	def connect_to_tracker
		@client = Savon.client(wsdl: "#{self.wsdl}/api/soap/mantisconnect.php?wsdl" ) 
	end

	def check_version
		client=connect_to_tracker
		@response=client.call(:mc_version) 
	end

	def projects_get_user_accessible
		client=connect_to_tracker
		@response=client.call(:mc_projects_get_user_accessible,message: {username: self.client_id, 
				password: self.client_key})
		JSON.parse(@response.to_json)["mc_projects_get_user_accessible_response"]["return"]
	end

	def push_all_bugs
		client=connect_to_tracker
		# self.is_busy = true
		# self.save
		get_cycle_bugs.each do |bug|
			puts "Bug"
			push_bug(bug)
			set_attachment(bug)
			set_priority(bug)
		end
		# self.is_busy = false
		# self.save
	end

	def push_bug(bug)
		client=connect_to_tracker
		@response = client.call(:mc_issue_add, message: {username: self.client_id, 
			password: self.client_key, 
			issue: {status: bug.status, 
				summary: bug.title, 
				description: ("#{bug.description} \r\n ---------------- \r\n Actual Result: \r\n #{bug.actual} \r\n ---------------- \r\n Expected Result:\r\n #{bug.expected} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug.screenresolution}"),
				"steps_to_reproduce" => "#{bug.description}",
				"additional_information" => "Actual Result: \r\n #{bug.actual} \r\n ---------------- \r\n Expected Result:\r\n #{bug.expected} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug.screenresolution}",
				category: "General" , 
				"add_note"=> ((bug.enterprisecyclecomponent.nil?) ? "" : bug.enterprisecyclecomponent.name ), 
				resolution: bug.screenresolution,
				severity: ((bug.btype=="Feature") ? "10" : ((bug.btype=="Technical") ? "60" : ((bug.btype=="GUI") ? "40" : ((bug.btype=="Functional") ? "60" : "50") ))),
				reproducibility: ((bug.freq == "Every Time") ? "10" : ((bug.freq == "Frequently") ? "10" : ((bug.freq == "Rarely") ? "50" : ((bug.freq == "Once") ? "30" : "N/A" )))),
				priority: ((bug.priority==1) ? "50" : ((bug.priority==2) ? "40" : ((bug.priority==3) ? "30" : ((bug.priority==4) ? "20" : "10" ) ))),
				project: {id: self.project_id, 
					name: self.project_name
					}
				}
			}
		)
		return_id=JSON.parse(@response.to_json)["mc_issue_add_response"]["return"]
		@response
	end

	def update_bug(bug_id)
		client=connect_to_tracker
		@response = client.call(:mc_issue_update, message: {username: self.client_id, 
			password: self.client_key,
			"issueId" => map_bug_id, 
			issue: {status: bug.status, 
			summary: bug.title, 
			description: ("#{bug.description} \r\n ---------------- \r\n Actual Result: \r\n #{bug.actual} \r\n ---------------- \r\n Expected Result:\r\n #{bug.expected} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug.screenresolution}"),
			"steps_to_reproduce" => "#{bug.description}",
			"additional_information" => "Actual Result: \r\n #{bug.actual} \r\n ---------------- \r\n Expected Result:\r\n #{bug.expected} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug.screenresolution}",
			category: "General" , 
			"add_note"=> ((bug.enterprisecyclecomponent.nil?) ? "" : bug.enterprisecyclecomponent.name ), 
			resolution: bug.screenresolution,
			severity: ((bug.btype=="Feature") ? "10" : ((bug.btype=="Technical") ? "60" : ((bug.btype=="GUI") ? "40" : ((bug.btype=="Functional") ? "60" : "50") ))),
			reproducibility: ((bug.freq == "Every Time") ? "10" : ((bug.freq == "Frequently") ? "10" : ((bug.freq == "Rarely") ? "50" : ((bug.freq == "Once") ? "30" : "N/A" )))),
			priority: ((bug.priority==1) ? "50" : ((bug.priority==2) ? "40" : ((bug.priority==3) ? "30" : ((bug.priority==4) ? "20" : "10" ) ))),
			project: {id: self.project_id, 
			name: self.project_name}}})
		set_attachment(bug)
		set_priority(bug)
		@response
	end

	def set_note(bug) ########Working
		client=connect_to_tracker
		@response = client.call(:mc_issue_note_add, 
			message: {username: self.client_id, 
				password: self.client_key,
				"issue_id"=>map_bug_id, 
				note: {text: bug.enterprisecyclecomponent.name } 
				} 
			)
	end

	def set_tag(bug)
		client=connect_to_tracker
		@response = client.call(:mc_issue_set_tags, 
			message: {username: self.client_id, 
				password: self.client_key, 
				"issue_id"=>map_bug_id,
				tags: [""] ##Array of tags
			}
		)
		return_id=JSON.parse(@response.to_json)
		puts return_id
		@response
	end

	def set_priority(bug) ########Working
		client=connect_to_tracker
		@response = client.call(:mc_issue_note_add, 
			message: {username: self.client_id, 
				password: self.client_key,
				"issue_id"=>map_bug_id, 
				note: {text: bug.enterprisecyclecomponent.name } 
				} 
			)
	end

	def set_attachment(bug)
		client=connect_to_tracker
		begin
			file_name="bug_#{Time.now.to_i}.#{bug.ext}"
			file_location = bug.cdn_url("enterprisebug_#{bug.id}_#{bug.created_at.to_i}.#{bug.ext}")
			sf = open(file_location, 'rb') { |io| io.read }
			sfile=Base64::encode64(sf)
			@response = client.call(:mc_issue_attachment_add, 
				message: {username: self.client_id, 
					password: self.client_key, 
					"issue_id"=> map_bug_id, 
					name: file_name, 
					"file_type" => bug.content_type,
					"content"=> sfile
				} 
			)
		rescue Exception => e
			puts "File not submitted : #{e}"
		end
	end
	
end