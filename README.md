### Mantis Ruby
A gem to pull and push bugs into mantis.

### How to install
gem install mantis_ruby

### Test in irb
```ruby
% irb
>> require 'mantis_ruby'
=> true
>> MantisRuby.hi
Hello developer! Welcome to Mantis Ruby Gem.
You can use MantisRuby.help any time to get the help.
```

### Issue Format
##### Mantis has some issue format you can have a look at the format using following command
```ruby
MantisRuby.issue_in_format({})
```

Example:
```ruby
> MantisRuby.issue_in_format
 => {:id=>1, :status=>"new", :summary=>"First issue", :actual=>"Actual result", :expected=>"Expected Result", :screenresolution=>"Give if possible", :description=>"Description \r\n ---------------- \r\n Actual Result: \r\n Your actual desult will be shown here. \r\n ---------------- \r\n Expected Result:\r\n Expected Result will be shown here \r\n ---------------- \r\n Screen Resolution:\r\n Screen resolution will come here.", :steps_to_reproduce=>"Step to reproduce", :additional_information=>"additional_information", :category=>"General", :add_note=>"bug note", :resolution=>"screenresolution", :severity=>"10", :reproducibility=>"Reproducibility", :priority=>"10", :file_location=>"http://dimomohit.com/assets/logo-a40f75aaa7c1d5a2a3f99e8da5e8159c353e407ffdc1c29dfabe43e4c7e8bd41.png", :content_type=>"png", :project=>{:id=>"project_id", :name=>"project_name"}}

```
You can edit any of the value and generate a custom issue in the format

Example:
```ruby
> MantisRuby.issue_in_format({:file_location=>"http://rubyonrails.org/images/rails-logo.svg", :content_type=>"svg"})
=> {:id=>1, :status=>"new", :summary=>"First issue", :actual=>"Actual result", :expected=>"Expected Result", :screenresolution=>"Give if possible", :description=>"Description \r\n ---------------- \r\n Actual Result: \r\n Your actual desult will be shown here. \r\n ---------------- \r\n Expected Result:\r\n Expected Result will be shown here \r\n ---------------- \r\n Screen Resolution:\r\n Screen resolution will come here.", :steps_to_reproduce=>"Step to reproduce", :additional_information=>"additional_information", :category=>"General", :add_note=>"bug note", :resolution=>"screenresolution", :severity=>"10", :reproducibility=>"Reproducibility", :priority=>"10", :file_location=>"http://rubyonrails.org/images/rails-logo.svg", :content_type=>"svg", :project=>{:id=>"project_id", :name=>"project_name"}}
```

### Step to Integrate Mantis
#### Class Approach 
#####Initialize the MantisRuby
```ruby
mantis_ruby = MantisRuby.new(username,password,wsdl)
```

##### Connect to Mantis
```ruby
mantis_ruby.connect_to_tracker
```

##### Check version
```ruby
mantis_ruby.check_version
```

##### Projects accessible by User
```ruby
mantis_ruby.projects_get_user_accessible
```

##### push_all_bugs(bugs)
mantis_ruby.push_all_bugs(array_of_bugs)

##### Push issue to Mantis
mantis_ruby.push_bug(bug,project_id,project_name)

Example:
```ruby
> m.push_bug(bug,1,"MyProject")
 => "5" 
```

It returns the id of issue created

##### Update an issue
mantis_ruby.update_bug(bug,project_id,project_name)

##### Upload attachment for an issue
Use following function to upload attachment
```ruby
mantis_ruby.set_attachment(bug,map_bug_id=bug[:id],file_location=bug[:file_location])
```
Example:

```ruby
> bug=MantisRuby.issue_in_format({id: 4})
 => {:id=>4, :status=>"new", :summary=>"First issue", :actual=>"Actual result", :expected=>"Expected Result", :screenresolution=>"Give if possible", :description=>"Description \r\n ---------------- \r\n Actual Result: \r\n Your actual desult will be shown here. \r\n ---------------- \r\n Expected Result:\r\n Expected Result will be shown here \r\n ---------------- \r\n Screen Resolution:\r\n Screen resolution will come here.", :steps_to_reproduce=>"Step to reproduce", :additional_information=>"additional_information", :category=>"General", :add_note=>"bug note", :resolution=>"screenresolution", :severity=>"10", :reproducibility=>"Reproducibility", :priority=>"10", :file_location=>"http://dimomohit.com/assets/logo-a40f75aaa7c1d5a2a3f99e8da5e8159c353e407ffdc1c29dfabe43e4c7e8bd41.png", :content_type=>"png", :project=>{:id=>"project_id", :name=>"project_name"}} 

> mantis_ruby.set_attachment(bug)
 => {:mc_issue_attachment_add_response=>{:return=>"2"}} 

```

##### Ser Note for an issue
mantis_ruby.set_note(bug)

##### Set tag for an issue
mantis_ruby.set_tag(bug)

##### Set Priority of an issue
mantis_ruby.set_priority(bug)

