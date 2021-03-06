Given /I have added "(.*)" with rating "(.*)"/ do |title, rating|
  steps %Q{
    Given I am on the Create New Movie page
    When  I fill in "Title" with "#{title}"
    And   I select "#{rating}" from "Rating"
    And   I press "Save Changes"
  }
end

#Then /I should see "(.*)" before "(.*)" on (.*)/ do |string1, string2, path|
#  step "I am on #{path}"
#  regexp = /#{string1}.*#{string2}/m #  /m means match across newlines
#  page.body.should =~ regexp
#end

# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie.symbolize_keys)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
  regex = Regexp.new(/#{e1}.*#{e2}/m)
  page.body.should =~ regex
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    if uncheck == 'un'
      step %Q{I uncheck "ratings_#{rating}"}
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end
end


Then /I should see all of the movies/ do
  #number of table rows include table head
  page.all("table#movies tr").count.should == 11
end

# currently not working, need to figure out confirm popup
#Given /I have deleted the movie: "(.*)"/ do |title|
#  steps %Q{
#    Given I am on the RottenPotatoes home page
#    And   I follow "More about #{title}"
#    And   I press "Delete"
#    And   I confirm popup
#  }


Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  regex = /#{title}.*Director:\s?#{director}/m
  page.body.should =~ regex
end
