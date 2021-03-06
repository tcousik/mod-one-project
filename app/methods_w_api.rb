require "pry"
require "rest-client"
require "json"

#I need to pass name into all the methods or set as global variable

#change .new to create with a empty fav word array
#change the empty array to say that there isnt any fav words yet


def mta_hello
  puts "Hello, welcome to the Millenial Translation Service.  Please enter your name"

  name = gets.chomp
  # take the name and search to see if they have an account
  if User.exists?(user_name: name) #if returning user, display options, User.find_user returns the object if found
    puts "Welcome back #{name}"
    mta_step_one(name)
  else  #if the user is new, create a new user
    puts "This is the first time we have seen you #{name}, let's show you around"
    User.create(user_name: name)
    new_user_orientation(name)
  end
end

def mta_step_one(name) #This is the 'main menu' the screen to return
  puts "1 - Search for new word"
  puts "2 - Show favorite words"
  puts "3 - Exit"

  select = gets.chomp

  case select
    when "1"    #Chomp returns a string!!!
      # new word search
      puts "Please enter word to search"
      word = gets.chomp                                   #make everything lowercase to avoid search issues ?
      word_search(word, name)                             #hits word_search to search the words db and api

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite saved words"
      binding.pry
      # User_Favorite.user_fav_list(name)
      # create a method that seaches the user_words table and returns the saved words

    when "3"
      # exit
      puts "Y'all come back now ya hear!!!"

    else
      puts "Sorry I didn't get that, Can you try again?"
      mta_step_one(name)
    end
end

def mta_step_two(word, name)
  puts "1 - Search for new word"
  puts "2 - Show favorite words"
  puts "3 - Add #{word} to favorite words"
  puts "4 - Exit"

  select = gets.chomp

  case select
    when "1" #Chomp returns a string!!!
      # new word search
      puts "Please enter word to search"
      word = gets.chomp  #make everything lowercase to avoid search issues ?
      word_search(word, name) #method that searches the dictionary

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite saved words"
      binding.pry
      mta_step_two(word, name)
      # User_Favorite.user_fav_list(name)
      # create a method that seaches the user_words table and returns the saved words
      # User_Favorite.new_favorite

    when "3"  #add the word to the favorites table and return the favorites
      puts "Adding #{word} to your favorites"
      sleep 1 #wait 1 second
      binding.pry
      # User_Favorite.new_favorite(word, name)

    when "4"
      # exit
      puts "Y'all come back now ya hear!!!"

    else
      puts "Sorry I didn't get that, Can you try again?"
      mta_step_two(word, name)
    end

end


#updated per ActiveRecord
def word_search(word, name)                        #Search the words DB for the word definition.
                                                   #IF the word isn't in the words db then call the API
                                                   #IF the API returns something, store that word in the words DB
                                                   #Return the definition to the user
                                                   #IF nothing is returned ask them to try again

  if Word.exists?(word: word)                      #check the db first
    puts "#{word} means #{Word.find_by(word: word).definition}"
    mta_step_two(word, name)

  elsif GetData.get_word_definition(word)["list"]  #IF not in DB call the API,
                                                   #if it is found, add the word to the words DB and return the definition
    word = GetData.word(word)                      # - the word the API found
    definition = GetData.definition(word)          # - the definition the API found
                                                   # **** I think the word variable is overwritten at this point with the returned word that will be passed to MTA_two
    Word.create(word: word, definition: definition)#create a new word object
    puts "#{word}: #{definition}"                  #return the word and def to the user
    mta_step_two(word, name)
  else
    puts "I dont seem to know that one either. Sorry"
    mta_step_one(word, name)
  end
end

#only used once, when a new user uses it for the fist time
def new_user_orientation(name)
  puts "This is a text dictionary with simple commands"
  puts "When selecting commands input the command number"
  puts "When searching for a word limit to just the word"
  puts "Now that we have you signed up we can keep track"
  puts "of your favorite words.  (limit 10 words)"

  puts "1 - Search for new word"
  puts "2 - Exit"

  select = gets.chomp

  case select
    when "1"    #Chomp returns a string!!!
      # new word search
      puts "Please enter word to search"
      word = gets.chomp  #make everything lowercase to avoid search issues ?
      word_search(word, name) #method that searches the dictionary

    when "2"
      # exit
      puts "Y'all come back now ya hear!!!"

    else
      puts "Sorry I didn't get that, Can you try again?"
      new_user_orientation(name)
  end

end



# APi method

# def get_api_scrape(word)
#
#   url = "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term="  #basic URI for the API endpoint
#
#   @@data = RestClient::Request.execute(method: :get, url: url+word,               #api request for the data
#   headers:{
#     "X-RapidAPI-Host" => "mashape-community-urban-dictionary.p.rapidapi.com",
#     "X-RapidAPI-Key" => "c78a9f92ccmshd2c7b8729d31c74p182394jsnceaa306eed5d"
#   })
#
#   @@response = JSON.parse(@@data)
#
# binding.pry
#
# definition = @@response["list"][0]["definition"]
# #return 1 or 10?
# # https://rapidapi.com/community/api/urban-dictionary
#
# end
