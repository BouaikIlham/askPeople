Inbox.delete_all

2.times do 
    faker_email = Faker::Internet.email
    user = User.create(email: faker_email, password: Devise.friendly_token[0, 20])
    3.times do
        faker_name = Faker::Quote.famous_last_words
        inbox =  Inbox.create(name: faker_name, user: user)  
            3.times do
                faker_message = Faker::Lorem.paragraph
                Message.create(body: faker_message, inbox: inbox, user: user )
            end
     end
 end
