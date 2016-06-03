require 'httpclient'
require 'savon'

class MantisRuby
  def self.issue_in_format(issue={})
    ({id: 1,
        status: "new", 
        summary: "First issue", 
        actual: "Actual result",
        expected: "Expected Result",
        screenresolution: "Give if possible",
        description: ("Description \r\n ---------------- \r\n Actual Result: \r\n Your actual desult will be shown here. \r\n ---------------- \r\n Expected Result:\r\n Expected Result will be shown here \r\n ---------------- \r\n Screen Resolution:\r\n Screen resolution will come here."),
        :steps_to_reproduce => "Step to reproduce",
        :additional_information => "additional_information",
        category: "General" , 
        :add_note=> "bug note", 
        resolution: "screenresolution",
        severity: "10",
        reproducibility: "Reproducibility",
        priority: "10",
        file_location: 'http://dimomohit.com/assets/logo-a40f75aaa7c1d5a2a3f99e8da5e8159c353e407ffdc1c29dfabe43e4c7e8bd41.png',
        content_type: 'png',
        project: {id: "project_id", 
          name: "project_name"
          }
        }).merge(issue)
  end
  def self.hi
    "Hello developer! Welcome to Mantis Ruby Gem."+
    "You can use visit https://github.com/DimoMohit/mantis_ruby any time to get the help."
  end

  def initialize(username,password,wsdl)
    @username=username
    @password=password
    @wsdl=wsdl
    connect_to_tracker
  end

  def connect_to_tracker
    Savon.client(wsdl: "#{@wsdl}/api/soap/mantisconnect.php?wsdl" ) 
  end

  def check_version
    client=connect_to_tracker
    client.call(:mc_version).to_hash[:mc_version_response][:return]
  end

  def get_user_accessible_projects
    client=connect_to_tracker
    @response=client.call(:mc_projects_get_user_accessible,message: {username: @username, 
        password: @password})
    (@response.to_hash)[:mc_projects_get_user_accessible_response][:return]
  end

  def push_all_bugs(bugs)
    bugs.each do |bug|
      push_bug(bug)
      begin
        set_attachment(bug)
      rescue
      end
      # set_priority(bug)
    end
  end

  def push_bug(bug,project_id,project_name)
    client=connect_to_tracker
    @response = client.call(:mc_issue_add, message: {username: @username, 
      password: @password, 
      issue: {status: "#{bug[:status].blank? ? 'new' : bug[:status]}", 
        summary: bug[:summary], 
        description: ("#{bug[:description]} \r\n ---------------- \r\n Actual Result: \r\n #{bug[:actual]} \r\n ---------------- \r\n Expected Result:\r\n #{bug[:expected]} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug[:screenresolution]}"),
        "steps_to_reproduce" => "#{bug[:description]}",
        "additional_information" => "Actual Result: \r\n #{bug[:actual]} \r\n ---------------- \r\n Expected Result:\r\n #{bug[:expected]} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug[:screenresolution]}",
        category: "#{bug[:category].blank? ? 'General' : bug[:category]}" , 
        "add_note"=> bug[:add_note], 
        resolution: bug[:screenresolution],
        severity: "#{bug[:severity].blank? ? '10' : bug[:severity]}",
        reproducibility: "#{bug[:reproducibility].blank? ? '10' : bug[:reproducibility]}",
        priority: "#{bug[:priority].blank? ? '10' : bug[:priority]}",
        project: {id: project_id, 
          name: project_name
          }
        }
      }
    )
    (@response.to_hash)[:mc_issue_add_response][:return]
  end

  def update_bug(bug,project_id,project_name)
    client=connect_to_tracker
    @response = client.call(:mc_issue_update, message: {username: @username, 
      password: @password,
      "issueId" => bug[:id], 
      issue: {status: "#{bug[:status].blank? ? 'new' : bug[:status]}", 
      summary: bug[:summary], 
      description: ("#{bug[:description]} \r\n ---------------- \r\n Actual Result: \r\n #{bug[:actual]} \r\n ---------------- \r\n Expected Result:\r\n #{bug[:expected]} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug[:screenresolution]}"),
      "steps_to_reproduce" => "#{bug[:description]}",
      "additional_information" => "Actual Result: \r\n #{bug[:actual]} \r\n ---------------- \r\n Expected Result:\r\n #{bug[:expected]} \r\n ---------------- \r\n Screen Resolution:\r\n #{bug[:screenresolution]}",
      category: "#{bug[:category].blank? ? 'General' : bug[:category]}" , 
      "add_note"=> bug[:add_note], 
      resolution: bug[:screenresolution],
      severity: "#{bug[:severity].blank? ? '10' : bug[:severity]}",
      reproducibility: "#{bug[:reproducibility].blank? ? '10' : bug[:reproducibility]}",
      priority: "#{bug[:priority].blank? ? '10' : bug[:priority]}",
      project: {id: project_id, 
      name: project_name}}})
    begin
      set_attachment(bug)
    rescue
    end
    # set_priority(bug)
    @response.to_hash
  end

  def set_note(bug,map_bug_id) ########Working
    client=connect_to_tracker
    client.call(:mc_issue_note_add, 
      message: {username: @username, 
        password: @password,
        "issue_id"=>map_bug_id, 
        note: {text: bug.add_note } 
      } 
    ).to_hash
  end

  def set_tag(bug,map_bug_id,tags=[])
    client=connect_to_tracker
    client.call(:mc_issue_set_tags, 
      message: {username: @username, 
        password: @password, 
        "issue_id"=>map_bug_id,
        tags: tags ##Array of tags
      }
    ).to_hash
  end

  def set_priority(bug,map_bug_id,comment) ########Working
    client=connect_to_tracker
    client.call(:mc_issue_note_add, 
      message: {username: @username, 
        password: @password,
        "issue_id"=>map_bug_id, 
        note: {text: comment } 
        } 
    ).to_hash
  end

  def set_attachment(bug,map_bug_id=bug[:id],file_location=bug[:file_location])
    unless file_location.blank?
      client=connect_to_tracker
      begin
        file_name="bug_#{Time.now.to_i}.#{bug[:content_type]}"
        sf = open(file_location, 'rb') { |io| io.read }
        sfile=Base64::encode64(sf)
        client.call(:mc_issue_attachment_add, 
          message: {username: @username, 
            password: @password, 
            "issue_id"=> map_bug_id, 
            name: file_name, 
            "file_type" => bug[:content_type],
            "content"=> sfile
          } 
        ).to_hash
      rescue Exception => e
        puts "File not submitted : #{e}"
      end
    end
  end
  
end