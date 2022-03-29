require 'open-uri'
require 'net/http'
require 'json'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    
    page = Nokogiri::HTML(open("#{index_url}"))
    student = page.css(".student-card a")
    
    student.collect do |s|
      student_info = {}
      student_info[:location] = s.css(".student-location").text
      student_info[:name] = s.css(".student-name").text
      student_info[:profile_url] = "#{s.attr('href')}"
      student_info 
    end  

  end

  def self.scrape_profile_page(profile_url)

    page = Nokogiri::HTML(open("#{profile_url}"))
    profile_hash = {}

    links = page.css(".social-icon-container").children.css("a").collect{ |x| x.attr('href') }
    links.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link 
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link 
      elsif link.include?("github")
        profile_hash[:github] = link 
      else 
        profile_hash[:blog] = link 
      end 
    end 
    profile_hash[:profile_quote] = page.css(".profile-quote").text 
    profile_hash[:bio] = page.css("div.bio-block.details-block div.description-holder p").text 
    
    profile_hash 

  end

end

