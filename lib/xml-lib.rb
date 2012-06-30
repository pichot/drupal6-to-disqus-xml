require 'builder'

def create_file
  $file = File.new("disqusxml-#{$file_counter}.xml", "w+")
  open_xml
  $file_counter += 1
end

def close_file
  close_thread
  close_xml
end

def open_xml
  string = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:dsq="http://www.disqus.com/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:wp="http://wordpress.org/export/1.0/"
>
<channel>
XML

  $file.puts string
end

def close_xml
  string = <<-XML
</channel>
</rss>
XML

  $file.puts string
end

def open_thread(comment)
  post_date_gmt = Time.at(comment[:created]).utc.to_s
  post_date_gmt.slice! " UTC"

  string = <<-XML
<item>
  <title>#{comment[:title]}</title>
  <link>http://spectrummagazine.org/node/#{comment[:nid]}</link>
  <content:encoded><![CDATA[#{comment[:title]}]]></content:encoded>
  <dsq:thread_identifier>node/#{comment[:nid]}</dsq:thread_identifier>
  <wp:post_date_gmt>#{post_date_gmt}</wp:post_date_gmt>
  <wp:comment_status>open</wp:comment_status>
XML

  $file.puts string
end

def close_thread
  $file.puts "</item>"
end

def add_comment(comment)
  post_date_gmt = Time.at(comment[:timestamp]).utc.to_s
  post_date_gmt.slice! " UTC"

  string = String.new
  xml = Builder::XmlMarkup.new(:target => string)

  xml.wp :comment do |x|
    x.wp :comment_id, comment[:cid]
    x.wp :comment_author, comment[:name]
    x.wp :comment_author_email, comment[:mail]
    x.wp :comment_author_url, comment[:homepage]
    x.wp :comment_author_IP, comment[:hostname]
    x.wp :comment_date_gmt, post_date_gmt
    x.wp :comment_content do |cd|
      cd.cdata!(comment[:comment])
    end
    x.wp :comment_approved, 1
    x.wp :comment_parent, 0
  end

  $last_nid = comment[:nid]
  $file.puts string
end