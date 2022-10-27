Inbox.delete_all
5.times do
    faker_name = Faker::Quote.famous_last_words
    Inbox.create(name: faker_name)
end