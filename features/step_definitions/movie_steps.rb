# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie['title'],
                  :rating => movie['rating'],
                  :description => movie['description'],
                  :release_date => movie['release_date'])
  end

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(%r{,\s*})
  rating_list.each do |rating|
    rating = 'ratings_' + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end


Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Then /^(?:|I )should (not )?see the following movies: (.*)/ do |not_see, text|
  movie_list = text.split(%r{, })
  movie_list.each do |movie|
    if not_see
      if page.respond_to? :should
        page.should have_no_content(movie)
      else
        assert page.has_no_content?(movie)
      end
    else
      if page.respond_to? :should
        page.should have_content(movie)
      else
        assert page.has_content?(movie)
      end
    end
  end
end

And /^(?:|I )press on the homepage "([^"]*)"$/ do |button|
  if button == "Refresh"
    button = 'ratings_submit'
    click_button(button)
  else
    click_button(button)
  end
end
