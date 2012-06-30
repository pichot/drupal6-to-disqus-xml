require 'sequel'
require 'mysql2'
require 'yaml'
require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/xml-lib.rb')

config = YAML.load_file File.join(File.dirname(__FILE__), '../config')

# Prepare comments database
db = Sequel.connect(:adapter=>'mysql2', :host=>config['host'], :port=>config['port'], :database=>config['database'], :user=>config['user'], :password=>config['password'])
comments = db[:comments]
comments_query = comments.select(:nid, :timestamp, :cid, :name, :mail, :homepage, :hostname, :comment).qualify_to(:comments).select_append(:title, :created).qualify_to(:node).filter(:status => 0).qualify_to(:comments).join(:node, :nid => :nid).order(:nid.asc).qualify_to(:comments)

$file_counter = 0
$last_nid = 0

comments_query.each do |comment|

  if $last_nid == 0
    create_file
    open_thread(comment)
    add_comment(comment)
  end

  if $last_nid > 0 && $last_nid == comment[:nid]
    add_comment(comment)
  end

  if $last_nid != comment[:nid] && $file.size < 45000000
    close_thread
    open_thread(comment)
    add_comment(comment)
  end

  if $last_nid != comment[:nid] && $file.size > 45000000
    close_file
    create_file
    open_thread(comment)
    add_comment(comment)
  end
end

# IMPORTANT: Close file after last comment has been created.
close_file
