# Impex

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'impex'
```

And then execute:

    $ bundle

## Usage

```ruby
?> rails g impex:install
?> rake db:migrate
?> rake impex:all
```

## How it Works

By default, `impex` looks for CSV files in `public/csv_import/TABLE_NAME/*.csv`. `TABLE_NAME` stands for the name of table (e.g: `users`, ...). Each file may require a header that contains the exact name of the field. If it's not the case, a [hook]() is provided to re-organize the mapping of the file before check. 

Before the update of a field, `impex` will check if csv column value has never been a value of the table field (e.g: Update the email only if has never been an email of the person).

However, it's possible to custom the list of field to look up via a `whitelisting` [config](https://github.com/mehdi-farsi/impex/blob/master/lib/generators/impex/templates/impex.rb). 

By default, the reference field (a unique field that's used as identifier to search in history) corresponds to a field named `reference`.
You can customize the reference for each tables in [config](https://github.com/mehdi-farsi/impex/blob/master/lib/generators/impex/templates/impex.rb).

# Tools

The gem provides 2 tools: a rake tasks and a rails generator.

The rails generator `impex:install` provides 2 files:

```shell
$ rails g impex:install
  create  config/initializers/impex.rb
  create  db/migrate/20160831080017_create_impex_histories.rb
```

The `impex.rb` initializer permits to manage the path of the CSV files and the whitelisting for the history.

```ruby
Impex.configure({
  file_loader: { loader: :file_system, path: "#{Rails.root}public/" },
  history_whitelisting: {
    buildings: [:manager_name],
    people:    [:email, :phone_number, :cell_phone, :address]
  }
})
```

The rake task `impex:all` iterates through each file available in the `path` defined in config.

## Extend functionality

### Internals

The project is based on the principle of "composition over inheritance". There is 3 main entities in the project: the core, the `FileLoader` system and the `HistoryManager` system.

#### FileLoader

The `FileLoader` is in charge of fetching and converting CSV files into a format that the `impex` can consume.
The project provides one file loader by default: `Impex::FileLoader::FileSystem`.

If you want to add a new `FileLoader` (e.g `FileLoader::FileLoader::S3`), you can create a new class that inherits from `Impex::FileLoader::Base` and implements the instance method `#load` that returns an array of `Impex::File`.

In order to ease the convertion of the CSV file to a format that is consumable by the `impex`, the project provides an `Impex::FileFormatter.build(INSTANCE_OF_FILE_CLASS)` method that takes an instance of the ruby `File` class anf returns an `Impex::File` instance.

#### HistoryManager

The `HistoryManager` is in charge of filter csv columns by maintaining an history of the value used in past for each column.
The project provides one history manager by default: `Impex::HistoryManager::ActiveRecord`.

If you want to add a new `HistoryManager` (e.g `FileLoader::HistoryManager::Redis`), you can create a new class that inherits from `Impex::HistoryManager::Base` and implements the instance methods `#filter_data_with_history(row)` and `#update_history(row)`.

Once a new `FileLoader` or `HistoryManager` is added to the project then you can choose it by providing a config (configs name have to be in `underscore` syntax)

```ruby
file_loader: { loader: :s3, path: "#{Rails.root}public/" },
history_manager: { manager: :redis, table: "impex_histories" }
```

### Hooks

The entry point of the project is the method `Impex::Engine.run`. This method accepts a block. The block (that takes a `Impex::Row` instance as parameter) is called just before history checks and insertion of each row.

So you can re-arrange the mapping of the row (recall: each header value has to correspond to a table column name)

```ruby
Impex::Engine.run do |row|
  if row.table == "users"
    row.columns[:email] = row.columns.delete('Company email')
    # ...
  end
end
```

by overriding the method `Impex::Engine#insert_row(record, row)` you can manage the way to update the record according to the filtered row. 

### Contact

Thanks for reading.

[Twitter](https://twitter.com/farsi_mehdi)<br/>
[GitHub](https://github.com/mehdi-farsi/)<br/>
[LinkedIn](https://fr.linkedin.com/in/mehdifarsi)<br/>

