# Mantis Ruby

[![Join the chat at https://gitter.im/DimoMohit/mantis_ruby](https://badges.gitter.im/DimoMohit/mantis_ruby.svg)](https://gitter.im/DimoMohit/mantis_ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
A gem to pull and push bugs into mantis.

# How to install
gem install mantis_ruby

## Step to Integrate Mantis
###Initialize the MantisRuby

mantis_ruby = MantisRuby.new(username,password,wsdl)

### Connect to Mantis
mantis_ruby.connect_to_tracker

### Check version
mantis_ruby.check_version

### Projects accessible by User
mantis_ruby.projects_get_user_accessible

### push_all_bugs(get_cycle_bugs)

### push_bug(bug)

### update_bug(bug_id)

### set_note(bug)

### set_tag(bug)

### set_priority(bug)

### set_attachment(bug)
